// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// --
// -- Health Data Services : Training environment starter template
// --

// -- parameter definitions
@description('Tags to be applied to resources that are deployed in this template')
param resourceTags object  = {
  environmentName: 'Azure Health Data Services OpenHack'
  challengeTitle: 'Deploy Core Training Environment'
  expirationDate: '06/30/2022'
}
@description('Deployment Prefix - all resources names created by this template will start with this prefix')
@minLength(3)
@maxLength(7)
param deploymentPrefix string
@description('FHIR Server Azure AD Tenant ID (GUID)')
param fhirServerTenantName string = subscription().tenantId
@description('Azure Region where the resources will be deployed. Default Value:  the resource group region')
param resourceLocation string = resourceGroup().location
@description('Enable the Consent Opt Out module in FHIR PROXY')
param enableConsentOptOut bool = false
@description('Enable the Date Sort module in FHIR PROXY')
param enableDateSort bool = false
@description('Enable the Participant Filter module in FHIR PROXY')
param enableParticipantFilter bool = false
@description('Enable the FHIR to CDS Sync Agent module in FHIR PROXY')
param enableFhirCdsSyncAgent bool = false
@description('Enable the Pubish FHIR Event module in FHIR PROXY')
param enablePublishFhirEvent bool = false
@description('Enable the Profile Validation module in FHIR PROXY')
param enableProfileValidation bool = false
@description('Enable the Transform Bundle module in FHIR PROXY')
param enableTransformBundle bool = true
@description('Enable the Patient Everything module in FHIR PROXY')
param enableEverythingPatient bool = false
@description('Configure FHIR Proxy to use Managed Service Identity (MSI) to access FHIR Server')
param useMSI bool = true

// -- variables
var uniqueId  = toLower(take(uniqueString(subscription().id, resourceGroup().id, deploymentPrefix),6))
// -- resource names
var fhirProxyAppName         = '${deploymentPrefix}${uniqueId}pxyfa'
var fhirLoaderAppName        = '${deploymentPrefix}${uniqueId}ldrfa'
var fhirSynapseAppName       = '${deploymentPrefix}${uniqueId}synfa'
var redisCacheName           = '${deploymentPrefix}${uniqueId}rc'
var appServicePlanName       = '${deploymentPrefix}${uniqueId}asp'
var proxyAppInsightName      = '${deploymentPrefix}${uniqueId}pxyai'
var loaderAppInsightName     = '${deploymentPrefix}${uniqueId}ldrai'
var loaderEventGridTopicName = '${deploymentPrefix}${uniqueId}ldrtopic'

// API for FHIR artifact container registry name
var containerRegistryName   = '${deploymentPrefix}${uniqueId}cr'
// -- containers to be created in export storage account
var dataLakeContainerName = 'fhirdatalake'

// -- storage account names
var exportStorageAccountName = '${deploymentPrefix}${uniqueId}expsa'
var functionsStorageAccountName = '${deploymentPrefix}${uniqueId}funsa'
var importStorageAccountName = '${deploymentPrefix}${uniqueId}impsa'

var tenantId = subscription().tenantId
// -- fhir synapse link settings
var dataStart = '1970-01-01 00:00:00 +00:00'
var dataEnd = ''


var logAnalyticsConfig = {
  name:'${deploymentPrefix}${uniqueId}la'
  diagnosticsSettingsName: 'defaultSettings'
  enableDiagnostics: true
}
var keyVaultConfig = {
  name: '${deploymentPrefix}${uniqueId}kv'
  diagnosticsSettingsName: 'defaultSettings'
  enableDiagnostics: true
}
var healthDataServicesConfig = {
  name:'${deploymentPrefix}${uniqueId}hdsws'
}
var fhirServiceConfig = {
  name: 'fhirtrn'
  url: 'https://${healthDataServicesConfig.name}-fhirtrn.fhir.azurehealthcareapis.com'
  kind: 'fhir-R4'
  version: 'R4'
  loginServers: [
    '${artifactContainerRegistry.name}.azurecr.io'
  ]
  systemIdentity: {
    type: 'SystemAssigned'
  }
}
var fhirProxyConfig = {
  name: fhirProxyAppName
  url: 'https://${fhirProxyAppName}.azurewebsites.net'
  repoUrl: 'https://github.com/microsoft/fhir-proxy'
  repoBranch: 'main'
  enableDiagnostics: true
  diagnosticsSettingsName: 'defaultSettings'
  enableAppInsights: true
  appInsightsName: '${deploymentPrefix}${uniqueId}pxyai'
}
var fhirLoaderConfig = {
  name: fhirLoaderAppName
  url: 'https://${fhirLoaderAppName}.azurewebsites.net'
  repoUrl: 'https://github.com/microsoft/fhir-loader'
  repoBranch: 'main'
  enableDiagnostics: true
  diagnosticsSettingsName: 'defaultSettings'
  enableAppInsights: true
  appInsightsName: '${deploymentPrefix}${uniqueId}ldrai'
  enabled: true
}
var fhirSynapseLinkConfig = {
  name: fhirSynapseAppName
  url: 'https://${fhirSynapseAppName}.azurewebsites.net'
  repoUrl: 'https://github.com/microsoft/FHIR-Analytics-Pipelines'
  repoBranch: 'main'
  enableDiagnostics: true
  diagnosticsSettingsName: 'defaultSettings'
  enableAppInsights: true
  appInsightsName: '${deploymentPrefix}${uniqueId}ldrai'
  dataLakeEndpoint: 'https://${exportStorageAccount.name}.blob.${environment().suffixes.storage}'
  dataLakeContainerName: empty(dataLakeContainerName) ? 'fhirdatalake' : toLower(dataLakeContainerName)
  enabled: true
  dataStart: empty(dataStart) ? '' : dataStart
  dataEnd: empty(dataEnd) ? '' : dataEnd
  // fhir service configuration settings
  fhirServiceUrl: fhirServiceConfig.url
  fhirServiceVersion: fhirServiceConfig.version
  packageUri:'https://fhirdeploy.blob.${environment().suffixes.storage}/fhir/Microsoft.Health.Fhir.Synapse.FunctionApp.zip'
  useMSI: true
}

var dataLakeSyncAppName = 'workbenchfhirsynapsesyncapp'

var exportStorageContainerList = [
  'anonymization'
  'export'
  'export-trigger'
  fhirSynapseLinkConfig.dataLakeContainerName
]
var importStorageContainerList = [
  'bundles'
  'ndjson'
  'zip'
]

// -- other variables
var functionPlanOS = 'Windows'

// -- Log Analytics Workspace and diagnostics
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: logAnalyticsConfig.name
  location: resourceLocation
  tags: resourceTags
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}
resource logAnalyticsWorkspaceDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = if(logAnalyticsConfig.enableDiagnostics){
  scope: logAnalyticsWorkspace
  name: logAnalyticsConfig.diagnosticsSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'Audit'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
  }
}
// -- deploy Azure Key Vault and enable diagnostics settings
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' =  {
  name: keyVaultConfig.name
  location: resourceLocation
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    softDeleteRetentionInDays: 7
    enableSoftDelete: true
    enableRbacAuthorization: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}
resource keyVaultDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if(keyVaultConfig.enableDiagnostics){
  scope: keyVault
  name: keyVaultConfig.diagnosticsSettingsName
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// -- create storage accounts
// -- functions storage account
resource functionsStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: functionsStorageAccountName
  location: resourceLocation
  tags: resourceTags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    isHnsEnabled: false
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
  }
}
resource functionsBlobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: '${functionsStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource functionsFileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  name: '${functionsStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource functionsQueueServices 'Microsoft.Storage/storageAccounts/queueServices@2021-06-01' = {
  name: '${functionsStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
resource functionsTableServices 'Microsoft.Storage/storageAccounts/tableServices@2021-06-01' = {
  name: '${functionsStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
resource storageAcountDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: functionsStorageAccount
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource functionsStorageAccountBlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: functionsBlobServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource functionsStorageAccountFileDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: functionsFileServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource functionsStorageAccountTableDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: functionsTableServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource functionsStorageAccountQueueDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: functionsQueueServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// -- export storage account
resource exportStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: exportStorageAccountName
  location: resourceLocation
  tags: resourceTags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    isHnsEnabled: true
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
  }
}
// Blob Services for Storage Account
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: '${exportStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource createBlobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = [for containerName in exportStorageContainerList: {
  name: '${exportStorageAccount.name}/default/${containerName}'
}]
resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  name: '${exportStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource queueServices 'Microsoft.Storage/storageAccounts/queueServices@2021-06-01' = {
  name: '${exportStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
resource tableServices 'Microsoft.Storage/storageAccounts/tableServices@2021-06-01' = {
  name: '${exportStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
// enable diagnostics for export storage account
resource exportSADiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: exportStorageAccount
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource exportSABlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: blobServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource exportSAFileDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: fileServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource exportSATableDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: tableServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource exportSAQueueDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: queueServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// -- import storage account
resource importStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: importStorageAccountName
  location: resourceLocation
  tags: resourceTags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    isHnsEnabled: true
    isNfsV3Enabled: false
    minimumTlsVersion: 'TLS1_2'
  }
}
// Blob Services for Storage Account
resource importBlobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: '${importStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource createImportBlobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = [for containerName in importStorageContainerList: {
  name: '${importStorageAccount.name}/default/${containerName}'
}]
resource importFileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-06-01' = {
  name: '${importStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
resource importQueueServices 'Microsoft.Storage/storageAccounts/queueServices@2021-06-01' = {
  name: '${importStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
resource importTableServices 'Microsoft.Storage/storageAccounts/tableServices@2021-06-01' = {
  name: '${importStorageAccount.name}/default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
// enable diagnostics for import storage account
resource importSADiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: importStorageAccount
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource importSABlobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: importBlobServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource importSAFileDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: importFileServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource importSATableDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: importTableServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource importSAQueueDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: importQueueServices
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// -- Azure Container Registry
resource artifactContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name:containerRegistryName
  tags: resourceTags
  location: resourceLocation
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
    anonymousPullEnabled: false
  }
}
// -- enable diagnostics for container registry
resource artifactContainerRegistryDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: artifactContainerRegistry
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}

//  -- Health Data Services Resources
// -- deploy Health Data Services Workspace
resource healthDataWorkspace 'Microsoft.HealthcareApis/workspaces@2021-11-01' = {
  name: healthDataServicesConfig.name
  tags: resourceTags
  location: resourceLocation
  properties:{
    publicNetworkAccess: 'Enabled'
  }
}
// -- deploy FHIR Service
resource fhirService 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' = {
  name: fhirServiceConfig.name
  tags: resourceTags
  location: resourceLocation
  parent: healthDataWorkspace
  identity: fhirServiceConfig.systemIdentity
  kind: fhirServiceConfig.kind
  properties:{
    exportConfiguration:{
      storageAccountName: exportStorageAccount.name
    }
    acrConfiguration:{
      loginServers: fhirServiceConfig.loginServers
    }
    authenticationConfiguration: {
      audience: 'https://${healthDataServicesConfig.name}-${fhirServiceConfig.name}.fhir.azurehealthcareapis.com'
      authority: uri(environment().authentication.loginEndpoint,subscription().tenantId)
    }
  }
}
// -- configure diagnostics settings
resource fhirServiceDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' =  {
  scope: fhirService
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// -- add FHIR service 'secrets' to Key Vault 
resource fhirServerUrlSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' =  {
  name: '${keyVault.name}/fhirServiceUrl'
  properties:{
    value: fhirServiceConfig.url

  }
}
resource fhirServerUrlSecretOld 'Microsoft.KeyVault/vaults/secrets@2019-09-01' =  {
  name: '${keyVault.name}/FS-URL'
  properties:{
    value: fhirServiceConfig.url
  }
}
resource fhirServerTenantNameSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServerTenantName)) {
  name: '${keyVault.name}/fhirServiceTenantName'
  properties:{
    value: fhirServerTenantName
  }
}
resource fhirServerTenantNameSecretOld 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServerTenantName)) {
  name: '${keyVault.name}/FS-TENANT-NAME'
  properties:{
    value: fhirServerTenantName
  }
}
resource fhirProxyHostNameSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' =  {
  name: '${keyVault.name}/fhirProxyHostName'
  properties:{
    value: '${fhirProxyFunctionApp.name}.azurewebsites.net'
  }
}
resource fhirProxyHostNameSecretOld 'Microsoft.KeyVault/vaults/secrets@2019-09-01' =  {
  name: '${keyVault.name}/FP-HOST'
  properties:{
    value: '${fhirProxyFunctionApp.name}.azurewebsites.net'
  }
}
resource logAnalyticsWorkspacenameSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/logAnalyticsWorkspaceName'
  properties:{
    value: logAnalyticsWorkspace.name
  }
}
resource createKeyVaultRedisSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/proxyRedisConnectionString'
  properties:{
    value: '${redisCache.properties.hostName}:${redisCache.properties.sslPort},password=${listKeys(redisCache.id, redisCache.apiVersion).primaryKey},ssl=True,abortConnect=False' 
  }
}
resource functionsStorageAccountConnectionSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/functionsStorageAccountConnectionString'
  properties:{
    value: 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
  }
}
// -- assign permissions for FHIR Service, FHIR Proxy, FHIR Loader
module functionsStoragePermissions './assignpermissions.bicep' = {
  name: 'fhirProxyStoragePermissions'
  params: {
    principalId: fhirService.identity.principalId
    builtInRoleType: 'StorageBlobDataContributor'
    resourceType: 'Storage'
    resourceName: functionsStorageAccount.name
  }
}
module registryPermissions './assignpermissions.bicep' = {
  name: 'registryPermissions'
  params: {
    principalId: fhirService.identity.principalId
    builtInRoleType: 'AcrPull'
    resourceType: 'Registry'
    resourceName: artifactContainerRegistry.name
  }
}
module loaderPermissionsFHIRWriter './assignpermissions.bicep' = {
  name: 'loaderPermissionsFHIRWriter'
  params: {
    principalId: fhirLoaderFunctionApp.identity.principalId
    builtInRoleType: 'FHIRDataWriter'
    resourceType: 'FHIRWS'
    resourceName: fhirService.name
    healthDataWorkspaceName: healthDataWorkspace.name
  }
}
module proxyPermissionsFHIRContributor './assignpermissions.bicep' = {
  name: 'proxyPermissionsFHIRContributor'
  params: {
    principalId: fhirProxyFunctionApp.identity.principalId
    builtInRoleType: 'FHIRDataContributor'
    resourceType: 'FHIRWS'
    resourceName: fhirService.name
    healthDataWorkspaceName: healthDataWorkspace.name
  }
}
module proxyPermissionsFHIRWriter './assignpermissions.bicep' = {
  name: 'proxyPermissionsFHIRWriter'
  params: {
    principalId: fhirProxyFunctionApp.identity.principalId
    builtInRoleType: 'FHIRDataWriter'
    resourceType: 'FHIRWS'
    resourceName: fhirService.name
    healthDataWorkspaceName: healthDataWorkspace.name
  }
}



// Azure Redis Cache & diagnostics logging
resource redisCache 'Microsoft.Cache/redis@2020-06-01' = {
  name: redisCacheName
  location: resourceLocation
  tags: resourceTags
  properties: {
    minimumTlsVersion: '1.2'
    sku: {
      family: 'C'
      name: 'Basic'
      capacity: 0
    }
  }
}
resource redisCacheDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: redisCache
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// App Service Plan for FHIR Bulk Loader and FHIR Proxy
param appServicePlanSku object = {
  name: 'EP1'
  tier: 'ElasticPremium'
  size: 'EP1'
  family: 'EP'
}
resource appServicePlan 'Microsoft.Web/serverfarms@2020-09-01' = {
  name: appServicePlanName
  location: resourceLocation
  tags: resourceTags
  sku: appServicePlanSku
  kind: 'elastic'
  properties:{
    maximumElasticWorkerCount: 5
    reserved: (functionPlanOS == 'Linux') ? true : false
  }
}
resource appServicePlanDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: appServicePlan
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [ 
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// FHIR Proxy Function App
resource fhirProxyFunctionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: fhirProxyAppName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'functionapp'
  properties: {
    enabled: true
    httpsOnly: true
    clientAffinityEnabled: false
    serverFarmId: appServicePlan.id
    siteConfig: {
      use32BitWorkerProcess: false
      //alwaysOn: true
      ftpsState:'FtpsOnly'
      minTlsVersion: '1.2'
    }
  }
}
resource fhirProxyFunctionAppDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: fhirProxyFunctionApp
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [ 
      {
        category: 'FunctionAppLogs'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
// FHIR Bulk Loader Function App
resource fhirLoaderFunctionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: fhirLoaderAppName
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'functionapp'
  properties: {
    enabled: true
    httpsOnly: true
    clientAffinityEnabled: false
    serverFarmId: appServicePlan.id
    siteConfig: {
      use32BitWorkerProcess: false
      //alwaysOn: true
      ftpsState:'FtpsOnly'
      minTlsVersion: '1.2'
    }
  }
}
resource fhirLoaderFunctionAppDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: fhirLoaderFunctionApp
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [ 
      {
        category: 'FunctionAppLogs'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}


// FHIR loader and Proxy Application Insights instances
resource proxyAppInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: proxyAppInsightName
  location: resourceLocation
  kind: 'web'
  tags: resourceTags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
resource loaderAppInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: loaderAppInsightName
  location: resourceLocation
  kind: 'web'
  tags: resourceTags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}
resource proxyAppInsightsDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: proxyAppInsights
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}
resource loaderAppInsightsDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: loaderAppInsights
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}

// function app settings
var keyVaultUri = keyVault.properties.vaultUri 
var profileValidationString = (enableProfileValidation) ? 'FHIRProxy.preprocessors.ProfileValidationPreProcess;' : '' 
var transformBundleString = (enableTransformBundle) ? 'FHIRProxy.preprocessors.TransformBundlePreProcess;' : ''
var everythingPatientString = (enableEverythingPatient) ? 'FHIRProxy.preprocessors.EverythingPatientPreProcess;' : ''

var proxyPreProcessSettings  = '${profileValidationString}${transformBundleString}${everythingPatientString}' 
var fhirProxyPreProcess = take(proxyPreProcessSettings, length(proxyPreProcessSettings)-1)

var consentOptOutString = (enableConsentOptOut) ? 'FHIRProxy.postprocessors.ConsentOptOutFilter;' : ''

var dateSortString  = (enableDateSort) ? 'FHIRProxy.postprocessors.DateSortPostProcessor;' : ''
var participantFilterString  = (enableParticipantFilter) ? 'FHIRProxy.postprocessors.ParticipantFilterPostProcess;' : ''
var fhirCdsSyncAgentString = (enableFhirCdsSyncAgent) ? 'FHIRProxy.postprocessors.FHIRCDSSyncAgentPostProcess2;' : ''
var publishFhirEventString = (enablePublishFhirEvent) ? 'FHIRProxy.postprocessors.PublishFHIREventPostProcess;' : ''


var proxyPostProcessSettings = '${consentOptOutString}${dateSortString}${participantFilterString}${fhirCdsSyncAgentString}${publishFhirEventString}' 
var fhirProxyPostProcess  = take(proxyPostProcessSettings, length(proxyPostProcessSettings)-1)

var roleAdmin = 'Administrator'
var roleReader = 'Reader'
var roleWriter = 'Writer'
var rolePatient = 'Patient'
var roleParticipant = 'Practitioner,RelatedPerson'
var roleGlobal = 'DataScientist'

resource fhirProxyAppSettings 'Microsoft.Web/sites/config@2021-02-01' = {
  name: 'appsettings'
  parent: fhirProxyFunctionApp
  properties: {
    'FUNCTIONS_EXTENSION_VERSION': '~3'
    'FUNCTIONS_WORKER_RUNTIME': 'dotnet'
    'APPINSIGHTS_INSTRUMENTATIONKEY':proxyAppInsights.properties.InstrumentationKey
    'AzureWebJobsStorage': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
    'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
    'WEBSITE_CONTENTSHARE': toLower(fhirProxyFunctionApp.name)
    'FP-ADMIN-ROLE': roleAdmin
    'FP-READER-ROLE': roleReader
    'FP-WRITER-ROLE': roleWriter
    'FP-GLOBAL-ACCESS-ROLES': roleGlobal
    'FP-PATIENT-ACCESS-ROLES': rolePatient
    'FP-PARTICIPANT-ACCESS-ROLES': roleParticipant
    'FP-MOD-CONSENT-OPTOUT-CATEGORY' : (enableConsentOptOut) ? 'http://loinc.org|59284-0' : ''
    'FP-PRE-PROCESSOR-TYPES': empty(fhirProxyPreProcess) ? 'FHIRProxy.preprocessors.TransformBundlePreProcess' : fhirProxyPreProcess
    'FP-POST-PROCESSOR-TYPES': empty(fhirProxyPostProcess) ? '' : fhirProxyPostProcess

    'FP-RBAC-NAME':'@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FP-RBAC-NAME/)'
    'FP-RBAC-CLIENT-ID':'@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FP-RBAC-CLIENT-ID/)'
    'FP-RBAC-CLIENT-SECRET':'@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FP-RBAC-CLIENT-SECRET/)'
    'FP-RBAC-TENANT-NAME':'@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FP-RBAC-TENANT-NAME/)'
    
    'FS-CLIENT-ID': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FS-CLIENT-ID/)'
    'FS-SECRET': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FS-SECRET/)'
    // revised fir proxy app settings to updated Key Vault secrets (keyVault uses fhirServicUrl instead of FS-URL)
    'FS-RESOURCE': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirServiceUrl/)'
    'FS-TENANT-NAME': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirServiceTenantName/)'
    'FS-URL': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirServiceUrl/)'

    'FP-HOST': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirProxyHostName/)'
    'FP-STORAGEACCT': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/functionsStorageAccountConnectionString/)'
    'FP-REDISCONNECTION': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/proxyRedisConnectionString/)'

  }
}

// export storage account connection string should be written to Key Vault (convert to MSI/Azure RBAC in the future)
// for now just dump the connection string into the App Settings
// use MSI
resource fhirLoaderAppSettings 'Microsoft.Web/sites/config@2021-02-01' = {
  name: 'appsettings'
  parent: fhirLoaderFunctionApp
  properties: {
    'FUNCTIONS_EXTENSION_VERSION': '~3'
    'FUNCTIONS_WORKER_RUNTIME': 'dotnet'
    'APPINSIGHTS_INSTRUMENTATIONKEY': loaderAppInsights.properties.InstrumentationKey
    'AzureWebJobsStorage': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
    'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
    'WEBSITE_CONTENTSHARE': toLower(fhirLoaderFunctionApp.name)
    'AzureWebJobs.ImportBundleBlobTrigger.Disabled': '1'
    // fhir service settings
    'FS-CLIENT-ID': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FS-CLIENT-ID/)'
    'FS-RESOURCE': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirServiceUrl/)'
    'FS-SECRET': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FS-SECRET/)'
    'FS-TENANT-NAME': useMSI ? '' : '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/FS-TENANT-NAME/)'
    'FS-URL': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirServiceUrl/)'
    'FP-HOST': '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/fhirProxyHostName/)'

    'FBI-TRANSFORMBUNDLES' : 'true'
    'FBI-POOLEDCON-MAXCONNECTIONS': '10'
    'FBI-STORAGEACCT': 'DefaultEndpointsProtocol=https;AccountName=${importStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(importStorageAccount.id, importStorageAccount.apiVersion).keys[0].value}'
  }
}

//deploy fhir loader code
resource deployLoaderUsingCD 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
  dependsOn: [
    fhirLoaderAppSettings
  ]
  name:'web'
  parent: fhirLoaderFunctionApp
  properties: {
    repoUrl: fhirLoaderConfig.repoUrl
    branch: fhirLoaderConfig.repoBranch
    isManualIntegration: true
  }
}
// deploy fhir proxy code
resource deployProxyUsingCD 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
  dependsOn: [
    fhirProxyAppSettings
  ]
  name:'web'
  parent: fhirProxyFunctionApp
  properties: {
    repoUrl: fhirProxyConfig.repoUrl
    branch: fhirProxyConfig.repoBranch
    isManualIntegration: true
  }
}

// Event Grid configuration
resource loaderEventGridSystemTopic 'Microsoft.EventGrid/systemTopics@2021-06-01-preview' = {
  name: loaderEventGridTopicName
  location: resourceLocation
  tags: resourceTags
  properties: {
    source: importStorageAccount.id
    topicType: 'microsoft.storage.storageaccounts'
  }
}
resource loaderEventGridSubscription 'Microsoft.EventGrid/eventSubscriptions@2021-06-01-preview' = {
  name: 'bundlecreated'
  scope: importStorageAccount
  dependsOn: [
    deployLoaderUsingCD
  ]
  properties:{
    eventDeliverySchema: 'EventGridSchema'
    destination: {
      endpointType: 'AzureFunction'
      properties:{
        resourceId: '${fhirLoaderFunctionApp.id}/functions/ImportBundleEventGrid'
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
      }
    }
    filter: {
      subjectEndsWith: '.json'
      includedEventTypes: [ 
        'Microsoft.Storage.BlobCreated'
				'Microsoft.Storage.BlobDeleted'
      ]
      advancedFilters: [
        {
          operatorType: 'StringIn'
          values: [
            'CopyBlob'
            'PutBlob'
            'PutBlockList'
            'FlushWithClose'
          ]
          key: 'data.api'
        }
      ]
    }
    retryPolicy: {
      maxDeliveryAttempts: 30
      eventTimeToLiveInMinutes: 1440
    }
  }
}
resource loaderEventGridSubscriptionND 'Microsoft.EventGrid/eventSubscriptions@2021-06-01-preview' = {
  name: 'ndjsoncreated'
  scope: importStorageAccount
  dependsOn: [
    deployLoaderUsingCD
  ]
  properties:{
    eventDeliverySchema: 'EventGridSchema'
    destination: {
      endpointType: 'AzureFunction'
      properties:{
        resourceId: '${fhirLoaderFunctionApp.id}/functions/ImportNDJSON'
        maxEventsPerBatch: 1
        preferredBatchSizeInKilobytes: 64
      }
    }
    filter: {
      subjectEndsWith: '.ndjson'
      includedEventTypes: [ 
        'Microsoft.Storage.BlobCreated'
				'Microsoft.Storage.BlobDeleted'
      ]
      advancedFilters: [
        {
          operatorType: 'StringIn'
          values: [
            'CopyBlob'
            'PutBlob'
            'PutBlockList'
            'FlushWithClose'
          ]
          key: 'data.api'
        }
      ]
    }
    retryPolicy: {
      maxDeliveryAttempts: 30
      eventTimeToLiveInMinutes: 1440
    }
  }
}
resource loaderEventGridSystemTopicDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: loaderEventGridSystemTopic
  name: 'defaultSettings'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: 7
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy:{
          enabled: true
          days: 7
        }
      }
    ]
  }
}

//Key Vault Permissions
resource functionAppKeyVaultPermissions 'Microsoft.KeyVault/vaults/accessPolicies@2021-06-01-preview' = {
  name: 'add'
  parent: keyVault
  properties: {
    accessPolicies: [
      {
        objectId: fhirProxyFunctionApp.identity.principalId
        permissions: {
          certificates: [ 
            'get'
           ]
          keys: [ 
            'get' 
          ]
          secrets: [ 
            'get' 
          ]
        }
        tenantId: tenantId
      }
      {
        objectId: fhirLoaderFunctionApp.identity.principalId
        permissions: {
          certificates: [ 
            'get'
           ]
          keys: [ 
            'get' 
          ]
          secrets: [ 
            'get' 
          ]
        }
        tenantId: tenantId
      }
    ]
  }
}

// -- fhir Synapse Link deployment

resource fhirAnalyticsSyncAppInsights 'microsoft.insights/components@2020-02-02-preview' = if (fhirSynapseLinkConfig.enabled) {
  name: '${fhirSynapseLinkConfig.name}ai'
  location: resourceLocation
  kind: 'web'
  tags: resourceTags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

var adlsAppSettings = [
  {
    'name':'APPINSIGHTS_INSTRUMENTATIONKEY'
    'value': (fhirSynapseLinkConfig.enabled) ? fhirAnalyticsSyncAppInsights.properties.InstrumentationKey : ''
  }
  {
    'name': 'AzureWebJobsStorage'
    'value': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
  }
  {
    'name':'FUNCTIONS_EXTENSION_VERSION'
    'value': '~2'
  }
  {
    'name':'FUNCTIONS_WORKER_RUNTIME'
    'value': 'dotnet-isolated'
  }
  {
    'name':'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
    'value': 'DefaultEndpointsProtocol=https;AccountName=${functionsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(functionsStorageAccount.id, functionsStorageAccount.apiVersion).keys[0].value}'
  }
  {
    'name':'WEBSITE_CONTENTSHARE' 
    'value': toLower(dataLakeSyncAppName)
  }
  {
    'name':'WEBSITE_NODE_DEFAULT_VERSION'
    'value': '~10'
  }
  {
    'name':'job__containerName'
    'value': fhirSynapseLinkConfig.dataLakeContainerName
  }
  {
    'name':'job__startTime'
    'value': fhirSynapseLinkConfig.dataStart
  }
  {
    'name':'job__endTime'
    'value': empty(dataEnd) ? '' : dataEnd
  }
  {
    'name':'dataLakeStore__storageUrl'
    'value': fhirSynapseLinkConfig.dataLakeEndpoint
  }
  {
    'name':'fhirServer__serverUrl'
    'value': fhirSynapseLinkConfig.fhirServiceUrl
  }
  {
    'name':'fhirServer__version'
    'value': fhirSynapseLinkConfig.fhirServiceVersion
  }
  {
    'name':'fhirServer__authentication'
    'value': fhirSynapseLinkConfig.useMSI ? 'ManagedIdentity' : 'None'
  }
]

var fhirSynapseSyncAppServicePlanId = appServicePlan.id

resource fhirSynapseSyncOperationFunction  'Microsoft.Web/sites@2021-02-01' = if(fhirSynapseLinkConfig.enabled) {
  name: fhirSynapseLinkConfig.name
  location: resourceLocation
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'functionapp'
  properties: {
    enabled: true
    httpsOnly: true
    clientAffinityEnabled: false
    serverFarmId: fhirSynapseSyncAppServicePlanId
    reserved: (functionPlanOS == 'Linux') ? true : false
    siteConfig: {
      use32BitWorkerProcess: false
      ftpsState:'FtpsOnly'
      minTlsVersion: '1.2'
      appSettings: adlsAppSettings
      
    }
  }
}

resource fhirSynapsSyncPackageDeploy 'Microsoft.Web/sites/extensions@2020-12-01' = if(fhirSynapseLinkConfig.enabled) {
    name: 'MSDeploy'
  parent: fhirSynapseSyncOperationFunction
  properties: {
      packageUri: fhirSynapseLinkConfig.packageUri
      dbType : 'None'
      connectionString : ''
  }
}

module syncAppStoragePermissions './assignpermissions.bicep' = if (fhirSynapseLinkConfig.enabled){
    name: 'synapseSyncStoragePermissions'
    params: {
      principalId: fhirSynapseSyncOperationFunction.identity.principalId
      builtInRoleType: 'StorageBlobDataContributor'
      resourceType: 'Storage'
      resourceName: exportStorageAccount.name
    }
}
module syncAppFhirPermissions './assignpermissions.bicep' = if (fhirSynapseLinkConfig.enabled){
  name: 'synapseSyncFhirPermissions'
  params: {
    principalId: fhirSynapseSyncOperationFunction.identity.principalId
    builtInRoleType: 'FHIRDataReader'
    resourceType: 'FHIRWS'
    resourceName: fhirService.name
    healthDataWorkspaceName: healthDataWorkspace.name
  }
}

// -- outputs
output deploymentUniqueId string = uniqueId
output keyVaultName string = keyVault.name
output fhirServiceUrl string = fhirService.properties.authenticationConfiguration.audience
output fhirServiceAuthority string = fhirService.properties.authenticationConfiguration.authority
output fhirServiceExportStorageAccountName string = fhirService.properties.exportConfiguration.storageAccountName
output fhirServiceRegistryList array = fhirService.properties.acrConfiguration.loginServers
output fhirServiceManagedIdentity string = fhirService.identity.principalId
output fhirLoaderManagedIdentity string = fhirLoaderFunctionApp.identity.principalId
output fhirProxyManagedIdentity string = fhirProxyFunctionApp.identity.principalId

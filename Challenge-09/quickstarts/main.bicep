//
// Healthcare APIs Authentication / Authorization / Consent Quickstart
// 

@description('Tags to be applied to resources that are deployed in this template')
param resourceTags object  = {
  environmentName: 'Healthcare APIs OpenHack'
  challengeTitle: 'Auth-Consent'

}
@description('Deployment Prefix - all resources names created by this template will start with this prefix')
@minLength(3)
@maxLength(7)
param deploymentPrefix string

var tenantId = subscription().tenantId
var resourceLocation = resourceGroup().location

@description('FHIR Server Azure AD Tenant ID (GUID)')
param fhirServerTenantName string = subscription().tenantId
@description('FHIR Server Client ID')
param fhirServerClientId string = ''
@secure()
@description('FHIR Server Client Secret')
param fhirServerSecret string = ''

// Unique Id used to generate resource names
var uniqueId  = take(uniqueString(subscription().id, resourceGroup().id, deploymentPrefix),6)
output deploymentUniqueId string = uniqueId

// Default resource names
// Azure key Vault
var kvName   = '${deploymentPrefix}${uniqueId}kv'
// Secure FHIR Proxy Instance
var fpName   = '${deploymentPrefix}${uniqueId}proxy'
// Storage Account (Secure FHIR Proxy)
var saName   = '${deploymentPrefix}${uniqueId}sa'
// Redis Cache
var rcName   = '${deploymentPrefix}${uniqueId}rc'
// Application Service Plan
var aspName  = '${deploymentPrefix}${uniqueId}asp'
// Application Insights 
var aiName   = '${deploymentPrefix}${uniqueId}-appinsight'
// Log Analytics Workspace
var laName   = '${deploymentPrefix}${uniqueId}la'
// Healthcare APIs Workspace
var healthcareWorkspaceName = '${deploymentPrefix}${uniqueId}hlth'
// Healthcare APIs Workspace FHIR Instance
var fhirServiceName = 'fhir01'

var fhirServiceAuthority = uri(environment().authentication.loginEndpoint, subscription().tenantId)
var fhirServiceAudience = 'https://${healthcareWorkspaceName}.azurehealthcareapis.com'
var fhirServiceUrl = 'https://${healthcareWorkspaceName}-${fhirServiceName}.fhir.azurehealthcareapis.com'
var fhirServiceResource = 'https://${healthcareWorkspaceName}-${fhirServiceName}.fhir.azurehealthcareapis.com'



// Secure FHIR Proxy Settings
var fhirProxyPreProcess = 'FHIRProxy.preprocessors.TransformBundlePreProcess'
var fhirProxyPostProcess  = ''

// Secure FHIR proxy source code repository
var fhirProxyRepoUrl  = 'https://github.com/microsoft/fhir-proxy'
var fhirProxyRepoBranch  = 'main'

// Role Id list used for Azure RBAC Assignments
var roleDefintionId = {
  AcrPush: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8311e382-0749-4cb8-b61a-304f252e45ec')
  }
  AcrPull: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
  AcrDelete: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c2f4ef07-c644-48eb-af81-4b1b4947fb11')
  }
  StorageBlobDataContributor: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  }
  FHIRDataContributor: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5a1fc7df-4bf1-4951-a576-89034ee01acd')
  }
  FHIRDataReader: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4c8d0bbc-75d3-4935-991f-5f3c56d81508')
  }
  FHIRDataWriter: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3f88fce4-5892-4214-ae73-ba5294559913')
  }
  FHIRDataConverter: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a1705bd2-3a8f-45a5-8683-466fcfd5cc24')
  }
  FHIRDataExporter: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3db33094-8700-4567-8da5-1501d4e7e843')
  }
  KeyVaultContributor: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f25e0fa2-a7c8-4377-a976-54943a77a395')
  }
  KeyVaultAdministrator: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
  }
  KeyVaultCryptoOfficer: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '14b46e9e-c2b7-41b4-b07b-48a6ebf60603')
  }
  KeyVaultCryptoUser: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424')
  }
  KeyVaultSecretsOfficer: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  }
  KeyVaultSecretsUser: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
  }
  KeyVaultCertificatesOfficer: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a4417e6f-fecd-4de8-b567-7b0420556985')
  }
  KeyVaultReader: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21090545-7ca7-4776-b22c-e363652d74d2')
  }
  KeyVaultCryptoServiceEncryptionUser: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6')
  }
}

// Create logging resources
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: laName
  location: resourceLocation
  tags: resourceTags
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}
resource logAnalyticsWorkspaceDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  scope: logAnalyticsWorkspace
  name: 'diagnosticSettings'
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
resource appInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: aiName
  location: resourceLocation
  kind: 'web'
  tags: resourceTags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: saName
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
// Blob Services for Storage Account
resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: '${storageAccount.name}/default'
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

resource bundleContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/bundles'
  properties: {
  }
}
resource ndjsonContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/ndjson'
  properties: {
  }
}
resource zipContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/zip'
  properties: {
  }
}
// Healthcare APIs Worspace Deployment
resource healthcareApisWorkspace 'Microsoft.HealthcareApis/workspaces@2021-06-01-preview' = {
  name: healthcareWorkspaceName
  location: resourceGroup().location
  tags: resourceTags
}

resource fhirService 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-06-01-preview' = {
  parent: healthcareApisWorkspace
  name: fhirServiceName
  kind: 'fhir-R4'
  location: resourceGroup().location
  tags: resourceTags
  properties: {
    authenticationConfiguration: {
      authority: fhirServiceAuthority
      audience: fhirServiceAudience
      smartProxyEnabled: true
    }
  }
}

// Azure Key Vault 
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' =  {
  dependsOn:[
    fhirProxyFunctionApp
  ]
  name: kvName
  location: resourceLocation
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        objectId: fhirProxyFunctionApp.identity.principalId
        tenantId: tenantId
        permissions: {
          keys: [
            'get'
          ]
          secrets: [
            'get'
          ]
        }
      }
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
// FHIR Server settings <parameters/user input> that are saved to KV
resource fhirServerUrlSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' =  {
  name: '${keyVault.name}/FS-URL'
  properties:{
    value: fhirServiceUrl
  }
}
resource fhirServerTenantNameSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServerTenantName)) {
  name: '${keyVault.name}/FS-TENANT-NAME'
  properties:{
    value: fhirServerTenantName
  }
}
resource fhirServerClientIdSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServerClientId)) {
  name: '${keyVault.name}/FS-CLIENT-ID'
  properties:{
    value: fhirServerClientId
  }
}
resource fhirServerSecretSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServerSecret)) {
  name: '${keyVault.name}/FS-SECRET'
  properties:{
    value: fhirServerSecret
  }
}
resource fhirServiceResourceSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if(!empty(fhirServiceResource)) {
  name: '${keyVault.name}/FS-RESOURCE'
  properties:{
    value: fhirServiceResource
  }
}

// FHIR Proxy Function settings that are saved in KV
resource createKeyVaultSecretHost 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/FP-HOST'
  properties:{
    value: fhirProxyFunctionApp.properties.defaultHostName
  }
}
resource createKeyVaultSecretUri 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/FP-RBAC-NAME'
  properties:{
    value: 'https://${fhirProxyFunctionApp.properties.defaultHostName}'
  }
}


// Save Storage Account properties to KV
resource createKeyVaultStorageSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/FP-STORAGEACCT'
  properties:{
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
  }
}
resource createKeyVaultBulkImportStorageSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/FBI-STORAGEACCT'
  properties:{
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
  }
}



resource redisCache 'Microsoft.Cache/redis@2020-06-01' =  {
  name: rcName
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
// Save Redis Cache properties to KV
resource createKeyVaultRedisSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVault.name}/FP-REDISCONNECTION'
  properties:{
    value: '${redisCache.properties.hostName}:${redisCache.properties.sslPort},password=${listKeys(redisCache.id, redisCache.apiVersion).primaryKey},ssl=True,abortConnect=False' 
  }
}


resource appServicePlan 'Microsoft.Web/serverfarms@2020-09-01' = {
  name: aspName
  location: resourceLocation
  tags: resourceTags
  sku: {
    name: 'S1'
  }
  kind: 'functionapp'
}

resource fhirProxyFunctionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: fpName
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
      alwaysOn: true
      ftpsState:'FtpsOnly'
    }
  }
}

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
    'APPINSIGHTS_INSTRUMENTATIONKEY':appInsights.properties.InstrumentationKey
    'AzureWebJobsStorage': 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
    'FP-ADMIN-ROLE': roleAdmin
    'FP-READER-ROLE': roleReader
    'FP-WRITER-ROLE': roleWriter
    'FP-GLOBAL-ACCESS-ROLES': roleGlobal
    'FP-PATIENT-ACCESS-ROLES': rolePatient
    'FP-PARTICIPANT-ACCESS-ROLES': roleParticipant
    'FP-HOST': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-HOST/)'
    'FP-PRE-PROCESSOR-TYPES': empty(fhirProxyPreProcess) ? 'FHIRProxy.preprocessors.TransformBundlePreProcess' : fhirProxyPreProcess
    'FP-POST-PROCESSOR-TYPES': empty(fhirProxyPostProcess) ? '' : fhirProxyPostProcess
    'FP-RBAC-NAME':'@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-RBAC-NAME/)'
    'FP-RBAC-TENANT-NAME':'@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-RBAC-TENANT-NAME/)'
    'FP-RBAC-CLIENT-ID':'@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-RBAC-CLIENT-ID/)'
    'FP-RBAC-CLIENT-SECRET':'@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-RBAC-CLIENT-SECRET/)'
    'FP-REDISCONNECTION': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-REDISCONNECTION/)'
    'FP-STORAGEACCT': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FP-STORAGEACCT/)'
    'FS-URL': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FS-URL/)'
    'FS-TENANT-NAME': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FS-TENANT-NAME/)'
    'FS-CLIENT-ID': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FS-CLIENT-ID/)'
    'FS-SECRET': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FS-SECRET/)'
    'FS-RESOURCE': '@Microsoft.KeyVault(SecretUri=${keyVault.properties.vaultUri}/secrets/FS-RESOURCE/)'
  }
}


resource deployProxyUsingCD 'Microsoft.Web/sites/sourcecontrols@2020-12-01' = {
  dependsOn: [
    fhirProxyAppSettings
    redisCache
  ]
  name:'web'
  parent: fhirProxyFunctionApp
  properties: {
    repoUrl: fhirProxyRepoUrl
    branch: fhirProxyRepoBranch
    isManualIntegration: true
  }
}

// use Key Vault RBAC in the future, currently using Access Policies 
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' =  {
  name: guid(resourceGroup().id, roleDefintionId['KeyVaultSecretsUser'].id, kvName)
  scope: keyVault
  properties: {
    roleDefinitionId: roleDefintionId['KeyVaultSecretsUser'].id
    principalId: fhirProxyFunctionApp.identity.principalId
  }
}

output fhirProxyHostName string = fhirProxyFunctionApp.properties.defaultHostName


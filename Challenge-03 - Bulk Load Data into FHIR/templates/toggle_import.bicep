// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// -- parameter definition
@description('Deployment prefix used in Challenge-01')
@minLength(3)
@maxLength(7)
param deploymentPrefix string

@description('Azure gegion where your FHIR service is deployed. Default Value: the resource group region')
param resourceLocation string = resourceGroup().location

@description('Flag to enable or disable $import')
param toggleImport bool

// -- variables
var uniqueId      = toLower(take(uniqueString(subscription().id, resourceGroup().id, deploymentPrefix),6))

// -- resource names
var workspaceName = '${deploymentPrefix}${uniqueId}hdsws'
var fhirName      = 'data'
var storageName   = '${deploymentPrefix}${uniqueId}stor'
var containerName = 'import'

module existingFhir './existing_fhir.bicep' = {
  name: fhirName
  params: {
    fhirName: fhirName
    workspaceName: workspaceName
  }
}

@description('This is the existing AHDS workspace used to populate the updated resource')
resource existingWorkspace 'Microsoft.HealthcareApis/workspaces@2021-11-01' existing = {
  name: workspaceName
}

@description('Updated FHIR Service used to enable import')
resource fhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' = {
  name: fhirName
  parent: existingWorkspace
  location: resourceLocation
  kind: 'fhir-R4'

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    //accessPolicies: existingFhir.properties.accessPolicies
    acrConfiguration: existingFhir.outputs.acrConfiguration
    accessPolicies: existingFhir.outputs.accessPolicies
    corsConfiguration: existingFhir.outputs.corsConfiguration
    authenticationConfiguration: existingFhir.outputs.authenticationConfiguration
    importConfiguration: toggleImport ? {
      enabled: true
      initialImportMode: true
      integrationDataStore: storageName
    } : {
      enabled: false
    }
    exportConfiguration: existingFhir.outputs.exportConfiguration
  }

  dependsOn: [
    existingFhir
  ]
}

@description('Storage account used by FHIR service for $import')
resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageName
  location: resourceLocation
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

@description('Blob container used by FHIR service for $import')
resource importContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${sa.name}/default/${containerName}'
}

@description('This is the built-in Storage Blob Data Contributor role. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor')
resource fhirContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
}

@description('This is the role assignment to give access to the Postman Client to the FHIR Service')
resource fhirDataContributorAccess 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: importContainer
  name: guid(importContainer.id, fhir.id, fhirContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: fhirContributorRoleDefinition.id
    principalId: fhir.identity.principalId
  }
}

// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// -- parameter definition
@description('Tags to be applied to resources that are deployed in this template')
param resourceTags object  = {
  environmentName: 'Azure Health Data Services OpenHack'
  challengeTitle: 'Deploy Core Training Environment'
  expirationDate: '06/30/2022'
}

@description('Deployment Prefix - all resources that are created in this workshop will start with this prefix')
@minLength(3)
@maxLength(7)
param deploymentPrefix string

@description('Azure Region where the resources will be deployed. Default Value:  the resource group region')
param resourceLocation string = resourceGroup().location

@description('Client Id of Postman Applicaton Registration')
param postmanClientId string

// -- variables
var uniqueId = toLower(take(uniqueString(subscription().id, resourceGroup().id, deploymentPrefix),6))

// -- resource names
var ahdsWorkspaceName        = '${deploymentPrefix}${uniqueId}hdsws'
var fhirServiceName          = 'fhirtrn'

// -- fhir config vales
var loginURL = environment().authentication.loginEndpoint
var authority = '${loginURL}${subscription().tenantId}'
var audience = 'https://${ahdsWorkspaceName}-${fhirServiceName}.fhir.azurehealthcareapis.com'

// -- Resources
@description('This is the Azure Health Data Services workspace for use in this workshop')
resource healthDataWorkspace 'Microsoft.HealthcareApis/workspaces@2021-11-01' = {
  name: ahdsWorkspaceName
  tags: resourceTags
  location: resourceLocation
  properties:{
    publicNetworkAccess: 'Enabled'
  }
}

@description('This is the FHIR Service under the Azure Health Data Services workspace for use in this workshop')
resource fhirService 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' = {
  name: fhirServiceName
  tags: resourceTags
  location: resourceLocation
  kind: 'fhir-R4'

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    authenticationConfiguration: {
      authority: authority
      audience: audience
      smartProxyEnabled: false
    }
  }
}

@description('This is the built-in FHIR Data Contributor role. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#fhir-data-contributor')
resource fhirContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '5a1fc7df-4bf1-4951-a576-89034ee01acd'
}

@description('This is the role assignment to give access to the Postman Client to the FHIR Service')
resource fhirDataContributorAccess 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: fhirService
  name: guid(fhirService.id, postmanClientId, fhirContributorRoleDefinition.id)
  properties: {
    roleDefinitionId: fhirContributorRoleDefinition.id
    principalId: postmanClientId
    principalType: 'ServicePrincipal'
  }
}

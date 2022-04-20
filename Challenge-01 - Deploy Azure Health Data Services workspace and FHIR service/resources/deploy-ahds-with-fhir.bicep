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

@description('Azure Region where the resources will be deployed. Default Value: the resource group region')
param resourceLocation string = resourceGroup().location

// -- variables
var uniqueId = toLower(take(uniqueString(subscription().id, resourceGroup().id, deploymentPrefix),6))

// -- resource names
var workspaceName = '${deploymentPrefix}${uniqueId}hdsws'
var fhirName      = 'data'
var loginURL      = environment().authentication.loginEndpoint
var tenantId      = subscription().tenantId
var authority     = '${loginURL}${tenantId}'
var audience      = 'https://${workspaceName}-${fhirName}.fhir.azurehealthcareapis.com'

// -- Resources
@description('Tags at the resource group level')
resource symbolicname 'Microsoft.Resources/tags@2021-04-01' = {
  name: 'default'
  properties: {
    tags: resourceTags
  }
}

@description('This is the Azure Health Data Services workspace for use in this workshop')
resource healthWorkspace 'Microsoft.HealthcareApis/workspaces@2021-11-01' = {
  name: workspaceName
  tags: resourceTags
  location: resourceLocation
  properties:{
    publicNetworkAccess: 'Enabled'
  }
}

@description('This is the FHIR Service under the Azure Health Data Services workspace for use in this workshop')
resource fhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' = {
  name: fhirName
  parent: healthWorkspace
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

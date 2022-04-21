@description('Name of the resource that permissions will be applied to')
@minLength(2)
param resourceName string
@description('Service Principal Object ID')
param principalId string
@description('Standard RBAC role that will be assigned to the Service Principal')
@allowed([
  'AcrPush'
  'AcrPull'
  'AcrDelete'
  'StorageBlobDataContributor'
  'FHIRDataContributor'
  'FHIRDataReader'
  'FHIRDataWriter'
  'FHIRDataConverter'
  'FHIRDataExporter'
  'KeyVaultReader'
  'KeyVaultSecretsUser'
])
param builtInRoleType string
@description('Type of resource that the permissions will be applied to')
@allowed([
  'Storage'
  'Registry'
  'FHIR'
  'FHIRWS'
  'Vault'
])
param resourceType string
param healthDataWorkspaceName string = ''


var roleDefinitionId = {
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

resource myStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (resourceType == 'Storage') {
  name: resourceName
}

resource storageAccountRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if (resourceType == 'Storage') {
  name: guid(resourceGroup().id, principalId, roleDefinitionId[builtInRoleType].id, resourceName)
  scope: myStorageAccount
  properties: {
    roleDefinitionId: roleDefinitionId[builtInRoleType].id
    principalId: principalId
  }
}

// Azure Container Registry Role Assignment
resource myContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = if (resourceType == 'Registry') {
  name: resourceName
}
resource containerRegistryRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if (resourceType == 'Registry') {
  name: guid(resourceGroup().id, principalId, roleDefinitionId[builtInRoleType].id, resourceName)
  scope: myContainerRegistry
  properties: {
    roleDefinitionId: roleDefinitionId[builtInRoleType].id
    principalId: principalId
  }
}
resource myFhirWorkspace 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' existing = if (resourceType == 'FHIRWS') {
  name: '${healthDataWorkspaceName}/${resourceName}'
  //name: resourceNames
}

resource fhirWorkspaceRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if (resourceType == 'FHIRWS') {
  name: guid(resourceGroup().id, principalId, roleDefinitionId[builtInRoleType].id, resourceName)
  scope: myFhirWorkspace
  properties: {
    roleDefinitionId: roleDefinitionId[builtInRoleType].id
    principalId: principalId
  }
}


// API for FHIR
resource myApiforFhir 'Microsoft.HealthcareApis/services@2021-06-01-preview' existing = if (resourceType == 'FHIR') {
  name: resourceName
}
resource ApiforFhirRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if (resourceType == 'FHIR') {
  name: guid(resourceGroup().id, principalId, roleDefinitionId[builtInRoleType].id, resourceName)
  scope: myApiforFhir
  properties: {
    roleDefinitionId: roleDefinitionId[builtInRoleType].id
    principalId: principalId
  }
}


// Key Vault
resource myKeyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = if (resourceType == 'Vault') {
  name: resourceName
}
resource keyVaultRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = if (resourceType == 'Vault') {
  name: guid(resourceGroup().id, principalId, roleDefinitionId[builtInRoleType].id, resourceName)
  scope: myKeyVault
  properties: {
    roleDefinitionId: roleDefinitionId[builtInRoleType].id
    principalId: principalId
  }
}

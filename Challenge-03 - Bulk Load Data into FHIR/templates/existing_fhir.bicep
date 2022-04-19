@description('Name of the existing AHDS workspace')
param workspaceName string

@description('Name of the existing FHIR service')
param fhirName string

@description('This is the existing AHDS workspace used to populate the updated resource')
resource existingWorkspace 'Microsoft.HealthcareApis/workspaces@2021-11-01' existing = {
  name: workspaceName
}

@description('This is the existing FHIR Service used to populate the updated resource')
resource existingFhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2021-11-01' existing = {
  name: fhirName
  parent: existingWorkspace
}

output properties object = existingFhir.properties
output acrConfiguration object = existingFhir.properties.acrConfiguration
output accessPolicies array = existingFhir.properties.accessPolicies
output authenticationConfiguration object = existingFhir.properties.authenticationConfiguration
output corsConfiguration object = existingFhir.properties.corsConfiguration
output exportConfiguration object = existingFhir.properties.exportConfiguration

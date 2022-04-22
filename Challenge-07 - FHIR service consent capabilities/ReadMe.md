# Challenge-07 - FHIR service consent capabilities

## Introduction

Welcome to Challenge-07!

In this challenge, you will learn how to configure Consent Opt-Out filtering for the FHIR service using [FHIR-Proxy](https://github.com/microsoft/fhir-proxy) (OSS).

## Background

In the digital transformation of healthcare, the wide adoption of FHIR R4 has removed certain barriers of access to patient health data. With this increased access, FHIR R4 also brings more control over what parties may gain access to patient data. Health institutions are required by law to guard patients' Personal Health Information (PHI). One way this is managed is by requiring patient consent (either "broad" or "direct" consent) before practitioners or researchers may access a patient's medical records. In this challenge, we will be exploring capabilities in the Azure health data platform that make it possible for patients to opt out of sharing their FHIR records with certain parties.

## Learning Objectives for Challenge-07
By the end of this challenge you will be able to 

+ Configure FHIR-Proxy authentication for connecting to FHIR service
+ Configure Postman to connect with FHIR service via FHIR-Proxy
+ Configure Consent Opt-Out filtering in FHIR-Proxy
+ Add a Consent Resource to the Azure Health Data Services FHIR service
+ Verify that Consent Opt-Out filtering performs as expected

## Prerequisites

+ Azure Health Data Services FHIR service instance with patient data (completed in previous challenges)
+ FHIR-Proxy deployed (completed in Challenge-01)
+ Postman installed (completed in Challenge-01)
+ Multiple Azure AD users to simulate user and/or administrator access to the FHIR service 

## Getting Started 
Before setting up FHIR-Proxy for Consent Opt Out filtering, you will need to configure FHIR-Proxy authentication to securely connect with the FHIR service. For a general overview of the role that FHIR-Proxy plays with FHIR service, review the section below.

> Note: Within the 2023 fiscal year, the FHIR-Proxy Function App in its current form will be deprecated. The app’s features and functionality will be integrated into AHDS FHIR service and other Azure resources. 

### FHIR-Proxy and FHIR service relationship
In the Azure health data platform, FHIR service and FHIR-Proxy operate as a team. FHIR service is at the center of activity, and FHIR-Proxy acts as a pre- and post-processor, selectively filtering FHIR data on the way into and out of the FHIR service. Admins can set up FHIR-Proxy to listen to the stream of I/O data and trigger custom workflows based on specific FHIR events. FHIR-Proxy also brings enhanced Role-Based Access Control (RBAC) to FHIR service, allowing fine-grained authorization for REST API actions at the FHIR Resource level. This also provides a means of Role-Based Consent so that users (i.e., patients) can authorize or deny access to certain FHIR data.

Component View of FHIR-Proxy and FHIR service with Postman set up to call the FHIR-Proxy endpoint.

<img src="./images/Postman_FHIR-Proxy_ARM_template_deploy_AHDS.png" height="528">

FHIR-Proxy asserts control over I/O data only if its [pre- and/or post-processing modules](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#date-sort-post-processor) have been enabled and configured. Otherwise, with no special configuration, API calls made to the FHIR-Proxy endpoint go straight through to the FHIR service, and responses are sent back unfiltered to the remote client app (e.g., Postman). 

## Step 1 - Configure FHIR-Proxy authentication

## Step 2 - Configure Postman

1. Configure postman using the guidance provided in [Challenge 1](<../Challenge-01 - Deploy FHIR service (PaaS), FHIR-Proxy (OSS), and FHIR-Bulk Loader (OSS)/Readme.md>).
2. Confirm that the FHIR service contains Patient Resources.
![Patient Resources](./images/patient-count-postman.png)
3. Select a Patient Resource and record the patient identifier. This will be used to create the Consent Resource.

Visual Studio Code with the [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) extension may also be used to complete this challenge. See the walkthrough [here](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/using-rest-client) for details on how to use REST Client to access Azure Health Data Services FHIR service. Be sure to note that in all cases you will be using the FHIR-Proxy endpoint to complete this challenge.

## Step 3 - Post Consent Record to FHIR Service

1. Review and update (as needed) the sample Consent Resource, which may be found [here](./sample-data/consent-resource.json). Be sure to use the Patient Resource obtained in Step 1.
2. Create a new request in Postman and post the Consent Resource.

## Step 4 - Configure Secure FHIR Consent Opt-Out

1. Refer to the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md) for additional details.
2. [Configure the Consent Opt Filter](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md). The FP-POST-PROCESSOR-TYPES must be updated to include FHIRProxy.postprocessors.ConsentOptOutFilter.
3. Additionally the FP-MOD-CONSENT-OPTOUT-CATEGORY setting with a value of `http://loinc.org|59284-0` must be added if it does not exist.

## Step 5 - Verify Consent Opt-Out filtering

1. Link a user to an appropriate FHIR resource. See the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md) for additional details. Ensure that the linked user is not assigned to the FHIR-Proxy administrator role.

2. Sample query patient result.![Query patient](./images/ConsentOptOut-Withheld-2.png) 


## What does success look like for Challenge-07?

+ Successfully POST a consent record to the Azure Health Data Services FHIR service
+ Verify that Consent Opt-Out properly filters Resources

## Next Steps

Click [here](<../Challenge-08 - DICOM/Readme.md>) to proceed to the next challenge.

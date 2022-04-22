# Challenge-07 - FHIR service consent capabilities

## Introduction

Welcome to Challenge-07!

In this challenge, you will learn how to configure Consent Opt-Out filtering for the FHIR service using [FHIR-Proxy](https://github.com/microsoft/fhir-proxy) (OSS).

## Background

In the digital transformation of healthcare, the wide adoption of FHIR R4 has removed certain barriers of access to patient health data. With this increased access, FHIR R4 also brings more control to patients over what parties may gain access to patient data. Health institutions are required by law to guard patients' Personal Health Information (PHI). One way this is managed is by requiring patient consent (either "broad" or "direct" consent) before practitioners or researchers may access a patient's medical records. In this challenge, we will be exploring capabilities in the Azure health data platform that make it possible for patients to opt out of sharing their FHIR records with certain parties.

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

## Step 1 - Configure FHIR-Proxy authentication settings
For the first part of this challenge, you will go to another page and follow the instructions for configuring FHIR-Proxy authentication settings. 

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the FHIR-Proxy authentication setup instructions in a new browser tab. When you go to the page, you will be following the instructions in Step 2 and Step 3 (you already completed the instructions in Step 1 when you deployed resources in Challenge-01).

[FHIR-Proxy Authentication Setup Instructions](../resources/docs/FHIR-Starter_ARM_template_README.md#step-2---complete-fhir-proxy-authentication)

## Step 2 - Configure Postman to connect with the FHIR-Proxy endpoint
In the next part of this challenge, you will be setting up Postman so that API calls made from Postman go through the FHIR-Proxy endpoint rather than the FHIR service endpoint.

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the Postman setup instructions for FHIR-Proxy in a new browser tab.

[Postman Tutorial for FHIR-Proxy](../resources/docs/Postman_FHIR-Proxy_README.md)

## Step 3 - Confirm Postman configuration

1. Now you will confirm that the FHIR service contains `Patient` Resources. Go ahead and enter this API call into Postman.

```
GET {{fhirurl}}/Patient?_summary=count
```

Press **Send** and you should receive a bundle as shown below.

![Patient Resources](./images/patient-count-postman.png) 

2. Select a Patient Resource of your choosing and record the [patient identifier](https://www.hl7.org/fhir/patient.html#ids). This will be used to create the Consent Resource.

## Step 4 - Post Consent Record to FHIR Service

1. Review and update (as needed) the sample Consent Resource, which may be found [here](./sample-data/consent-resource.json). Be sure to use the Patient Resource obtained in Step 3.
2. Create a new request in Postman and post the Consent Resource.

## Step 5 - Configure Secure FHIR Consent Opt-Out

1. Refer to the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md) for additional details.
2. [Configure the Consent Opt Filter](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md). The FP-POST-PROCESSOR-TYPES must be updated to include FHIRProxy.postprocessors.ConsentOptOutFilter.
3. Additionally the FP-MOD-CONSENT-OPTOUT-CATEGORY setting with a value of `http://loinc.org|59284-0` must be added if it does not exist.

## Step 6 - Verify Consent Opt-Out filtering

1. Link a user to an appropriate FHIR resource. See the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md) for additional details. Ensure that the linked user is not assigned to the FHIR-Proxy administrator role.

2. Sample query patient result.![Query patient](./images/ConsentOptOut-Withheld-2.png) 


## What does success look like for Challenge-07?

+ Successfully POST a consent record to the Azure Health Data Services FHIR service
+ Verify that Consent Opt-Out properly filters Resources

## Next Steps

Click [here](<../Challenge-08 - DICOM/Readme.md>) to proceed to the next challenge.

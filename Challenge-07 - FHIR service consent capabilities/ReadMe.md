# Challenge-07 - FHIR service consent capabilities

## Introduction

Welcome to Challenge-07!

In this challenge, you will learn how to configure Consent Opt-Out filtering for the FHIR service using [FHIR-Proxy](https://github.com/microsoft/fhir-proxy) (OSS).

## Background

In the digital transformation of healthcare, the wide adoption of FHIR R4 has removed certain barriers of access to patient health data. With this increased access, FHIR R4 also gives patients more control over what parties have access to patient data. Health institutions are required by law to guard patients' Personal Health Information (PHI). One way this is managed is by requiring patient consent (either "broad" or "direct" consent) before practitioners or researchers may access a patient's medical records. In this challenge, we will be exploring capabilities in the Azure health data platform that make it possible for patients to opt out of sharing their FHIR records with certain parties.

## Learning Objectives for Challenge-07
By the end of this challenge you will be able to 

+ Configure FHIR-Proxy authentication for connecting to FHIR service
+ Configure Postman to connect with FHIR service via FHIR-Proxy
+ Configure Consent Opt-Out filtering in FHIR-Proxy
+ Add a Consent Resource to the FHIR service
+ Verify that Consent Opt-Out filtering performs as expected

## Prerequisites

+ Azure Health Data Services FHIR service instance with patient data (completed in previous challenges)
+ FHIR-Proxy deployed (completed in Challenge-01)
+ Postman installed (completed in Challenge-01) 
+ A text editor (e.g., [Visual Studio Code](https://code.visualstudio.com/)) 
+ Multiple Azure AD users to simulate user and/or administrator access to the FHIR service 

## Getting Started 
In this challenge, you will be setting up FHIR-Proxy to perform Consent Opt Out Filtering for the FHIR service. Additionally, you will be creating a new Postman environment to call the FHIR-Proxy endpoint. 

> Note: Within the 2023 fiscal year, the FHIR-Proxy Function App in its current form will be deprecated. The app’s features and functionality will be integrated into Azure Health Data Services FHIR service and other Azure resources. 

### FHIR-Proxy and FHIR service overview
In the Azure health data platform, FHIR service and FHIR-Proxy operate as a team. FHIR service is at the center of activity, and FHIR-Proxy acts as a pre- and post-processor, selectively filtering FHIR data on the way into and out of the FHIR service. Admins can set up FHIR-Proxy to listen to the stream of I/O data and trigger custom workflows based on specific FHIR events. FHIR-Proxy also brings enhanced Role-Based Access Control (RBAC) to FHIR service, allowing fine-grained authorization for REST API actions at the FHIR Resource level. This also provides a means of Role-Based Consent so that users (i.e., patients) can authorize or deny access to certain FHIR data.

Component View of FHIR-Proxy and FHIR service with Postman set up to call the FHIR-Proxy endpoint.

<img src="./images/Postman_FHIR-Proxy_ARM_template_deploy_AHDS.png" height="528">

FHIR-Proxy asserts control over I/O data only if its [pre- and/or post-processing modules](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#date-sort-post-processor) have been enabled and configured. Otherwise, with no special configuration, API calls made to the FHIR-Proxy endpoint go straight through to the FHIR service, and responses are sent back unfiltered to the remote client app (e.g., Postman). 

## Step 1 - Configure FHIR-Proxy authentication settings
Before setting up FHIR-Proxy for Consent Opt Out filtering, you will need to configure FHIR-Proxy authentication to securely connect with the FHIR service.

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the FHIR-Proxy authentication setup instructions in a new browser tab. When you go to the page, follow the instructions in Step 2 and Step 3 (you already completed the instructions in Step 1 when you deployed resources in Challenge-01). Please return here when finished. 

[FHIR-Proxy Authentication Setup Instructions](../resources/docs/FHIR-Starter_ARM_template_README.md#step-2---complete-fhir-proxy-authentication)

## Step 2 - Configure Postman to connect with the FHIR-Proxy endpoint
In the next part of this challenge, you will be setting up Postman so that API calls made from Postman go to the FHIR-Proxy endpoint rather than directly to the FHIR service endpoint.

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the Postman setup instructions for FHIR-Proxy in a new browser tab. Follow the instructions and return here when finished.

[Postman Tutorial for FHIR-Proxy](../resources/docs/Postman_FHIR-Proxy_README.md)

## Step 3 - Confirm Postman configuration

1. Be sure to select `fhir-proxy` as your active Postman environment (upper right-hand corner). 

2. Check to make sure that you can access `Patient` Resources on the FHIR service (with Postman connected to the FHIR-Proxy endpoint). Go ahead and run the `Count All Patients` request in your FHIR Search collection in Postman.

```
GET {{fhirurl}}/Patient?_summary=count
```

You should receive a bundle as shown below (the number of patients will be different from what is shown in the image). 

![Patient Resources](./images/patient-count-postman.png) 

To confirm you have the correct `Patient` and `Practitioner` Resources that you will be using in this challenge, send the following requests in Postman:

`GET {{fhirurl}}/Patient/WDT000000001`

`GET {{fhirurl}}/Practitioner/WDT000000003`

You should receive a `200 OK` response for each of these requests (in addition to the Resource in each response **Body**). If not, you will need to run the `Save Sample Resources` request again in the FHIR Search collection in Postman (this step was covered in Challenge-04).

## Step 4 - Post Consent Record to FHIR service

1. Review the sample `Consent` Resource in the `consent-resource.json` file located [here](./sample-data/consent-resource.json). You will see that `Patient/WDT000000001` is opting out of sharing records with `Practitioner/WDT000000003`.

2. Now you will create a new request in Postman for adding the `consent-resource.json` as a `Consent` Resource in your FHIR service. 
    - Go to the FHIR CALLS collection in Postman and click **Add request**.
    - Name the new request `POST Consent Resource`.
    - Either copy/paste or import the `consent-resource.json` file into the **Body** of your new `POST Consent Resource` request in Postman.
    - When ready, press `Send` to populate your FHIR service with the new `Consent` Resource. You should receive `201 Created` in response (in addition to the `Consent` Resource in the response **Body**).

## Step 5 - Create a Practitioner role for yourself in FHIR-Proxy

1. Go to **Portal** -> **AAD** -> **Enterprise Applications** -> **FHIR-Proxy App** -> **Users and groups** and click on **+Add user/group**.




## Step 6 - Link your AAD Object ID to a FHIR Practitioner Resource ID

1. Link a user to an appropriate FHIR resource. See the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#linking-users-in-participant-roles-to-fhir-resources) for details. Ensure that the linked user is not assigned to the FHIR-Proxy administrator role.

2. Sample query patient result.![Query patient](./images/ConsentOptOut-Withheld-2.png) 


## What does success look like for Challenge-07?

+ Successfully `POST` a consent record to the FHIR service.
+ Verify that Consent Opt-Out properly filters Resources.

## Next Steps

Click [here](<../Challenge-08 - DICOM service/Readme.md>) to proceed to the next challenge.

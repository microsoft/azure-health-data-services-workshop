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
+ Test data in your FHIR service (completed in Challenge-04, Step 1)

## Getting Started 
In this challenge, you will be setting up FHIR-Proxy as a FHIR gateway to perform Consent Opt-Out Filtering for the FHIR service. This is an example of advanced authorization. Additionally, you will be creating a new Postman environment to call the FHIR-Proxy endpoint.

### FHIR-Proxy and FHIR service overview
In the Azure health data platform, FHIR-Proxy acts as a gateway for calls to the FHIR service. The FHIR-Proxy is an example of an add-on gateway which enables pre- and post-processors on requests, selectively filtering FHIR data on the way into and out of the FHIR service. You can setup FHIR-Proxy as an example to intercept FHIR calls and trigger custom workflows based on specific FHIR requests. FHIR-Proxy also enables attribute based access control (ABAC) on top of the FHIR service, allowing fine-grained authorization for REST API actions at the FHIR Resource level. This also provides a means of Role-Based Consent so that users (e.g. patients) can authorize or deny access to certain FHIR data.

Component View of FHIR-Proxy and FHIR service with Postman set up to call the FHIR-Proxy endpoint.

<img src="./images/Postman_FHIR-Proxy_ARM_template_deploy_AHDS.png" height="528">

FHIR-Proxy asserts control over FHIR requests only if its [pre- and/or post-processing modules](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#date-sort-post-processor) have been enabled and configured. Otherwise, with no special configuration, API calls made to the FHIR-Proxy endpoint go straight through to the FHIR service, and responses are sent back unfiltered to the client app (like Postman in our case).

## Step 1 - Configure FHIR-Proxy authentication settings
Before setting up FHIR-Proxy for Consent Opt-Out filtering, you will need to configure FHIR-Proxy authentication to securely connect with the FHIR service.

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the FHIR-Proxy authentication setup instructions in a new browser tab. When you go to the page, follow the instructions in Step 2 and Step 3 (you already completed the instructions in Step 1 when you deployed resources in Challenge-01). Please return here when finished. 

[FHIR-Proxy Authentication Setup Instructions](../resources/docs/FHIR-Starter_ARM_template_README.md#step-2---complete-fhir-proxy-authentication)

## Step 2 - Configure Postman to connect with the FHIR-Proxy endpoint
In the next part of this challenge, you will be setting up your environment so that API calls made from Postman go to the FHIR-Proxy endpoint rather than directly to the FHIR service endpoint.

To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below to open the Postman setup instructions for FHIR-Proxy in a new browser tab. Follow the instructions and return here when finished.

[Postman Tutorial for FHIR-Proxy](../resources/docs/Postman_FHIR-Proxy_README.md)

## Step 3 - Confirm Postman configuration

1. Be sure that `fhir-proxy` is selected as your active environment in Postman (upper right-hand corner). 

2. Check that you can access `Patient` Resources on the FHIR service with Postman connected to the FHIR-Proxy endpoint. Try running the `Count All Patients` request in your FHIR Search collection in Postman.

```
GET {{fhirurl}}/Patient?_summary=count
```

You should receive a bundle as shown below (the number of patients will be different from what is shown in the image). 

<img src="./images/patient-count-postman.png" height="528"> 

To confirm you have the `Patient` and `Practitioner` Resources needed for this challenge, send the following requests in Postman:

`GET {{fhirurl}}/Patient/WDT000000001`

`GET {{fhirurl}}/Practitioner/WDT000000003`

You should receive a `200 OK` response for each of these requests (in addition to the Resource in the response **Body**). If not, you will need to run the `Save Sample Resources` request again in the FHIR Search collection in Postman (this step was covered in Challenge-04).

## Step 4 - Post Consent Record to FHIR service
Here you will prepare a [Consent Resource](https://www.hl7.org/fhir/consent.html) to enable the [Consent Opt-Out filter](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#consent-opt-out-filter) in FHIR-Proxy.

1. Review the sample `Consent` Resource in the `consent-resource.json` file located [here](./sample-data/consent-resource.json). You will see that `Patient/WDT000000001` is opting out of sharing records with `Practitioner/WDT000000003`.

2. Now you will create a new request in Postman for adding this `Consent` Resource to your FHIR service.

+ Go to the FHIR CALLS collection in Postman and click **Add request**.
+ Name the new request `POST Consent Resource`.
+ In the URL field for the request, enter `{{fhirurl}}/Consent`.
+ Set the HTTP operation to `POST`.
+ Either copy/paste or import the `consent-resource.json` [file]((./sample-data/consent-resource.json)) into the **Body** of your new `POST Consent Resource` request in Postman.
+ When ready, press `Send` to populate your FHIR service with the new `Consent` Resource. You should receive `201 Created` in response (in addition to the `Consent` Resource in the response **Body**).

## Step 5 - Add a Practitioner and Administrator role in FHIR-Proxy
 To configure Consent Opt-Out, you must first create a FHIR Participant role for the individual (or organization) being blocked from access to a patient's FHIR data. In the real world, you would be associating a FHIR Participant role with a provider (or organization), and you would be activating the `Consent` Resource on behalf of a patient to block said provider (or organization) from accessing the patient's FHIR records. In this example, for simplicity you are not going to be blocking an individual (or organization), but rather you will add the FHIR Participant role to your Postman client as though Postman is the provider (i.e., `Practitioner/WDT000000003`) who is not allowed to access FHIR data belonging to `Patient/WDT000000001`. Just imagine that the Postman service client is an individual (or organization) trying to access this patient's data on your FHIR service.  

 You will be configuring FHIR-Proxy to block `Practitioner/WDT000000003` from accessing FHIR data belonging to `Patient/WDT000000001`. Review [this information](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#configuring-participant-authorization-roles-for-users) about configuring FHIR Participant roles for FHIR-Proxy and then return here when finished.

1. Go to **Portal** -> **AAD** -> **App Registration** -> **Postman Client** -> **API permissions**.

*Note: In the above, "Postman Client" will be whatever you named the App Registration for Postman.*

2. Click on **+Add a permission**, choose **My APIs**, and select your Proxy Function App Registration.

3. Choose **Application permissions**,  and ensure **Practitioner** and **Administrator** are selected and added.

4. Click **Grant admin consent** for these new permissions. 

## Step 6 - Link the Postman Object ID to a FHIR Practitioner Resource ID

1. Now you will be linking the `Practitioner/WDT000000003` Resource to the Postman service client's **Object ID** in AAD. See the FHIR-Proxy configuration [documentation](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#linking-users-in-participant-roles-to-fhir-resources) for details on how this works. 

+ Go to **Portal** -> **AAD** -> **App Registrations** -> **Postman Client**.
+ Copy the **Object ID** from the Overview blade.

2. In Postman, create a new request in the FHIR CALLS collection called `GET Link Roles`.
3. In the URL field for the request, input this string (set the HTTP operation to `GET`):
    - `https://<fhir_proxy_app_name>.azurewebsites.net/manage/link/Practitioner/WDT000000003/<object-id>`
4. Press **Send**. You will get back text saying the link has been established with a response code of `200`.

See [here](https://github.com/microsoft/fhir-proxy/blob/main/docs/configuration.md#consent-opt-out-filter) for more information about the Consent Opt-Out filter in FHIR-Proxy. 

## Step 7 - Confirm Consent Opt-Out is working

1. Now, if you send a `GET {{fhirurl}}/Patient/WDT000000001` request again using Postman, you should receive an `"access-denied"` response as shown below. This indicates that Consent Opt-Out is working properly.

2. Sample query patient result. 
<img src="./images/ConsentOptOut-Withheld-2.png" height="528"> 

## What does success look like for Challenge-07?

+ Successfully `POST` a consent record to the FHIR service.
+ Verify that Consent Opt-Out properly filters a `Patient` Resource.

## Next Steps

Click [here](<../Challenge-08 - DICOM service/Readme.md>) to proceed to the next challenge.

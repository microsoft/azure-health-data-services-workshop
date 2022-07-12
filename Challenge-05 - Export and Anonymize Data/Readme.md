# Challenge-05 - Export and Anonymize Data

## Introduction

Welcome to Challenge-05!

In this challenge, you will learn how to export de-identified data from the FHIR service.

## Background

Healthcare organizations frequently conduct research studies with patient medical records as the main source of data. This type of study where patient health records are used for non-treatment purposes is referred to as "secondary use" research. In the U.S., access to patients' Personal Health Information (PHI) for secondary use is strictly controlled by two federal regulations: [The Revised Common Rule](https://www.hhs.gov/ohrp/regulations-and-policy/regulations/finalized-revisions-common-rule/index.html) and the [Health Insurance Portability and Accountability Act (HIPAA)](https://www.cdc.gov/phlp/publications/topic/hipaa.html#:~:text=The%20Health%20Insurance%20Portability%20and,the%20patient's%20consent%20or%20knowledge.). In the latter case, researchers are not allowed to access patients' PHI unless the information has been de-identified following HIPAA guidelines. De-identification (or anonymization) of PHI involves removing details from patients' medical data that could reveal patients' identities. HIPAA outlines two methods of de-identification: the [HIPAA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#safeharborguidance) and the [HIPAA Expert Determination Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#guidancedetermination). In this challenge, we will get practice using the Azure health data platform to de-identify and export FHIR data according to HIPAA Safe Harbor guidelines.

## Learning Objectives for Challenge-05

By the end of this challenge you will be able to 

+ configure bulk export of FHIR data from FHIR service
+ use a sample anonymization config file to de-identify FHIR data on export
+ export anonymized data to an [Azure Data Lake Storage Gen2](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) account
+ share anonymized data with a group not affiliated with your organization

## Prerequisites

+ An Azure environment with a working FHIR service instance (completed in Challenge-01) 
+ [Azure Data Lake Storage Gen2](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) (ADLS Gen2) deployed in your Azure environment (completed in Challenge-01) 
+ Postman installed and configured to connect with your FHIR service (completed in Challenge-01) 
+ FHIR data loaded into FHIR service (completed in previous challenges).
  + For a more rich experience with this challenge (and future challenges), [load this bundle](./synthea_sample_data_fhir_r4%20OpenHack.zip) into the `zip` container in your FHIR Loader storage account (as done in Challenge-03) 

## Getting started

In this challenge, you will be using the `$export` command in FHIR service to export de-identified FHIR data into an ADLS Gen2 blob storage container. The `$export` command in FHIR service is an implementation of the bulk export function detailed in the [FHIR Bulk Data Access specification](https://hl7.org/fhir/uv/bulkdata/export/index.html). To familiarize yourself with the FHIR service `$export` operation, please read [this documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data) and return here when finished. 

## Step 1: Review sample anonymization configuration and customize if needed

1. Microsoft provides a [sample configuration file](https://docs.microsoft.com/azure/healthcare-apis/fhir/de-identified-export#configuration-file) to demonstrate how de-identification works between the FHIR service and an ADLS Gen2 account. In real-world use, you would need to review the HIPAA Safe Harbor guidelines and customize the configuration file with additional anonymization rules (e.g., rules for redacting/transforming patient names).

  More information on HIPAA de-identification rules can be found [here](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html).

## Step 2: Configure storage account for export
1. Follow [these instructions](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/de-identified-export) for creating your `anonymizationConfig.json` file and placing it inside the `anonymization` container within your "**expsa**" storage account.

2. Next, go [here](https://docs.microsoft.com/azure/healthcare-apis/fhir/configure-export-data) and follow the instructions for configuring your "**expsa**" storage account for the `$export` operation. Read the note below about the FHIR service managed identity.

  **Note:** When you deployed FHIR service in Challenge-01, a [managed identity](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) was automatically enabled on the FHIR service resource. That managed identity is what needs to be added to the ADLS Gen2 storage account with the **Storage Blob Data Contributor** role. The storage account (also deployed in Challenge-01) is in your resource group and has a name ending with "**expsa**". Keep in mind that you are configuring the storage account in this step (not the FHIR service). In the storage account, be careful not to add a role assignment to a service client or a service principal by mistake!

  For information on bulk export from the FHIR service, review [How to export FHIR data](https://docs.microsoft.com/azure/healthcare-apis/fhir/export-data).

## Step 3: Export anonymized data

1. Now you will go to the `FHIR CALLS` collection in Postman and prepare a new request for a de-identified `$export`. This API call will cause the FHIR service to export all resources in de-identified form to the `anonymization` container in the "**expsa**" storage account. 

> You can create a new request in Postman by clicking on the existing `GET List Patients` request and selecting **Duplicate** from the **View more actions** menu. Select **Rename** and name the new request `GET Export Anonymized FHIR Data` (the `GET` should already be present on the left). 

  The general form of the request string will be:

  ```sh
  GET {{fhirurl}}/$export?_container={{containerName}}&_anonymizationConfig={{configFilename}}
  ```
  It's recommended to add the `containerName` and `configFilename` parameters to your `fhir-service` environment in Postman. Otherwise, you will need to put these names directly in the request string.

2. In Postman, go to the **Authorization** tab for the `GET Export Anonymized FHIR Data` request and make sure that **Inherit auth from parent** is selected. 

3. Under the **Headers** tab for the `GET Export Anonymized FHIR Data` request in Postman, add/modify the three headers as shown below. A screenshot of the **Headers** tab in Postman is provided for reference.

+ `Accept: application/fhir+json`
+ `Authorization: Bearer {{bearerToken}}`
+ `Prefer: respond-async`

![export-header](./media/Export_Headers.png)

4. Be sure to **Save** your `GET Export Anonymized FHIR Data` request.

5. Refresh your access token if necessary.

6. Once everything is set up and ready to go, press **Send** in Postman to initiate the `$export` request.

The `$export` operation uses the [FHIR Asynchronous Request Pattern](https://hl7.org/fhir/R4/async.html). Detailed information on headers for bulk export operations in FHIR can be found [here](https://hl7.org/Fhir/uv/bulkdata/export/index.html#headers).

7. You should receive a `202 Accepted` response.

8. Now if you go to your "**expsa**" storage account, there should be a new folder within the `anonymization` container. Go to this folder to access the de-identified FHIR data that you just exported (inside the folder, each row will have three dots on the right side - click these three dots and select **View/Edit**). You will notice that information has been removed/redacted from the FHIR records per the anonymization rules defined in the `anonymizationConfig.json` file. 

## Step 4: Securely transfer the files to the research team

Researchers from outside organizations cannot have direct access to healthcare or payer organizations' Azure tenants. You will need to find a way to securely transfer the anonymized data to these external groups.

1. Review the [Create SAS Tokens](https://docs.microsoft.com/azure/cognitive-services/translator/document-translation/create-sas-tokens?tabs=Containers) documentation for setting up a Shared Access Signature (SAS) token. Then, generate a SAS token to allow a research team to access the anonymized data that you exported.

**Note**: Pay special attention to the "Permissions" section of the above documentation. **Reading** files and **listing** files in a container are two different permissions.

## What does success look like for Challenge-05?

+ Successfully use an anonymization configuration file and the `$export` operation to export anonymized data from the FHIR service.
+ Successfully set up a SAS token to allow access to the anonymized data.

## Next Steps

Click [here](<../Challenge-07 - FHIR service consent capabilities/ReadMe.md>) to proceed to the next challenge.

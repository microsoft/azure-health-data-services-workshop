# Challenge-05 - Export and Anonymize Data
## Introduction

Welcome to Challenge-05!

In this challenge, you will learn how to export de-identified data from the FHIR service.

## Background

Healthcare organizations frequently conduct research studies with patient medical records as the main source of data. This type of study where patient health records are used for non-treatment purposes is referred to as "secondary use" research. In the U.S., access to patients' Personal Health Information (PHI) for secondary use is strictly controlled by two federal regulations: [The Revised Common Rule](https://www.hhs.gov/ohrp/regulations-and-policy/regulations/finalized-revisions-common-rule/index.html) and the [Health Insurance Portability and Accountability Act (HIPAA)](https://www.cdc.gov/phlp/publications/topic/hipaa.html#:~:text=The%20Health%20Insurance%20Portability%20and,the%20patient's%20consent%20or%20knowledge.). In the latter case, researchers are not allowed to access patients' Personal Health Information (PHI) unless the information has been de-identified according to HIPAA guidelines. De-identification (or anonymization) of PHI involves removing details from patients' medical data that could reveal patients' identities. HIPAA outlines two methods of de-identification for compliance with federal regulations: the [HIPAA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#safeharborguidance) and the [HIPAA Expert Determination Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#guidancedetermination). In this challenge, we will get practice using the Azure health data platform to de-identify and export FHIR data according to HIPAA Safe Harbor guidelines.

## Learning Objectives for Challenge-05
By the end of this challenge you will be able to
* Configure bulk export of FHIR data from FHIR service
* Use the sample anonymization config file to de-identify FHIR data on export
* Export anonymized data to an [Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) account
* Share anonymized data with a group not affiliated with your organization

## Prerequisites 
* An Azure environment with a working FHIR service instance 
* FHIR data loaded into FHIR service. If the data you have loaded does not include Immunization or Patient Resources, go ahead and [load this bundle](./synthea_sample_data_fhir_r4%20OpenHack.zip) for a small dataset or use [Synthea](https://synthetichealth.github.io/synthea/) to obtain a larger dataset.
* [Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) (ADLS Gen2) deployed in your Azure environment

## Getting started

In this challenge, you will be using the `$export` command in FHIR service to export de-identified FHIR data into an ADLS Gen2 blob storage container. The `$export` command in FHIR service is an implementation of the bulk export function detailed in the [FHIR Bulk Data Access specification](https://hl7.org/fhir/uv/bulkdata/export/index.html). To familiarize yourself with the FHIR service `$export` operation's query parameters for de-identification, please read [this documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/data-transformation/de-identified-export) and return here when finished.


## Step 1: Review sample anonymization configuration and customize if needed
Microsoft provides a [sample configuration file](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/de-identified-export#configuration-file) for de-identifying data according to HIPAA Safe Harbor specifications. In real-world use, you would need to review the sample configuration and the HIPAA Safe Harbor rules to determine if the sample configuration is appropriate for your or your organization's needs. If the sample configuration doesn't meet your requirements for PHI de-identification, you would need to customize the configuration file with additional anonymization rules.

More information on HIPAA de-identification rules can be found [here](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html).

## Step 2: Configure FHIR service for export  
Next, go [here](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-export-data) and follow the instructions for how to configure FHIR service for export. Read the note below about the FHIR service managed identity.<br>

> Note: When you deployed FHIR service in Challenge-01, a [managed identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) was automatically enabled on the FHIR service resource. That managed identity is what needs to be added to the ADLS Gen2 storage account with the **Storage Blob Data Contributor** role. The storage account (also deployed in Challenge-01) is in your resource group and has a name ending with "expsa". In the storage account, be careful not to add a role assignment to a service client or a service principal by mistake! <br>

For additional information on bulk export from the FHIR service, it's recommended to review [How to export FHIR data](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/export-data).

## Step 3: Export anonymized data to a storage account
Perform a de-identified `$export` from the FHIR service. If you get stuck, refer to the documentation in Step 2. <br>

The general format of the query will be <br>
`https://<<FHIR service base URL>>/$export?_container=<<container_name>>&_anonymizationConfig=<<config file name>>&_anonymizationConfigEtag=<<ETag on storage>>`

The `$export` operation has these required headers. Below there is a screenshot of the **Headers** tab in Postman. 
* `Accept: application/fhir+json`
* `Authorization: Bearer {{bearerToken}}`
* `Prefer: respond-async.` <br>

![export-header](./media/Export_Headers.png) <br>

More information on headers for bulk export operations in FHIR is available [here](https://hl7.org/Fhir/uv/bulkdata/export/index.html#headers).

## Step 4: Securely transfer the file to the research team
Researchers from outside organizations cannot have direct access to healthcare or payor organizations' Azure tennants. You will need to find a way to securely transfer the anonymized datasets to these external groups.

**Task:**  
Review the [Create SAS Tokens](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/document-translation/create-sas-tokens?tabs=Containers) documentation and then set up a Shared Access Signature (SAS) token to allow a research team to access the anonymized datasets that you exported.



## What does success look like for Challenge-05?

+ Successfully utilize an anonymization configuration file and the $export operator to export an anonymized dataset from the FHIR service
+ Successfully set up a SAS token to allow access to the anonymized dataset

## Next Steps

Click [here](<../Challenge-06 - Research Azure Data Analytics/Readme.md>) to proceed to the next challenge.

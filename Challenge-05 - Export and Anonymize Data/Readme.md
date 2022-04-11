# Challenge-05 - Export and Anonymize Data
## Introduction

Welcome to Challenge-05!

In this challenge, you will learn how to export de-identified data from the FHIR service.

## Background

Healthcare organizations frequently conduct research studies in which patients' medical records are the main source of data. In studies like this in the U.S., access to patients' Personal Health Information (PHI) is strictly controlled by two federal regulations: [The Revised Common Rule](https://www.hhs.gov/ohrp/regulations-and-policy/regulations/finalized-revisions-common-rule/index.html) and the [Health Insurance Portability and Accountability Act (HIPAA)](https://www.cdc.gov/phlp/publications/topic/hipaa.html#:~:text=The%20Health%20Insurance%20Portability%20and,the%20patient's%20consent%20or%20knowledge.). In the latter case, researchers are not allowed to access patients' Personal Health Information (PHI) unless the information has been de-identified according to HIPAA guidelines. De-identification (or anonymization) of PHI involves removing details from patients' medical data that could reveal patients' identities. There are two methods of de-identification specified in HIPAA: the (HIPAA Safe Harbor Method)[https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#safeharborguidance] and the (HIPAA Expert Determination Method)[https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html#guidancedetermination]. In this challenge, we will get practice using the Azure health data platform to export FHIR data that has been de-identified according to HIPAA Safe Harbor guidelines.

## Learning Objectives for Challenge-05
By the end of this challenge you will be able to
* Configure bulk export of FHIR data from FHIR service
* Use the sample anonymization config file to de-identify FHIR data on export
* Export anonymized data to an ADLS Gen2 account
* Share anonymized data with a group not affiliated with your organization

## Prerequisites 
* An Azure environment with a working FHIR service instance. 
* FHIR data loaded into FHIR service. If the data you have loaded does not include Immunization or Patient Resources, go ahead and [load this bundle](https://github.com/kamoclav/openhack-mc4h-2/blob/main/Challenge-9/synthea_sample_data_fhir_r4%20OpenHack.zip) for a small dataset or check out [Synthea](https://synthetichealth.github.io/synthea/) for a larger dataset.
* Azure Data Lake Storage Gen2 deployed in your Azure environment.

## Step 1: Review sample anonymization configuration and customize if needed
Microsoft provides a sample configuration file for anonymizing data according to HIPAA Safe Harbor specifications. It's important to review the sample configuration and the HIPAA Safe Harbor rules to determine if the sample configuration will work for your organization. If the sample configuration doesn't meet your organization's requirements for PHI de-identification, you will need to implement your own anonymization rules in the configuration file.

More information on HIPAA de-identification rules can be found [here](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html).

**Task:**  
Configure your FHIR service for export to a storage account following the instructions [here](https://docs.microsoft.com/en-us/azure/healthcare-apis/data-transformation/configure-export-data). <br>

Note: You are enabling a managed identity on the FHIR service resource. That managed identity is what needs to be added to the storage account with Storage Blob Data Contributor privledges. Be careful not to add a service client or a service principle by mistake. <br>

For more information on the sample anonymization file, check out [de-identified-export-operation-on-the-fhir-server](https://github.com/microsoft/Tools-for-Health-Data-Anonymization/blob/master/docs/FHIR-anonymization.md#how-to-perform-de-identified-export-operation-on-the-fhir-server).

For a general overview of the `$export` operation's query parameters for de-identification, check out [this documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/data-transformation/de-identified-export).


## Step 2: Export anonymized data to a storage account

**Task:**  
Perform a de-identified `$export` from the FHIR service. If you get stuck, refer to the documentation in Step 1. <br>

The general format of the query will be <br>
`https://<<FHIR service base URL>>/$export?_container=<<container_name>>&_anonymizationConfig=<<config file name>>&_anonymizationConfigEtag=<<ETag on storage>>`

The `$export` operation has required headers 
* Accept: application/fhir+json
* Authorization: Bearer {{bearerToken}}
* Prefer: respond-async. <br>

![export-header](./media/Export_Headers.png) <br>

For more information on headers, check out this [documentation](https://hl7.org/Fhir/uv/bulkdata/export/index.html#headers).

## Step 3: Securely transfer the file to the research team
Researchers from outside organizations cannot have direct access to Healthcare or Payor organizations' Azure tennants. You will need to set up a way to securely transfer the anonymized datasets to these external groups.

**Task:**  
Set up a shared access signature (SAS) token to allow a research team to access the anonymized datasets that you exported.

If you get stuck, check out [Create SAS Tokens](https://docs.microsoft.com/en-us/azure/cognitive-services/translator/document-translation/create-sas-tokens?tabs=Containers).

## What does success look like for Challenge-05?

+ Successfully utilize an anonymization configuration file and the $export operator to export an anonymized dataset from the FHIR service
+ Successfully set up a SAS token to allow access to the anonymized dataset

## Next Steps

Click [here](<../Challenge-06 - Research Azure Data Analytics/Readme.md>) to proceed to the next challenge.

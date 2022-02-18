# Challenge-03 - Ingest to FHIR

## Introduction

Welcome to Challenge-03!

In this challenge, you will learn how to use the [FHIR-Bulk Loader](https://github.com/microsoft/fhir-loader) utility to bulk-ingest data into Azure API for FHIR.

## Background

Bulk FHIR data ingestion is a vital capability for managing FHIR data operations at scale. Since no $import operation has been published in the FHIR standard (yet), implementors rely on alternative methods for getting bulk FHIR data into a FHIR server. In this challenge, we will be using the current best-practice solution for bulk FHIR import into Azure API for FHIR: the FHIR-Bulk Loader (OSS).

## Learning Objectives

+ Practice identifying issues in bulk FHIR data
+ Understand data constraints with FHIR bulk data loading
+ Understand how to track and compare bulk FHIR imports

### Azure API for FHIR, FHIR-Proxy, and FHIR-Bulk Loader Relationship 
The open-source [FHIR-Bulk Loader](https://github.com/microsoft/fhir-loader) tool is an Azure component designed to expedite bulk import of FHIR data into Azure API for FHIR. The process involves uploading FHIR data to the FHIR-Bulk Loader's designated blob storage in Azures, from where FHIR-Bulk Loader automatically loads the data for persistence in Azure API for FHIR. For the remainder of this challenge, we assume you are using FHIR-Bulk Loader connected directly to Azure API for FHIR (bypassing FHIR-Proxy).

Below is a component view of Azure API for FHIR with FHIR-Bulk Loader and FHIR-Proxy.  

![components](./media/components.png)


## Prerequisites
+ Successful completion of Challenge-01
+ Postman installed
+ Access to a text editor (e.g., [VS Code](https://code.visualstudio.com/))

## Getting Started
For this challenge, you will prepare FHIR data for importing into Azure API for FHIR with FHIR-Bulk Loader. You will need to examine some of the data for problems and determine what the issue with the data is.


## Step 1 - Download Sample Data

1. Download the following files to your desktop
    + [good_bundles.zip](/docs/assets/zip/good_bundles.zip)
    + [bad_bundles.zip](/docs/assets/zip/bad_bundles.zip)

## Step 2 - Upload Sample Data

1. In the Azure Portal, navigate to the FHIR-Bulk Loader Blob Storage resource that was created in Challenge-01.

2. Click on `Storage browser (preview)` and then click on `Blob container`.
![Blob Containers](./media/portal-browser-container.png)  

3. Using the `good_bundles.zip` file downloaded in Step 1:
    + Determine which container this file should be uploaded to.

4. Using  the `bad_bundles.zip` file downloaded in Step 1:
    + Determine which container this file should be uploaded to.

> Refer to the Troubleshooting section below or FHIR Bulk Loader [testing](https://github.com/microsoft/fhir-loader/blob/main/docs/testing.md) documentation for more information.


## What does success look like for Challenge-03?

+ Successfully upload and import data from the file `good_bundles.zip`
+ Successfully identify the problem in the `bad_bundles.zip` file.  Use the Troubleshooting tips below to help. 
+ Identify the **most important issue to address in production**

## Troubleshooting 
The most common issue is that files are not loaded.  Use these points to understand where something happened. 

Check Container bundlesprocessed and / or bundleserr for your file name.  

_Note: if you used a zip file the names of the bundles within the zip file are exposed, not the zip file itself_

![bundlesprocessed](./media/bundlesprocessed.png)

Click on a **.result** file, then click on Edit

![bundle-edit](./media/bundle-edit.png)

In the Editor view, look for status codes, here a 201 is successful, and the logs show the FHIR Resource now containing the information. 

![bundle-edit-status](./media/bundle-edit-status.png)

## Next Steps

Click [here](../Challenge-04/Readme.md) to proceed to the next challenge.

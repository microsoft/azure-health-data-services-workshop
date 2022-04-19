# Challenge-03 - Bulk Load Data into FHIR

## Introduction

Welcome to Challenge-03!

In this challenge, you will learn how to use the [$import operation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-import-data)  to bulk-ingest FHIR data into the FHIR service.

## Background

The `$import` operation is a vital capability for managing FHIR data operations at scale. There is no official `$import` operation defined in the FHIR specification yet, so this approach was developed by Microsoft to enable loading of data as part of the FHIR service. The `$import` operation utilizes the [newline delimited JSON (ndjson) format](http://ndjson.org/), which is the default format for using bulk data with FHIR. This feature is currently targeted for initial data load into the FHIR server.

## Learning Objectives for Challenge-03

By the end of this challenge you will be able to 

+ Bulk ingest FHIR data into FHIR service with `$import`
+ Identify issues in bulk FHIR data
+ Recognize data constraints with bulk FHIR data loading
+ Track the `$import` operation


## Prerequisites

+ Successful completion of Challenge-01
+ Postman installed
+ Access to a text editor (e.g., [Visual Studio Code](https://code.visualstudio.com/))

## Getting Started

For this challenge, you will upload bulk FHIR data (in `ndjson` format) for import into FHIR service. You will need to examine error logs and determine what is preventing the data in one of the bundles from being ingested.

## Step 1 - Configure the FHIR Service for `$import`

Firstly, the FHIR service needs to be configured to enable `$import`. Since this operation is targeted at initial load, it's currently not possible to update FHIR resources through the REST API while `$import` is enabled. Due to this, `$import` must be enabled and disabled when you are planning to run the operation. The `$import` operation can be enabled with Postman, but we will be using an APM template in this challenge. Read [this documentation page](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-import-data) for more information.

1. To begin, CTRL+click (Windows or Linux) or CMD+click (Mac) on the Deploy to Azure button below to open the deployment form in a new browser tab. This ARM template will enable `$import` in the FHIR service and setup the associated storage account.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmicrosoft%2Fazure-health-data-services-workshop%2Fmay22-challenge-03%2FChallenge-03%2520-%2520Bulk%2520Load%2520Data%2520into%2520FHIR%2Ftemplates%2Ftoggle_import.json)

*Note: This configuration change generally takes about 20 minutes. You can do steps 2 and 3 in the meantime.***

## Step 2 - Download Sample Data

Start by downloading these two .zip files to your desktop (when you click the links, you will see a `download` button on the right). Extract the `.zip` files and inspect the files from the archives to see the difference.

+ [bulk_ndjson.zip](./samples/bulk_ndjson.zip)
+ [bundles.zip](./samples/bundles.zip)

## Step 3 - Upload samples to Azure

1. In Azure Portal, navigate to the Blob Storage account that was created in step 1. Go to **Portal -> Resource Group -> Storage account** (the name of the Storage account will end in "sa").

<img src="https://thumbs.dreamstime.com/b/orange-post-note-isolated-white-7874325.jpg" height="100">

2. In the Storage account, click on the **Storage browser (preview)** blade and then click on **Blob containers**. 

<img src="https://thumbs.dreamstime.com/b/orange-post-note-isolated-white-7874325.jpg" height="100">

3. Click on the **import** container and upload the `ndjson` files downloaded in Step 2 of this challenge.

<img src="https://thumbs.dreamstime.com/b/orange-post-note-isolated-white-7874325.jpg" height="100">

## Step 4 - Use Postman to start importing

Visit the FHIR docs website [here](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/import-data) and read the documentation for more info on the principles of this operation.

Use Postman to follow the instructions to craft the request.

**#TODO - fill out**

Reference - https://hl7.org/fhir/R4/async.html


## Step 5 - Debug issues with importing bulk FHIR data 

1. Now try importing one or more of the bundle file that you downloaded in Step 2 of this challenge. Upload the files to the same container where you uploaded the `ndjson` files. Start an `$import` operation with one or more of the bundles.

2. What happens as a result?

**#TODO - retool with ndjson with same IDs?**

## Step 6 - Disable `$import` in the FHIR service

Before moving on to the next steps, you need to disable the `$import` operation to continue future challenges. 

1. Use the `Deploy to Azure` button from step 1 to re-run the same operation with "Toggle Import" set to false.

*Note: This configuration change generally takes about 20 minutes. This will not block you from working on the next challenge as you can still read data from the FHIR service.***

## Troubleshooting 

**#TODO - fill out**

## What does success look like for Challenge-03?

+ Successfully upload and import data from the ndjson files
+ Successfully identify the problem in the bad files. Use the Troubleshooting tips above for help. 

## Next Steps

Click [here](<../Challenge-04 - Query and Search FHIR/Readme.md>) to proceed to Challenge-04.

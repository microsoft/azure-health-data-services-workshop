# Challenge-08 - DICOM service

## Introduction

Welcome to Challenge-08!

In this challenge, you will get experience working with medical images using the [DICOM service](https://docs.microsoft.com/azure/healthcare-apis/dicom/) in Azure Health Data Services. 

## Background

The [DICOMweb™](https://www.dicomstandard.org/using/dicomweb) standard is the RESTful API protocol used throughout the health industry for medical image storage, querying, and exchange. The DICOM service within [Azure Health Data Services](https://docs.microsoft.com/azure/healthcare-apis/healthcare-apis-overview) is a DICOMweb™-compliant server that ingests and persists DICOM objects at multiple thousands of images per second. DICOM service in Azure Health Data Services facilitates transmission of imaging data with any DICOMweb™ enabled system or application through standard transactions like [Store (STOW-RS)](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-services-conformance-statement#store-stow-rs), [Search (QIDO-RS)](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-services-conformance-statement#search-qido-rs), and [Retrieve (WADO-RS)](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-services-conformance-statement#retrieve-wado-rs). DICOM service is part of Azure Health Data Services, which enables [HIPAA](https://docs.microsoft.com/azure/compliance/offerings/offering-hipaa-us) and [HITRUST](https://docs.microsoft.com/azure/compliance/offerings/offering-hitrust) compliance for all [PHI (protected health information)](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) stored within an Azure Health Data Services workspace. This means you can upload PHI data to the DICOM service and the data will remain safely within the Azure Health Data Services workspace compliance boundary. In this challenge, we will be looking at how to deploy, configure, and use DICOM service for its foundational features.

## Learning Objectives for Challenge-08
By the end of this challenge you will be able to 

- Set up a DICOM service instance within an Azure Health Data Services workspace
- Configure DICOM service settings for usage
  - Add role assignment
  - Obtain an access token
- Ingest DICOM files into the service 
- Search among the flies that are stored within the DICOM service
- Retrieve DICOM files 
- Check logs of changes in DICOM service via Change Feed
- Manage supported tags in your DICOM service instance
  - Add extended query tags
  - List extended query tags
  - Get extended query tags
  - Update extended query tags
  - Delete extended query tags

## Prerequisites
- Azure Health Data Services workspace (deployed in Challenge-01)  
- Postman installed (completed in Challenge-01)

## Initial Setup

### Step 1 - Find your Azure Health Data Services workspace using Azure Portal
In Challenge-01 of this workshop, you deployed an Azure Health Data Services workspace in your resource group. You can view your Azure Health Data Services workspace settings by navigating to **Portal** -> **Resource Group** and finding the resource with a name ending in **"ws"** (see image below).

<img src="./images/Screenshot 2022-04-25 110347.png" height="420">

Click on the item in the list. Then, scroll down and click on the **DICOM services** blade. Once there, click on the **+Add DICOM service** button and proceed to the next step.

### Step 2 - Set up DICOM service using Azure Portal

Now you will visit another page and follow the instructions to [Deploy DICOM service using the Azure portal](https://docs.microsoft.com/azure/healthcare-apis/dicom/deploy-dicom-services-in-azure). Go directly to #3 in the instructions and begin from there. Then return here when finished.

### Step 3 - Configure Azure roles for access to DICOM data

You will need to add the **DICOM Data Owner** role for yourself (i.e., your username in Azure) as well as for the Postman service client that you created in Challenge-01 ([documentation available here](https://docs.microsoft.com/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)).

When finished setting up the Azure role assignment for yourself and your Postman service client, you must generate an access token. Listed below are several ways to accomplish this. Choose the method that works best for you.
- Create a new Postman environment and use it to generate a token. 
  - View the images in the [hints](./hints) folder if you need help. 
- Use an [Azure PowerShell](https://docs.microsoft.com/azure/healthcare-apis/get-access-token?tabs=azure-powershell#obtain-and-use-an-access-token-for-the-dicom-service) command.
- Use an [Azure CLI](https://docs.microsoft.com/azure/healthcare-apis/get-access-token?tabs=azure-cli#obtain-and-use-an-access-token-for-the-dicom-service) command.

### Step 4 - Choose a path for the rest of the challenge

From here, you will be using the DICOM service for the features outlined in the [beginning of this challenge](#learning-objectives-for-challenge-08). You have the option to follow either of these paths:

**Basic Path**  
You can use an already configured Postman collection to execute the series of tasks.

-or-

**Advanced Path**  
You can follow the provided articles that go over how to programmatically communicate with the DICOM service using C#, Python, or cURL.

## Basic Path

### Step 1 - Configure Postman to connect with DICOM service

You already installed Postman in Challenge-01 of this workshop. Now you will configure Postman to connect with DICOM service. 

1. Access the `Conformance-as-Postman.postman_collection.json` file [here](https://github.com/microsoft/dicom-server/blob/main/docs/resources/Conformance-as-Postman.postman_collection.json) and download it to your local desktop. 

2. Open the `Conformance-as-Postman.postman_collection.json` file in a text editor and find the `"file"` object for each of the three `POST Store-single-instance` calls. Remove the value of the `"src"` for each `"file"` object so that it looks like this: 

```
  "file": {
          "src": ""
          },
```

3. Save the `Conformance-as-Postman.postman_collection.json` file. 

4. Then go to the Postman **Import** window. Click on **Upload Files** and **Import** the `Conformance-as-Postman.postman_collection.json` file.

5. Create a new Postman environment called `DICOM-service` and add `bearerToken` as a parameter. Store the access token [that you obtained earlier](#step-3---configure-azure-roles-for-access-to-dicom-data) as the `bearerToken` value (use CURRENT VALUE).

6. Create a `baseUrl` parameter in your `DICOM-service` environment and populate it with the Service URL: `https://<workspacename-dicomservicename>.dicom.azurehealthcareapis.com`. 

7. Create a `resource` parameter in your `DICOM-service` environment and populate it with the following URL: `https://dicom.healthcareapis.azure.com`.

8. Once your `DICOM-service` Postman environment is set up and configured, please go to [this repo](https://github.com/microsoft/dicom-server/tree/main/docs/dcms) and download the three DICOM instance files (.dcm).  

9. Then, for each of the three `POST Store-single-instance` calls in the `Conformance-as-Postman` collection, in Postman go to **Body** -> **Select File** and choose the appropriate .dcm file (downloaded in the previous step). 

### Step 2 - Execute Outlined Features via Postman Collection

The `Conformance-as-Postman` collection has a complete set of API calls that you can execute one by one. See the list below for details. 

- Store DICOM files to the service 
- Search among the flies that are stored within the DICOM service
- Retrieve DICOM instance 
- Check logs of changes in DICOM service via Change Feed
- Manage extended query tags in your DICOM service instance
    - Add extended query tags
    - List extended query tags
    - Get extended query tags
    - Update extended query tags
    - Delete extended query tags

## Advanced Path

### Step 1 - Choose your preferred method for uploading, searching, and retrieving DICOM images (C#, cURL, or Python)

Each method comes with a set of prerequisites and instructions for getting started:

C# - https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-c-sharp

cURL - https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-curl

Python - https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-python

### Step 2 - Check the logs of the changes in the DICOM service via Change Feed 

The Change Feed provides logs of all the changes that occur in your DICOM service. You can view instructions in this [Change Feed Overview article](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-change-feed-overview).

### Step 3 - Manage Extended Query tags in your DICOM service instance

By default, the DICOM service supports querying on the DICOM tags specified in the [conformance statement](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-services-conformance-statement#searchable-attributes). By enabling extended query tags, the list of tags can easily be expanded based on the application's needs.

You can follow the instructions given in this [Extended Query Tag Overview article](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-extended-query-tags-overview) to manage query tags.

## What does success look like for Challenge-08?
+ Provison and configure DICOM service for ingestion and storage of DICOM studies.
+ Use DICOM service to upload, search, and retrieve DICOM studies.
+ Check changes log (Change Feed).
+ Add/remove additional query tags.

## Next Steps

Click [here](<../Challenge-09 - MedTech service/Readme.md>) to proceed to the next challenge.

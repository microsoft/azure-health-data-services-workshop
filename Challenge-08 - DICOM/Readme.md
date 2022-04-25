# Challenge-08 - DICOM

## Introduction

Welcome to Challenge-08!

In this challenge, you will get experience working with medical images using the [DICOM service](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/) in Azure Health Data Services. 

## Background

The [DICOMweb™](https://www.dicomstandard.org/using/dicomweb) standard is the RESTful API protocol used throughout the health industry for medical image storage, querying, and exchange. The DICOM service within [Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview) (AHDS) is a DICOMweb™-compliant server that ingests and persists DICOM objects at multiple thousands of images per second. DICOM service in AHDS facilitates transmission of imaging data with any DICOMweb™ enabled system or application through standard transactions like [Store (STOW-RS)](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-conformance-statement#store-stow-rs), [Search (QIDO-RS)](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-conformance-statement#search-qido-rs), and [Retrieve (WADO-RS)](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-conformance-statement#retrieve-wado-rs). DICOM service is backed by the AHDS Platform-as-a Service (PaaS) in the cloud with complete [HIPPA PHI](https://www.hhs.gov/answers/hipaa/what-is-phi/index.html) compliance. This means you can upload PHI data to the DICOM service and the data will remain safe within AHDS workspace secure networks. In this challenge, we will be looking at how to deploy, configure, and use DICOM service for its foundational features.

## Learning Objectives for Challenge-08
By the end of this challenge you will be able to 

- Set up a DICOM service instance within an Azure Health Data Services (AHDS) Workspace
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
Azure Health Data Services workspace (deployed in Challenge-01) 

## Initial Setup

### Step 1 - Find your Azure Health Data Services workspace using Azure Portal
In Challenge-01 of this workshop, you deployed an Azure Health Data Services workspace in your resource group. You can view your AHDS workspace settings by navigating to **Portal** -> **Resource Group** and finding the resource with a name ending in "ws" (see image below).

<img src="./images/Screenshot 2022-04-25 110347.png" height="420">

Click on the item in the list. Then, scroll down and click on the **DICOM services** blade. Once there, click on the **+Add DICOM service** button and proceed to the next step.

### Step 2 - Set up DICOM Service using Azure Portal

Now you will visit a another page and follow the instructions to [Deploy DICOM service using the Azure portal](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/deploy-dicom-services-in-azure). Go directly to #3 in the instructions and begin from there. Then return here when finished.

### Step 3 - Configure Azure roles for access to DICOM data

You will need to add the **DICOM Data Owner** role for yourself (i.e., your username in Azure) as well as for the Postman service client that you created in Challenge-01 ([documentation available here](https://docs.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)).

When finished setting up Azure RBAC roles for yourself and your Postman service client, you can generate an access token by following these [instructions](https://docs.microsoft.com/en-us/azure/healthcare-apis/get-access-token?tabs=azure-powershell#obtain-and-use-an-access-token-for-the-dicom-service).

### Step 4 - Choose a path for the rest of the challenge

From here, you will be using the DICOM service for the features outlined in the [beginning of this challenge](#learning-objectives-for-challenge-08). You have the option to follow either of these paths:

**Basic Path** You can use an already configured Postman collection to execute the tasks mentioned in the beginning of the challenge.

Or

**Advanced Path** You can follow the provided articles that go over how to programmatically call with DICOM service API using C#, Python, or cURL.

## Basic Path

### Step 1 - Install & Configure Postman tool

To install Postman tool go to [Download Postman](https://www.postman.com/downloads/).

To configure Postman tool, execute following steps:

Import conformance-as-postman-collection:
- Copy raw content [here](https://github.com/microsoft/dicom-server/blob/main/docs/resources/Conformance-as-Postman.postman_collection.json)
- Import copied raw content into installed Postman via import - raw text path.

Add access token that you have obtained earlier as bearer token into Postman.

### Step 2 - Execute Outlined Features via Postman Collection

Once the Postman in the prior step is set up and configured, follow the steps to download DICOM instances (.dcm) as samples from the [dicom-server repo](https://github.com/microsoft/dicom-server/tree/main/docs/dcms). 

Postman collection will have a complete set of a collection where you can execute following steps by replacing your service URL and required data input:

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

### Step 1 - Choose and follow a method for uploading, searching, retrieving images (C#, cURL, or Python)

Each method comes with set of prerequisites and instructions to follow:

C# - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-c-sharp

cURL - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-curl

Python - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-python

### Step 2 - Check the logs of the changes in the DICOM service via Change Feed 

The Change Feed provides logs of all the changes that occur in DICOM service. You can follow instructions at [Change Feed Overview article](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-change-feed-overview) to consume change feed.

### Step 3 - Manage Extended Query tags in your DICOM service instance

By default, the DICOM service supports querying on the DICOM tags specified in the [conformance statement](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-conformance-statement#searchable-attributes). By enabling extended query tags, the list of tags can easily be expanded based on the application's needs.

You can follow instructions at [Extended Query Tag Overview article](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-extended-query-tags-overview) to manage query tags.

## [BONUS] Challenge for DICOM service

Register a DICOM viewer app that you are already familiar with by following [instructions](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-application).
Configure registered DICOM viewer that you just registered with by adding the DICOM service from this exercise as its back end and review images. 

## What does success look like for Challenge-08?
+ Provisoning and configuring DICOM service for consumption
+ Upload, search and retrieve DICOM studies into the DICOM service
+ Check log of changes
+ Add/remove additional query tags

## Next Steps

Click [here](<../Challenge-09 - IoT Connector for FHIR/Readme.md>) to proceed to the next challenge.
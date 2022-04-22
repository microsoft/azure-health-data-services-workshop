# Challenge-08 - DICOM

## Introduction

Welcome to Challenge-08!

In this challenge, you will get experience working with medical images using the [DICOM service](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/) in Azure Health Data Services. 

## Background

The [DICOMweb™](https://www.dicomstandard.org/using/dicomweb) standard is the RESTful API protocol used throughout the health industry for medical image storage, querying, and exchange. In Azure Health Data Services, the DICOM service coupled with FHIR service via Microsoft's [DICOMcast](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicom-cast-overview) presents new opportunities for combined text and medical image-based studies. In this challenge, we will be looking at how to use DICOM service to ingest, store, and retrieve images, and we will get some hands-on experience using DICOMcast to synchronize data between DICOM service and FHIR service.

## Learning Objectives for Challenge-08

By the end of this challenge you will be able to 

+ Set up a DICOM service instance within an Azure Health Data Services workspace
+ Submit DICOM files to the service
+ Successfully view the files with a DICOM Viewer connected to a FHIR service

## Prerequisites

+ An Azure environment with a working Azure Health Data Services workspace (completed in Challenge-01).

## Initial Setup

### Step 1 - Download Challenge Dependencies

You will need to download some DICOM files and a DICOM viewer from the open source Microsoft Medical Imaging Server repository for use in this challenge.

1. Download the sample `.DCM` files from the `samples` folder for this challenge.

2. Download the whole [Microsoft Medical Imaging Server](https://github.com/microsoft/dicom-server) repository from GitHub.

**Note**: You can either use the "Download Zip" button that appears after clicking the green `Code` button on GitHub or the `git clone` command.

### Step 2 - Set up DICOM Service using Azure Portal

The automated deployment from Challenge-01 only deployed an Azure Health Data Service workspace and FHIR service. In this challenge, you will be creating a DICOM service manually.

1. Follow [this quickstart](https://docs.microsoft.com/azure/healthcare-apis/dicom/deploy-dicom-services-in-azure) to deploy a DICOM service into your existing Azure Health Data Services workspace with the Azure Portal.

    + **Note:** The deployment of DICOM service usually takes 6 minutes.
    + **Note:** Once the deployment is done, make sure to copy the `Service URL` from the Azure Portal.

2. Add the **DICOM Data Owner** role for yourself (e.g.., your username in Azure) as well as for the **Postman client application** from previous challenges ([documentation available here](https://docs.microsoft.com/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)).

3. Generate an access token for yourself (username) or the Postman client application your DICOM service. 
 
**Note:** Look at the *hints* folder or read [this page](https://docs.microsoft.com/azure/healthcare-apis/get-access-token?tabs=azure-cli#obtain-and-use-an-access-token-for-the-dicom-service) if you need help generating the token.

### Step 3 - Choose a path for the rest of the Challenge

Here you need to choose a path for completing the challenge. There are two paths:

+ **Basic Path** - GUI-based operations for uploading Images to the DICOM service

+ **Advanced Path** - Programmatic method for uploading images to DICOM service

## Basic Path

This path will use a tool to upload images to the DICOM service. You will need to setup the upload tool. Configure with the URL of the DICOM service you created Step 2. Then you will upload the image studies you downloaded from the `samples` folder.

### Step 1 - Install upload tool

The upload tool is part of the open source Medical Imaging Service for DICOM you downloaded from GitHub. Follow the instructions [here](https://github.com/microsoft/dicom-server/tree/main/tools/dicom-web-electron) to install and configure the tool. Where you see `localhost`, replace with the URL from the DICOM service created in Step 2.

You will need to install Node.js in your environment. Go to [nodejs.org](https://nodejs.org/) and install the latest version.

### Step 2 - Upload images

Once the tool in the prior step is set up and configured, follow the steps to upload the samples images from the [Microsoft Medical Imaging Service for DICOM](https://github.com/microsoft/dicom-server/tree/main/docs/dcms) GitHub repository.

### Step 3 - Open Viewer and View images -#FIXME

The DICOM service has a built in DICOM viewer. By copying and pasting the main URL for the DICOM Service into a web browser, you can see the list of uploaded Studies.

If you see three studies listed and if they open, then you have successfully completed this part of the challenge. Move to Part 2 of the challenge.

## Advanced Path

### Step 1 - Choose a method for uploading images (C#, cURL, or Python)

C# - [https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-c-sharp](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-c-sharp)

cURL - [https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-curl](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-curl)

Python - [https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-python](https://docs.microsoft.com/azure/healthcare-apis/dicom/dicomweb-standard-apis-python)

### Step 2 - Perform the sample tasks of uploading the files from the link(s) above

Once the tool in the prior step is set up and configured, follow the steps to upload the samples images from the [Microsoft Medical Imaging Service for DICOM](https://github.com/microsoft/dicom-server/tree/main/docs/dcms) GitHub repository.

### Step 3 - View Images in Browser - #FIXME

The DICOM service has a built in DICOM viewer. By copying and pasting the main URL for the DICOM service into a web browser, you can see the list of uploaded studies.

If you see three studies listed. If they open, then you have successfully completed this part of the challenge.

## Part 2

Depending on the path you took (Basic or Advanced), repeat your path using the image studies provided in the `samples` folder of this Challenge's repo.

Success is seeing actual human images in your studies in the DICOM service.

## What does success look like for Challenge-08?

+ Upload DICOM studies into the DICOM service
+ View human images in the DICOM service

## Next Steps

Click [here](<../Challenge-09 - IoT Connector for FHIR/Readme.md>) to proceed to the next challenge.

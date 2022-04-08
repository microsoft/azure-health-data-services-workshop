# Challenge-08 - DICOM

## Introduction

Welcome to Challenge-08!

In this challenge, you will get experience working with medical images using the [DICOM service](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/) in Azure Health Data Services. 

## Background

The [DICOMweb™](https://www.dicomstandard.org/using/dicomweb) standard is the RESTful API protocol used throughout the health industry for medical image storage, querying, and exchange. In Azure Health Data Services, the DICOM service coupled with FHIR service via Microsoft's OSS [DICOMcast](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-cast-overview) presents new opportunities for combined text and medical image-based studies. In this challenge, we will be looking at how to ingest, store, and retrieve images with DICOM Service, and we will get some hands-on experience using DICOMcast to synchronize records between DICOM service and FHIR service. 

## Learning Objectives for Challenge-08

- Set up a DICOM Service instance within Azure Health Data Services (AHDS)
- Submit DICOM files to the service
- Successfully view the files with a DICOM Viewer connected to the AHDS FHIR service

## Initial Setup

### Step 1 - Clone these repos

&nbsp;&nbsp;&nbsp;&nbsp; This workshop repo (If not already complete)

```azurecli
git clone https://github.com/microsoft/azure-api-for-fhir-workshop.git
```

&nbsp;&nbsp;&nbsp;&nbsp; The Medical Imaging Server for Azure

```azurecli
git clone https://github.com/microsoft/dicom-server.git
```


### Step 2 - Set up an Azure Health Data Services Workspace using Azure Portal
 
 [Deploy workspace in the Azure portal - Azure Health Data Services | Microsoft Docs](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-quickstart)


### Step 3 - Set up DICOM Service using Azure Portal

[Deploy DICOM service using the Azure portal](https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/deploy-dicom-services-in-azure)

Add **DICOM Data Owner** role for yourself (i.e., your username in Azure) as well as to the Postman client application [documentation here](https://docs.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)

Generate access token for user or Postman client application to resource https://dicom.healthcareapis.azure.com Check the *hints* folder if you need to find out how to generate the token.

### Step 4 - Choose a path for the rest of the Challenge

Here you need to choose a path for completing the challenge. There are two paths:
Basic Path and Advanced Path.

**Basic Path** - GUI-based operations for uploading Images to the DICOM Service

**Advanced Path** - Programmatic method for uploading images to DICOM Service

## Basic Path

This path will use a tool to upload images to the DICOM Service. You will need to setup the upload tool. Configure with the URL you created Step 3. Then upload the image studies.

### Step 1 - Install upload tool

The upload tool is part of the OSS Medical Imaging Service for DICOM. You cloned the repo for this tool in Step 2. Follow the instructions [here](https://github.com/microsoft/dicom-server/tree/main/tools/dicom-web-electron) to install and configure the tool. Where you see `localhost`, replace with the URL from the DICOM service created in Step 3.

You will need to install Node.js in your environment. Go to [nodejs.org](https://nodejs.org/) and install the latest version.

### Step 2 - Upload images

Once the tool in the prior step is set up and configured, follow the steps to upload the same images from the [dicom-server repo](https://github.com/microsoft/dicom-server/tree/main/docs/dcms). There should be three images.

### Step 3 - Open Viewer and View images

The DICOM service has a built in DICOM Viewer. By copying and pasting the main URL for the DICOM Service into a web browser, you can see the list of uploaded Studies.

If you see three studies listed and if they open, then you have successfully completed this part of the challenge. Move to Part 2 of the challenge.

## Advanced Path

### Step 1 - Choose a method for uploading images (C#, cURL, or Python)

C# - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-c-sharp

cURL - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-curl

Python - https://docs.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-python

### Step 2 - Perform the sample tasks of uploading the files from the link(s) above

Note: The sample files for the link above were downloaded via the second repo clone in Step 1. 

### Step 3 - View Images in Browser

The DICOM service has a built in DICOM Viewer. By copying and pasting the main URL for the DICOM service into a web browser, you can see the list of uploaded studies.

If you see three studies listed. If they open, then you have successfully completed this part of the challenge.

## Part 2

Depending on the path you took (Basic or Advanced), repeat your path using the image studies provided in the SampleData folder of this Challenge's repo.

Success is seeing actual human images in your studies in the DICOM service.

## Part 3 - BONUS Challenge

The bonus part of the challenge is to repeat your path but this time deploy the OSS Medical Imaging Server for DICOM. You have already cloned the repo for the tools.

Tip - The GitHub repo site has a Deploy to Azure button built in.

## What does success look like for Challenge-08?
+ Upload two DICOM studies into the DICOM Service
+ View human images in the DICOM Service

## Next Steps

Click [here](<../Challenge-09 - IoT Connector for FHIR/Readme.md>) to proceed to the next challenge.

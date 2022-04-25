# Challenge-09 - MedTech service

## Introduction

Welcome to Challenge-09!

In this challenge, you will get experience working with medical IoT data using the [MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/iot-connector-overview) in Azure Health Data Services.

## Background

With the rise of wearables and other connected sensor technologies, IoT devices have exploded in the healthcare marketplace. Currently, there is no single data standard for medical IoT device I/O, and this has resulted in many proprietary data models in use across the medical IoT landscape. To provide a centralized platform for medical IoT data connectivity, Microsoft has taken a vendor-agnostic approach, offering the MedTech service toolkit for converting output from any medical IoT device into FHIR. In this challenge, we will be using the MedTech service in Azure Health Data Services to ingest medical IoT data into the FHIR service.

## Learning Objectives for Challenge-09
By the end of this challenge you will be able to

- Deploy and configure the MedTech service via Azure portal
- Deploy and configure additional Azure services required for the MedTech service
- Connect the MedTech service to FHIR service
- Import a data mapping file for transforming incoming device data into FHIR
- Inspect medical IoT data flow

## Prerequisites 
+ Azure Health Data Services workspace deployed (completed in Challenge-01)
+ FHIR service deployed (completed in Challenge-01)
+ Postman installed (completed in Challenge-01)

## Getting Started 
In this challenge, you will be deploying MedTech service within your AHDS workspace configured to receive and transform medical IoT data for persistence in FHIR. The general steps in this challenge are outlined below.

**Step 1** - Deploy and configure [Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about).  
**Step 2** - Deploy a MedTech service instance in your Azure Health Data Services workspace.  
**Step 3** - Import data mappings for converting medical IoT device data into FHIR  
**Step 4** - Configure Azure Roles for MedTech Service to securely connect to the FHIR service.  

Have a look at [this document](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot) for an overview of the MedTech service deployment and configuration process (you already deployed an AHDS workspace and FHIR service in Challenge-01).

## Step 1 - Deploy and configure Azure Event Hubs
In the first part of this challenge, you will use the Azure Portal to deploy an Event Hubs namespace in preparation to create your own Event Hub.

1. To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below and follow the instructions for creating an Event Hubs namespace.

    [Create an Event Hubs namespace](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hubs-namespace)

2. Continue on to the next section in the link below to create your own Event Hub.

    [Create an Event Hub](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hub)

## Step 2 - Deploy MedTech service in your AHDS workspace 
Now you will use Azure Portal to deploy and configure MedTech service within your AHDS workspace.

1. Open the instructions to [Deploy MedTech service in the Azure Portal](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure) in a new browser tab. 

2. When you get to the part of the instructions to [Configure MedTech service to ingest data](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-medtech-service-to-ingest-data), for this training it is recommended to use the default [Consumer group](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features#consumer-groups) that was assigned to you when you deployed your Event Hub in the previous step. 

## Step 3



## Step 4 

## Step 5 - Setup IoT Mapping Tool

Follow the instructions for running the mapper [here](https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started)

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started

Skip the optional steps on this page.

The mapper will be at this address when running: http://localhost:5000

## Step 6 - Continue through making sample maps

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#how-to-make-mappings

At the end of Step 4 you will have a sample set of IoT Maps which can be used with the FHIR service and MedTech service.

For more information on the IoT Mappings visit the docs page - https://github.com/microsoft/iomt-fhir/blob/master/docs/Configuration.md.

__Note:__ When creating a new mapping, you must click the 'Confirm' button. Pressing ENTER after typing will not work.

## Step 7 (Optional)

Upload your newly created sample mappings to the MedTech service via the portal.

- Create a new IoT Connector.
- Figure out the steps for uploading a device mapping.
- Repeat for FHIR mapping.

## Step 8 (Optional)

This is the most difficult part of the challenge. However, this could be one of the most crucial to the success of an medical IoT/RPM project.

Use the IoT Mapper that you obtained earlier to create maps for the sample messages in the SampleData folder. There are three sample messages in one file - vitals, BP, and weight. Vitals is an array of data while BP & weight are single entry messages. The SampleData folder has two files. Both files are the same data. Three-Sample-Message-Types-with-labels.json is the message data with data descriptions and/or units of measure.

When you get to the FHIR mapping you can make up values for the 'Code'. For example - Code: A1235, System: https://loinc.org, Text: Heart Rate

## What does success look like for Challenge-09?
+ Map IoT medical device data to FHIR
+ Output a JSON file with mapped data

## Next Steps

Click [here](<../Challenge-10 - Optional - FhirBlaze (Blazor app dev + FHIR)/ReadMe.md>) to proceed to the next challenge.
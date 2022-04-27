# Challenge-09 - MedTech service

## Introduction

Welcome to Challenge-09!

In this challenge, you will get experience working with medical IoT data using the [MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/iot-connector-overview) in Azure Health Data Services.

## Background

With the rise of wearables and other connected sensor technologies, IoT devices have exploded in the healthcare marketplace. Currently, there is no single data standard for medical IoT device I/O, and this has resulted in many proprietary data models in use across the medical IoT landscape. To provide a centralized platform for medical IoT data connectivity, Microsoft has taken a vendor-agnostic approach, offering the MedTech service toolkit for converting output from any medical IoT device into FHIR. In this challenge, we will be using the MedTech service in Azure Health Data Services to map medical IoT data for ingestion into the FHIR service.

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
+ A [GitHub account](https://github.com/signup) (for cloning a repo in Step 5)
+ A command line environment for installing packages and running CLI tools in Step 5 ([Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) or a local Bash environment)  


## Getting Started 
In this challenge, you will be deploying MedTech service within your Azure Health Data Services workspace configured to receive and transform medical IoT data for persistence in FHIR. The steps in this challenge are outlined below.

**Step 1** - Deploy and configure [Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-about).  
**Step 2** - Deploy a MedTech service instance in your Azure Health Data Services workspace.  
**Step 3** - Import data mappings for converting medical IoT device data into FHIR.  
**Step 4** - Configure Azure Roles for MedTech Service to securely connect to the FHIR service.  
**Step 5** - Install tools for creating custom IoT data mappings for FHIR.  
**Step 6** - Create custom IoT data maps.

Have a look at [this document](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot) for an overview of the MedTech service deployment and configuration process (you already deployed an Azure Health Data Services workspace and FHIR service in Challenge-01).

## Step 1 - Deploy and configure Azure Event Hubs
In the first part of this challenge, you will use the Azure Portal to deploy an Event Hubs namespace in preparation to create your own Event Hub.

1. To begin, **CTRL+click** (Windows or Linux) or **CMD+click** (Mac) on the link below and follow the instructions for creating an Event Hubs namespace.

    [Create an Event Hubs namespace](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hubs-namespace)

2. Continue on to the next section in the link below to create your own Event Hub.

    [Create an Event Hub](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hub)

## Step 2 - Deploy MedTech service in your Azure Health Data Services workspace 
Now you will use Azure Portal to deploy and configure MedTech service within your Azure Health Data Services workspace.

1. Open the instructions to [Deploy MedTech service in the Azure Portal](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure) in a new browser tab. 

2. When you get to the part of the instructions to [Configure MedTech service to ingest data](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-medtech-service-to-ingest-data), for this training it is recommended to use the default [Consumer group](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-features#consumer-groups) that was assigned when you deployed your Event Hub in the previous step. 

## Step 3 - Import data mappings for converting medical IoT device data into FHIR

In the [Configure Device mapping properties](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-device-mapping-properties) section, you will be going to [another GitHub repository](https://github.com/microsoft/iomt-fhir/blob/main/docs/Configuration.md#device-content-mapping) and copying/pasting a sample data mapping template into the MedTech service **Device Mapping** tab in Azure Portal. Likewise, you will be copying/pasting a sample data mapping destination template into the MedTech service **Destination** tab in Azure Portal. 

## Step 4 - Configure Azure roles for MedTech service access

Now you will configure permissions so that MedTech service can securely connect with FHIR service and the Event Hub that you deployed in Step 1 of this challenge. Continue with [the instructions for granting access](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#granting-medtech-service-access) through to the end of the page and then return here when finished.

## Step 5 - Set up IoT Mapper Tool

Going a step further, you can visit [another GitHub repository](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper) and read about creating custom device mapping templates with Microsoft's OSS IoT mapper tool.

After you have gone through the instructions and installed the packages, when you launch the IoT mapper tool, the web app will be running at this address: http://localhost:5000. Copy the address and paste in your browser to access the IoT mapper tool interface.

## Step 6 - Make sample maps

Now you can get started making a set of custom IoT maps which can be used with the FHIR service and MedTech service. Follow the instructions [here](https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started) to get started with the IoT mapper tool. For in-depth information on IoT mapping, visit [this page](https://github.com/microsoft/iomt-fhir/blob/master/docs/Configuration.md).

__Note:__ When creating a new mapping, you must click the 'Confirm' button. Pressing ENTER after typing will not work.

## Step 7 -BONUS

Import your newly created sample mappings into the MedTech service via the Azure Portal. You can follow the same process in Step 3 of this challenge to import your custom mappings into MedTech service.

## Step 8 - BONUS

Use the IoT mapper tool that you obtained in Step 5 to create maps for the sample messages in the `SampleData` folder for this challenge (accessible at the top of the page). You will find that the `SampleData` folder has two files. Both files are the same data, but the `Three-Sample-Message-Types-with-labels.json` has messages with data descriptions and/or units of measure. There are three sample messages in each file - `VITALS`, `BP`, and `WEIGHT`. The `VITALS` message is an array of data. `BP` and `WEIGHT` are single-entry messages. 

When you begin the FHIR mapping, you can make up values for the 'Code'. For example - `Code: A1235, System: https://loinc.org, Text: Heart Rate`.

## What does success look like for Challenge-09?
+ Map IoT medical device data to FHIR
+ Output a JSON file with mapped data

## Next Steps

Click [here](<../Challenge-10 - Optional - FhirBlaze (Blazor app dev + FHIR)/ReadMe.md>) to proceed to the next challenge.
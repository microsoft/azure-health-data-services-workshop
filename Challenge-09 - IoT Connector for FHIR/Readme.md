# Challenge-09 - IoT Connector for FHIR

## Introduction

Welcome to Challenge-09!

In this challenge, you will get experience ingesting medical IoT data into the FHIR service using the [MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/iot-connector-overview) in Azure Health Data Services.

## Background

With the rise of wearables and other connected sensor technologies, IoT devices have exploded in the healthcare marketplace. Currently, there is no single data standard for medical IoT device I/O, and this has resulted in many proprietary data models in use across the medical IoT landscape. To provide a centralized platform for medical IoT data connectivity, Microsoft has taken a vendor-agnostic approach, offering the MedTech service toolkit for converting output from any medical IoT device into FHIR. In this challenge, we will be using the MedTech service in Azure Health Data Services to ingest medical IoT data into the FHIR service.

## Learning Objectives for Challenge-09
By the end of this challenge you will be able to

- Deploy and configure the MedTech service via Azure portal
- Deploy and configure additional Azure services required for the MedTech service
- Connect the MedTech service to FHIR service
- Create a map for incoming device data through to FHIR
- Inspect medical IoT data flow

## Prerequisites 
+ Azure Health Data Services workspace deployed (completed in Challenge-01)
+ FHIR service deployed (completed in Challenge-01)
+ Postman installed (completed in Challenge-01)

## Getting Started 
In this challenge, you will be deploying and configuring the MedTech service within your AHDS workspace to receive medical IoT data and transform it into FHIR for persistance in the FHIR service.

## Step 1
Let us begin with a basic walk through of the steps to [Deploy MedTech service in the Azure Portal](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure). 

## Step 2

Now let's go a step forward. This time let's create our own mappings using sample data.

## Step 3 - Install Node.js (If not already complete)

## Step 4 - Setup IoT Mapping Tool

Follow the instructions for running the mapper [here](https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started)

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started

Skip the optional steps on this page.

The mapper will be at this address when running: http://localhost:5000

## Step 5 - Continue through making sample maps

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#how-to-make-mappings

At the end of Step 4 you will have a sample set of IoT Maps which can be used with the FHIR service and MedTech service.

For more information on the IoT Mappings visit the docs page - https://github.com/microsoft/iomt-fhir/blob/master/docs/Configuration.md.

__Note:__ When creating a new mapping, you must click the 'Confirm' button. Pressing ENTER after typing will not work.

## Step 6 (Optional)

Upload your newly created sample mappings to the MedTech service via the portal.

- Create a new IoT Connector.
- Figure out the steps for uploading a device mapping.
- Repeat for FHIR mapping.

## Step 7 (Optional)

This is the most difficult part of the challenge. However, this could be one of the most crucial to the success of an medical IoT/RPM project.

Use the IoT Mapper from Challenge-09b to create maps for the sample messages in the SampleData folder. There are three sample messages in one file - vitals, BP, and weight. Vitals is an array of data while BP & weight are single entry messages. The SampleData folder has two files. Both files are the same data. Three-Sample-Message-Types-with-labels.json is the message data with data descriptions and/or units of measure.

When you get to the FHIR mapping you can make up values for the 'Code'. For example - Code: A1235, System: https://loinc.org, Text: Heart Rate

Answers are in the 'Answer' folder if you get stuck. Final mappings may vary from the answer mapping.

Hint - You may need to create multiple maps and combine the output into a single JSON file.

## What does success look like for Challenge-09?
+ Map IoT medical device data to FHIR
+ Output a JSON file with mapped data

## Next Steps

Click [here](<../Challenge-10 - Optional - FhirBlaze (Blazor app dev + FHIR)/ReadMe.md>) to proceed to the next challenge.
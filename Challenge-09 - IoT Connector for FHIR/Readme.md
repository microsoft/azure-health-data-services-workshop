# Challenge-09 - IoT Connector for FHIR

## Introduction

Welcome to Challenge-09!

In this challenge, you will get experience interfacing between IoT input streams and the FHIR service using the IoT Connector in Azure Health Data Services.

## Background

With the rise of wearables and other connected sensor technologies, IoT devices have exploded in the healthcare marketplace. Currently, there is no single data standard that applies to medical IoT devices, and this has resulted in many different proprietary data models across the medical IoT landscape. Microsoft has taken an agnostic approach to IoT connectivity, offering a tool kit for converting output from any medical IoT device into FHIR data. In this challenge, we will be using MedTech service in Azure Health Data Services to ingest IoT input data into FHIR service.

## Learning Objectives for Challenge-09

- Deploy and configure the IoT Connector via Azure portal
- Deploy and configure additional Azure services required for the IoT connector
- Connect the IoT Connector to FHIR service
- Create a map for incoming device data through to FHIR
- Understand the data flow for medical IoT data

## Challenges

### Challenge-09a

Let us begin with a basic walk through, performing the steps in this [IoT Quickstart](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/iot-fhir-portal-quickstart). Success for Challenge-09a means you can query the IoT FHIR Observation resource via Postman.

Link - https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/iot-fhir-portal-quickstart

__Note:__ Azure IoT Central is no longer needed. Please delete your Azure IoT Central instance prior to moving forward.

### Challenge-09b - Building Mappings from Sample Data

Now let's go a step forward. This time let's create our own mappings using sample data.

### Step 1 - Clone these repos

&nbsp;&nbsp;&nbsp;&nbsp; This workshop repo (If not already complete)

```azurecli
git clone https://github.com/microsoft/azure-healthcare-apis-workshop.git
```

&nbsp;&nbsp;&nbsp;&nbsp; IoMT FHIR Connector for Azure

```azurecli
git clone https://github.com/microsoft/iomt-fhir.git
```

### Step 2 - Install Node.js (If not already complete)

### Step 3 - Setup IoT Mapping Tool

Follow the instructions for running the mapper [here](https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started)

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#getting-started

Skip the optional steps on this page.

The mapper will be at this address when running: http://localhost:5000

### Step 4 - Continue through making sample maps

Link - https://github.com/microsoft/iomt-fhir/tree/master/tools/data-mapper#how-to-make-mappings

At the end of Step 4 you will have a sample set of IoT Maps which can be used with the FHIR service and IoT Connector.

For more information on the IoT Mappings visit the docs page - https://github.com/microsoft/iomt-fhir/blob/master/docs/Configuration.md.

__Note:__ When creating a new mapping, you must click the 'Confirm' button. Pressing ENTER after typing will not work.

### (Optional) Step 5

Upload your newly created sample mappings to the IoT Connector via the portal.

- Create a new IoT Connector.
- Figure out the steps for uploading a device mapping.
- Repeat for FHIR mapping.

## Challenge-09c

This is the most difficult challenge. However, this could be one of the most crucial to the success of an IoMT/ RPM project.

Use the IoT Mapper from Challenge-09b to create maps for the sample messages in the SampleData folder. There are three sample messages in one file - vitals, BP, and weight. Vitals is an array of data while BP & weight are single entry messages. The SampleData folder has two files. Both files are the same data. Three-Sample-Message-Types-with-labels.json is the message data with data descriptions and/or units of measure.

When you get to the FHIR mapping you can make up values for the 'Code'. For example - Code: A1235, System: https://loinc.org, Text: Heart Rate

Answers are in the 'Answer' folder if you get stuck. Final mappings may vary from the answer mapping.

Hint - You may need to create multiple maps and combine the output into a single JSON file.

## [BONUS] Challenge-09d

This challenge is a variation of Challenge-09a.  
Deploy and configure the OSS IoMT FHIR Connector for Azure. Use Azure IoT Central as the source and the mappings from the Quickstart.

Link to OSS - https://github.com/microsoft/iomt-fhir

## What does success look like for Challenge-09?
+ Map IoT medical device data to FHIR
+ Output a JSON file with mapped data

## Next Steps

Click [here](<../Challenge-10 - Optional - FhirBlaze (Blazor app dev + FHIR)/ReadMe.md>) to proceed to the next challenge.
# Challenge-11 - Power Platform Integration

## Introduction

Welcome to Challenge-11!

In this challenge, you will experiment with integration between the Power Platform and the FHIR service in Azure Health Data Services.

## Background

In today's health data production environments, low-code and no-code solutions are on the rise and the Microsoft Power Platform is one of the most prominent solutions in this space. Low-code solutions dramatically increase the speed of development and give non-professional developers the ability to create their own enterprise-ready apps. Enabling healthcare workers to build their own apps encourages people with clinical backgrounds to get involved in the digital transformation of the organisation. 

Having health-related apps built by the people who use the apps will accelerate your organisation's adoption of health data standards. A tool like the Power Platform allows your core developers to focus on the backend services and manage the data structures – giving end users controlled flexibility and power to build their own front end UIs to suit their needs.


## Learning Objectives for Challenge-11
By the end of this challenge you will be able to

- Connect a Power App to the FHIR service in Azure Health Data Services
- Use the FHIRBase and FHIRClinical connectors
- Create your own custom connector for interacting with data in the FHIR service


## Prerequisites 
+ Azure Health Data Services workspace deployed (completed in Challenge-01)
+ FHIR service deployed (completed in Challenge-01) 
+ Bulk data ingested (completed in Challenge-03)

## Getting Started 
In this challenge, you will be finalising a pre-built Power App and connect the app with your Azure Health Data Services workspace. You will be configuring the app to query and store data in the FHIR service.

**Step 1** - Import the sample app from the `./SampleData` folder using the Power Portal

**Step 2** - Configure the FHIRBase connector

**Step 3** - Create a custom connector for FHIR

**Step 4** - Validate the full functionality of the app  


Have a look at the [FHIRBase](https://docs.microsoft.com/en-us/connectors/fhirbase/) and [FHIRClinical](https://docs.microsoft.com/en-us/connectors/fhirclinical/) connector pages to get familiar with the methods, parameters, and responses supported by these tools.

## Step 1 - Import the sample app from the sample folder of this Challenge into the Power Portal
In the first step of this challenge, you will use the [Power Portal](https://make.powerapps.com/) to import the sample app and explore the app's functionality.

You can find how to import a Power App in the [Export and import canvas app packages](https://docs.microsoft.com/en-us/power-apps/maker/canvas-apps/export-import-app) documentation.

Once your app is imported, see if you can find the following attributes in the Power App.
- location where the default dataset is loaded to populate the gallery
- Patient Search query location
- Results view screen
- Screen to submit new results

## Step 2 - Configure the FHIRBase connector
You will have noticed that the sample app is returning a number of exceptions and is not showing any data. In this step you will add those data sources using the FHIRBase connector for making the core queries in the FHIR service.

**Note:** The FHIRBase and FHIRClinical connectors are (at time of this writing) in preview!

1. Add a new FHIRBase data source and connect it to the FHIR service you deployed in [Challenge-01](<../Challenge-01 - Deploy AHDS workspace and FHIR service/Readme.md>)
2. On the "homeScreen", you need to add the code to fetch all patients and display them in the gallery component.
3. Add the code to fetch the patient's first and lastname in the "lblName" label. 
4. The Patient ID field is not populated, so add the code to display the Synthea-generated patient identifier. 
5. (optional) Implement the patient search button. You can either use a filter on the patient dataset or do a new request to your FHIR service to fetch a subset of the stored data.


## Step 3 - Create a custom connector for FHIR

In this step you will create a custom connector to expose a set of FHIR resources to your app.
For this exercise, you could look into using the FHIRClinical connector rather than creating your own connector, but the FHIRClinical connector has some limitations.

When creating your custom connector, you need to implement the following FHIR API methods:
- GET DiagnosticReport
- POST DiagnosticReport
- GET Observation
- POST Observation

You can reuse the client id and secret you've used for Postman or you can create a new App Registration for the Power Platform.
Do verify the resources with some more information on how the Power Platform connects with your FHIR service API.
Alternatively, as a best practice, is that you can create a new App Registration dedicated to you Power App.

When creating the operations for this custom connector make sure to use the right request and response bodies as seen in Postman.
The UI for the custom connector will then pre-populate the payload and help with the references in the object that your Power Platform sees.
**Note:** You might get double references to objects like 'reference', 'system', 'code', etc. For these objects you can update the description or name so it's easier to map.


## Step 4 - Validate the full functionality of the app

Now that you've added both the FHIRBase and your own custom connector to connect with your FHIR service instance, the app should be fully functional.
Run trough the app with your coach and demonstrate the different screens.
You should be able to:
- show a list of all patients
- (optional) Filter the patient list
- Create a new "Complete blood count" diagnostic report and store the Observations in your FHIR service.
- Show results from the last "Complete blood count" diagnostic report


## Resources
- [Export and import canvas app packages](https://docs.microsoft.com/en-us/power-apps/maker/canvas-apps/export-import-app)
- [Canvas app data sources](https://docs.microsoft.com/en-us/power-apps/maker/canvas-apps/working-with-data-sources)
- [FHIRBase](https://docs.microsoft.com/en-us/connectors/fhirbase/)
- [Filter, Search, and LookUp Functions in Power Apps](https://docs.microsoft.com/en-us/power-platform/power-fx/reference/function-filter-lookup)
- FHIR resources used: [Patient](https://www.hl7.org/fhir/patient.html), [DiagnosticReport](https://www.hl7.org/fhir/diagnosticreport.html), [Observation]https://www.hl7.org/fhir/observation.html) 
- Sample [Diagnostic Report](https://www.hl7.org/fhir/diagnosticreport-example.html) used as inspiration.
- [Customer connectors](https://docs.microsoft.com/en-us/connectors/custom-connectors/) and [creating a custom](https://docs.microsoft.com/en-us/connectors/custom-connectors/define-blank)
- [Authenticate to FHIR API from Power App](https://docs.microsoft.com/en-us/power-query/connectors/fhir/fhir-authentication)

## What does success look like for Challenge-11?
+ Import the sample app and connect it to your Azure Health Data Services FHIR service.
+ Create a customer connector to create observations and diagnostic resources.

# Challenge-11 - Power Platform Integration

## Introduction

Welcome to Challenge-11!

In this challenge, you will experiment with the integration between the Power Platform and the FHIR service in the Azure Health Data Services.

## Background

Low-code and no-code solutions are on the rise and the Microsoft Power Platform is one of the most prominent solutions in this space. Low-Code solutions promise to increase speed of development and allow the citizen developer to create their own enterprise ready apps.
Enabling healthcare workers to build their own apps is a great way of getting these users involved in the digitalisation of the organisation.
Having health related apps build by the users who the app is intended for will increase adoption.
Lastly a tool like the Power Platform allows your core developers to build the backend services and manage the datastructures giving controlled flexibility to the end users to build apps.


## Learning Objectives for Challenge-11
By the end of this challenge you will be able to

- Connect to a AHDS FHIR API from a Power App
- Use the FHIRBase and FHIRClinical connectors
- Create your own custom connector for a FHIR API


## Prerequisites 
+ Azure Health Data Services workspace deployed (completed in Challenge-01)
+ FHIR service deployed (completed in Challenge-01) 
+ Bulk data ingested (completed in Challenge-03)

## Getting Started 
In this challenge, you will be finalising a pre build Power App and connect this with your Azure Health Data Services workspace, and you will be configuring the app to query and store data in the FHIR API.

**Step 1** - Import the sample app from the SampleData folder of this Challenge into the Power Portal

**Step 2** - Configure the FHIRBase connector

**Step 3** - Create a custom connector for FHIR

**Step 4** - Validate the full functionality of the app  


Have a look at the [FHIRBase](https://docs.microsoft.com/en-us/connectors/fhirbase/) and [FHIRClinical](https://docs.microsoft.com/en-us/connectors/fhirclinical/) connector pages to get familiar with the methods response.

## Step 1 - Import the sample app from the sample folder of this Challenge into the Power Portal
In the first step of this challenge, you will use the [Power Portal](https://make.powerapps.com/) to import the sample app and explore the functionality of this app.

You can find how to import a Power App in the [Export and import canvas app packages](https://docs.microsoft.com/en-us/power-apps/maker/canvas-apps/export-import-app) documentation page of the docs.

Once your app is important see if you can find the following attributes in the Power App.
- location where the default data set is loaded to populate the galary
- Patient Search query location
- Results view screen
- Screen to submit new results

## Step 2 - Configure the FHIRBase connector
You will have noticed that the sample app is showing a number of exceptions and is not showing any data. In this step you will add those data sources using the FHIRBase connector and adding the core queryies.

**Note:** The FHIRBase and FHIRClinical connectors are (at time of writing) still in preview!

1. Add a new FHIRBase datasource and connect it to the FHIR service you deployed in [Challenge-01](<../Challenge-01 - Deploy AHDS workspace and FHIR service/Readme.md>)
2. On the "homeScreen" screen you need to add the code to fetch all patients and display them in the gallery component.
3. Add the code to fetch the patient first and lastname in the "lblName" label. 
4. The Patient ID field is not populated, add the code to display the synthea patient identifier. 
5. (optional) implement the patient search button. You can either use a filter on the patient dataset or do a new request to your FHIR service to fetch the subset.


## Step 3 - Create a custom connector for FHIR

In this step you will create a custom connector to expose a set of FHIR resources to your app.
You could look into uysing the FHIRClinical connector as well but this connector has some limitations.

When creating a custom connector you need to implement the following methods:
- GET DiagnosticReport
- POST DiagnosticReport
- GET Observation
- POST Observation

You can reuse the client id and secret you've used for postman or create a new App Registration for the Power Platform.


## Step 4 - Validate the full functionality of the app

Now that you've added both the FHIRBase and your own custom connector to connect with your FHIR instance the app should be fully functional.
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
- FHIR resources used: [patient](https://www.hl7.org/fhir/patient.html), [DiagnosticReport](https://www.hl7.org/fhir/diagnosticreport.html), [Observation]https://www.hl7.org/fhir/observation.html) 
- Sample [Diagnostic Report](https://www.hl7.org/fhir/diagnosticreport-example.html) used as inspiration.
- [Customer connectors](https://docs.microsoft.com/en-us/connectors/custom-connectors/) and [creating a custom](https://docs.microsoft.com/en-us/connectors/custom-connectors/define-blank)

## What does success look like for Challenge-11?
+ Import the sample app and connect it to your AHDS FHIR service.
+ Create a customer connector to create observations and diagnostic resources.

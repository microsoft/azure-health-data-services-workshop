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
**Step 2** - Configure the FHIRBase and FHIRClinical connectors
**Step 3** - Create a custom connector for FHIR
**Step 4** - Validate the full functionality of the app  


Have a look at the [FHIRBase](https://docs.microsoft.com/en-us/connectors/fhirbase/) and [FHIRClinicalfor](https://docs.microsoft.com/en-us/connectors/fhirclinical/) connector pages to get familiar with the methods response.

## Step 1 - Import the sample app from the SampleData folder of this Challenge into the Power Portal.
In the first part of this challenge, you will use the Power Portal to import the sample app and explore the functionality of this app.

1. To begin, **CTRL+click** ...

## Step 2 - Configure the FHIRBase and FHIRClinical connectors. 
You will have noticed that the sample app is showing a number of exceptions and lacks some connectors. In this step you will add those data sources using the FHIRBase connector.
**Note:** The FHIRBase and FHIRClinical connectors are (at time of writing) still in preview!

1. Open the

## Step 3 - Create a custom connector for FHIR

In the...

## Step 4 - Validate the full functionality of the app

Now you will configure ....


## What does success look like for Challenge-11?
+ Import the sample app and connect it to your AHDS FHIR service.
+ Create a customer connector to create observations and diagnostic resources.

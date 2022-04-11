# Challenge-06  - Research Azure Data Analytics

## Introduction
Welcome to Challenge-06!

In this challenge, we will be doing some basic statistical analysis on a FHIR dataset. Additionally, there is a bonus data visualization step for learners with access to Power BI.

## Background
Data aggregated in FHIR offers rich analytics potential for all kinds of medical research, including public health research. Take, as an example, a public health campaign to increase Flu vaccination rates among a population. In order to boost public awareness of the Flu vaccine, public health officials first need to understand what factors may be behind the population's current Flu vaccination rates. In this challenge, we will be importing FHIR data into Azure Databricks to investigate how gender and/or age correspond with patients' Flu vaccine rates. As a bonus, we will be connecting Power BI to visualize vaccination rates across a geographic area.

## Part 1. Data Analysis and Statistical Modeling
In the first part of this challenge, we will discover if gender and/or age are good predictors of Flu vaccination rates.

### Learning Objectives for Challenge-06
* Import Anonymized FHIR data into Azure Databricks
* Flatten the data into a tabular format
* Produce descriptive statistics on the dataset
* Perform a Chi-Square test to determine the effect of one variable on another

Bonus
* Use Power BI to visualize elements within the dataset

### Prerequisites 
* Deployed FHIR service
* Azure Databricks
* Completed Challenge-05 - Export and Anonymize Data

### Step 1
Clone this repo: 

	https://github.com/microsoft/azure-api-for-fhir-workshop

### Step 2
Go to the 'Challenge-06 - Research Azure Data Analytics' directory in this repo and open ***Challenge - Research Azure Data Analytics.py*** in Azure Databricks.

The remaining steps in this challenge section will are detailed in the Azure Databricks notebook.

__Note:__ Confirm the container with the anonymized data you will be using in Databricks has access set to Public and allows anonymous read access for containers and blobs.

### Challenge Success
+ Successfully load FHIR data into Azure Databricks
+ Successfully convert the data to tabular format
+ Successfully perform statistical analyses on the data 

> If you are in possession of a [Power BI license](https://docs.microsoft.com/en-us/power-bi/fundamentals/service-features-license-type), proceed into the next part of this challenge.

## BONUS - Data Visualization and Business Intelligence

Given the dataset exported in Challenge-05, what geographic areas have the lowest Flu vaccination rates? 

### Learning Objectives
By the end of the section you will be able to 
* Write Anonymized FHIR data to Azure Synapse Analytics
* Create a Power BI report with a widget summarizing Flu vaccination rates geographically

### Prerequisites 
* Deployed FHIR service
* Power BI
* Azure Synapse Analytics
* Completed Challenge - Export and Anonymize Data
* Completed section #1 Data Analysis and Statistical Modeling of this challenge

### Step 1: Load Parquet data into Azure Synapse

#### 1. Open your Synapse workspace and import data from the storage account you wrote flattened parquet files to in Section 1: Data Analysis and Statistical Modeling  <br />
You will need Patient data and Immmunizaton data to explore geographic vaccination rates. <br />
<br />
If you get stuck, check out this article on the [Copy Data Tool in Azure Synapse](https://docs.microsoft.com/en-us/azure/data-factory/copy-data-tool?tabs=data-factory). <br />


### Step 2: Connect PowerBI, Load Synapse data, and report of vaccination rates by postal code <br />
Connect your PowerBI workspace to Azure Synapse, load the Patient and Immunization data into PowerBI<br />
You are interested in the Flu vaccination rates so you will need to join the datasets and create a field in the combined dataset that can be aggregated to achieve that rate. Pay attention to any data transformation necessary to join the datasets <br/>
<br/>
If you get stuck, check out this article on [creating custom columns in PowerBI](https://docs.microsoft.com/en-us/power-bi/create-reports/desktop-add-custom-column#:~:text=Use%20Power%20Query%20Editor%20to%20add%20a%20custom%20column,-To%20start%20creating&text=From%20the%20Home%20tab%20on,The%20Custom%20Column%20window%20appears.). <br />

Information on group by aggregations can be found [here](https://docs.microsoft.com/en-us/power-query/group-by#:~:text=Select%20Group%20by%20on%20the,the%20column%20used%20is%20Units).<br />


### What does success look like for Challenge-06?
+ Successfully load parquet data into Azure Synapse
+ Successfully explore Synapse data in PowerBi
+ Successfully produce a report of vaccination rate by postal code

## Next Steps

Click [here](<../Challenge-07 - FHIR service consent capabilities/ReadMe.md>) to proceed to the next challenge.

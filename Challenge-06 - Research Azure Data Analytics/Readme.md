# Challenge-06  - Research Azure Data Analytics

## Introduction
Welcome to Challenge-06!

Data shared and aggregated using the FHIR standard offers rich analytics potential.

In this challenge we will utilize FHIR data for analytics. The lesson will be broken into two sections:
+ Data Analysis & Statistical Modeling
+ Data Visualization and BI

## Background
To improve Flu vaccine rates, health systems need to understand what factors influence the Flu vaccination rates. In this challenge you will explore the effect of gender or age on patients' receiving the Flu shot or not and visually explore geographic vaccination rates.

## 1. Data Analysis and Statistical Modeling
Discover if gender or age has an effect on completion of a Flu shot

### Learning Objectives for Challenge-06
By the end of the section you will be able to
* Import Anonymized FHIR data into Azure Databricks
* Flatten the data structure to a tabular format
* Produce descriptive statistics on the dataset
* Visualize data elements within the dataset
* Perform a Chi-Square test to determine the effect of one variable on another

### Prerequisites 
* Deployed FHIR service
* Azure Databricks
* Completed Challenge - Export and Anonymize Data

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
 
## BONUS - Data Visualization and BI
> If you are in possession of a [Power BI license](https://docs.microsoft.com/en-us/power-bi/fundamentals/service-features-license-type), proceed into this bonus part of the challenge.

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

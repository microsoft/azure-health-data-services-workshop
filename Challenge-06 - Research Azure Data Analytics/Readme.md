# Challenge-06  - Research Azure Data Analytics

## Introduction
Welcome to Challenge-06!

In this challenge, you will be doing some basic statistical analysis on a FHIR dataset. Additionally, there is a bonus data visualization step for learners with access to Power BI.

## Background
Data aggregated in FHIR offers rich analytics potential for medical research of all sorts. Public health research is no exception. Take, as an example, a public health campaign to increase flu vaccination rates among a population. In order to boost public acceptance of the flu vaccine, public health officials first need to understand what factors may be behind the population's current flu vaccination rates. In this challenge, we will be importing FHIR data into [Azure Databricks](https://docs.microsoft.com/azure/databricks/scenarios/what-is-azure-databricks) to investigate how a population's flu vaccine rates may be correlated with gender and/or age. As a bonus, we will be connecting [Power BI](https://docs.microsoft.com/power-bi/) to visualize vaccination rates across a geographic area.

### Learning Objectives for Challenge-06
By the end of this challenge you will be able to 

* Import anonymized FHIR data into Azure Databricks
* Flatten the data into a tabular format
* Produce descriptive statistics on the dataset
* Perform a Chi-Square test to investigate the effect of one variable on another
* BONUS - Use Power BI to visualize elements within the dataset 

### Prerequisites 
* Deployed FHIR service (Challenge-01)
* Completed Challenge-05 - Export and Anonymize Data

## Part 1. Data Analysis and Statistical Modeling
**Research question:** Are gender and/or age good predictors of Flu vaccination rates?

### Step 1
#TODO - Deploy Azure Databricks
#TODO - Launch workspace
#TODO - Create Cluster - tell users to spin down after to not incur costs
#TODO - Import notebook

### Step 2
#TODO - Explain how to run commands in Azure Databricks
#TODO - Explain configuration
#TODO - Explain what is going on.

### Part 1 Challenge Success
+ Successfully load FHIR data into Azure Databricks
+ Successfully convert the data to tabular format
+ Successfully perform statistical analysis on the data 

> If you are in possession of a [Power BI license](https://docs.microsoft.com/power-bi/fundamentals/service-features-license-type), proceed into the next part of this challenge.

## BONUS - Part 2 - Data Visualization and Business Intelligence

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

#### 1. Open your Synapse workspace and import data from the storage account with the flattened parquet files you created in Part 1: Data Analysis and Statistical Modeling  <br />
You will need Patient data and Immmunizaton data to explore geographic vaccination rates. <br />
<br />
If you get stuck, check out this article on the [Copy Data Tool in Azure Synapse](https://docs.microsoft.com/azure/data-factory/copy-data-tool?tabs=data-factory). <br />


### Step 2: Connect Power BI, Load Synapse data, and report on vaccination rates by postal code <br />
Connect your Power BI workspace to Azure Synapse, load the Patient and Immunization data into Power BI.<br />
You are interested in the Flu vaccination rates so you will need to join the datasets and create a field in the combined dataset that can be aggregated to discover that rate. Pay attention to any data transformation necessary to join the datasets. <br/>
<br/>
If you get stuck, review this article on [creating custom columns in Power BI](https://docs.microsoft.com/power-bi/create-reports/desktop-add-custom-column#:~:text=Use%20Power%20Query%20Editor%20to%20add%20a%20custom%20column,-To%20start%20creating&text=From%20the%20Home%20tab%20on,The%20Custom%20Column%20window%20appears.). <br />

Information on group by aggregations can be found [here](https://docs.microsoft.com/power-query/group-by#:~:text=Select%20Group%20by%20on%20the,the%20column%20used%20is%20Units).<br />


### What does success look like for Challenge-06?
+ Successfully load parquet data into Azure Synapse
+ Successfully explore Synapse data in Power Bi
+ Successfully generate a report on vaccination rate by postal code

## Next Steps

Click [here](<../Challenge-07 - FHIR service consent capabilities/ReadMe.md>) to proceed to the next challenge.

# Databricks notebook source
# DBTITLE 1,Challenge - Research Azure Data Analytics
# MAGIC %md 
# MAGIC This challange will walk you through using exported and anonymized data for research analytics.  You will explore the effect of gender, race, or age on patients' recieving the Flu shot or not.
# MAGIC In this lesson we will complete the following tasks
# MAGIC * Read in anonymized FHIR json files
# MAGIC * Flatten the data structure to tabular format
# MAGIC * Produce descriptive statistics on the dataset
# MAGIC * Visualize data elements within the dataset
# MAGIC * Perform an ANOVA test on two data elements

# COMMAND ----------

# DBTITLE 1,Prerequisites
# MAGIC %md
# MAGIC If you have not already completed Challenge - Export and Anonymize Data, work through the data export steps and record the Storage Accoun Name, Container Name and Sas Key for the output container.

# COMMAND ----------

# DBTITLE 1,Package Imports
import pandas as pd
from pyspark.sql.types import ArrayType, StructType
from pyspark.sql.functions import explode_outer, col, arrays_zip
import os
from pyspark.sql.functions import pandas_udf, explode, when, concat, lit
import seaborn as sns
import matplotlib.pyplot as plt
import scipy.stats as stats
from scipy.stats import chi2_contingency

# COMMAND ----------

# DBTITLE 1,Step 1: Configure FHIR data import into Databricks to read in anonymized FHIR json files
#Options for mounting the blob storage account to Azure DataBricks
dbutils.widgets.combobox("InputContainerName", "<Container>", ["<Container>"])
dbutils.widgets.combobox("InputFolderName", "<Container>", ["<FolderName>"])
dbutils.widgets.combobox("InputMountPoint", "<MountPoint>", ["<MountPoint>"])
dbutils.widgets.combobox("SasKey", "N/A", ["N/A","<SasKey>"])
dbutils.widgets.combobox("InputStorageAccount",  "<Blob Storage Account>", [ "<Blob Storage Account>"])

def mount_storage(container, storage, mountpoint):
  '''Take a container name and mount point input and mounts the mountpoint to the storageaccount container'''
  configs = {
    "fs.azure.account.auth.type": "CustomAccessToken",
    "fs.azure.account.custom.token.provider.class":   spark.conf.get("spark.databricks.passthrough.adls.gen2.tokenProviderClassName")
  }
 
  #Only mount storage if it not already mounted
  if not any(mount.mountPoint == '/mnt/' + mountpoint for mount in dbutils.fs.mounts()):
    dbutils.fs.mount(
      source = "wasbs://%s@%s.blob.core.windows.net/" % (container, storage),
      mount_point = '/mnt/' + mountpoint,
      extra_configs = {"fs.azure.sas.%s.%s.blob.core.windows.net" % (container, storage) : "%s" % dbutils.widgets.get("SasKey")})
      
 #Mounting the blob storage account to Azure DataBricks
mount_storage(dbutils.widgets.get("InputContainerName"), dbutils.widgets.get("InputStorageAccount"), dbutils.widgets.get("InputMountPoint"))


# COMMAND ----------

# DBTITLE 1,Define tabular dataset conversion
def explode_arrays(dfflat):
  '''Takes a spark dataframe input and explodes the array columns to multiple rows, returns a dataframe'''
  flat_cols = [field.name for field in dfflat.schema.fields if type(field.dataType) != ArrayType]
  cols = [field.name for field in dfflat.schema.fields if type(field.dataType) == ArrayType]
  exploded_df = dfflat.withColumn('vals', explode_outer(arrays_zip(*cols))) \
           .select(*flat_cols,'vals.*') \
           .fillna('', subset=cols)
  return exploded_df

def flatten_structs(nested_df):
  '''Takes a spark dataframe input and flattens the struct columns into multiple columns prefaced with the parent name, returns a dataframe'''
  stack = [((), nested_df)]
  columns = []
  while len(stack) > 0:
      parents, df = stack.pop()
      flat_cols = [col(".".join(parents + (c[0],))).alias("_".join(parents + (c[0],))) for c in df.dtypes if c[1][:6] != "struct"]
      nested_cols = [c[0] for c in df.dtypes if c[1][:6] == "struct" ]
      columns.extend(flat_cols)
      for nested_col in nested_cols:
          projected_df = df.select(nested_col + ".*")
          stack.append((parents + (nested_col,), projected_df))
  return nested_df.select(columns)

# Flatten the struct columns and explode the array columns to fully flatten the dataframe
def flatten_df(dfflat):
  '''Takes a spark data frame input and flattens struct columns into multiple columns and explodes array columns into multiple rows, returns a dataframe'''
  while len([field.name for field in dfflat.schema.fields if type(field.dataType) == StructType or type(field.dataType) == ArrayType ]) !=0 :
    dfflat = flatten_structs(dfflat)
    dfflat = explode_arrays(dfflat)
  
  return dfflat

# COMMAND ----------

# DBTITLE 1,Step 2: Flatten the data structure to tabular format
#Loop through the FHIR source and generate parquet, ddl, or both outputs based on output parameter

try:
  dir = dbutils.fs.ls('mnt/' + dbutils.widgets.get("InputMountPoint"))
  dirdf = pd.DataFrame(dir,columns=['path','name','size'])
  resources = set([name.split("-")[0] for name in dirdf.name])
  print(resources)
  resource_dataframes = {}

  for resource in resources:  
    file_list = []
    for file in dir:
        if(file.name.startswith(resource)):
           file_list.append(file.path)
    df = spark.read.json(path=file_list)
    dfflat = flatten_df(df)
    resource_dataframes[resource] = dfflat
except:  
  #Unmount if fails
  dbutils.fs.unmount(dbutils.widgets.get("InputMountPoint"))
  dbutils.fs.unmount(dbutils.widgets.get("OutputMountPoint"))
  raise

# COMMAND ----------

# DBTITLE 1,Step 3: Produce descriptive statistics on the dataset
#It's important to understand what data is in your dataset before performing a specific analysis task

patient_dataframe = resource_dataframes['Patient']

#Basic descriptive statistics
#patient_dataframe.select('<<column name>>').describe().show()



# COMMAND ----------

#To explore the effect of patient demographics like gender and race on immunization rates, you will need to join datasets. Pay attention to any data transformation necessary to join Patient and Immunization data

#Joining datasets
#Think about the granularity of the two datasets and the resulting granularity of the joined dataset. Are there any aggregations you need to do to have the appropriate granularity for the research question?

patient_dataframe = patient_dataframe.withColumn("Patient_Id", concat(lit("Patient/"),col("id")))
immunization_dataframe = resource_dataframes["Immunization"]
patient_immunization_dataframe = patient_dataframe.join(immunization_dataframe, patient_dataframe["Patient_Id"] == immunization_dataframe["patient_reference"], "left")

#Create a Flu Vaccine Yes/No Column
patient_immunization_dataframe = patient_immunization_dataframe.withColumn("Flu_Yes_No", when(col('vaccineCode_coding_display').like('%Influenza%'), 1).otherwise(0))


# COMMAND ----------

#A group by can give a quick picture of a categorical variables effect on a responsive metric. The sample code below will help with a group by but first you will have to create a column to represent Flu vaccination or not
#Group by aggregations
patient_immunization_dataframe.groupBy("gender").sum("Flu_Yes_No").show(truncate=False)

# COMMAND ----------

# DBTITLE 1,Step 4: Visualize data elements within the dataset
#Visually exploring a dataset can generate additional hypothesises. There are a couple of sample code visualizations below.
#Histogram
patient_immunization_dataframe_pd = patient_immunization_dataframe.select('Flu_Yes_No').toPandas()
patient_immunization_dataframe_pd.hist()


# COMMAND ----------

# DBTITLE 1,Step 5 : Perform a Chi-Square test on two data elements
#A group by can give us a gut check on how a categorical variable effects a binomial response variable. A chi square gives us a statistical answer. Sample code below will get you started exploring the effect of gender or race or age buckets on Flu vaccination rates
patient_immunization_dataframe_chi = patient_immunization_dataframe.toPandas()
patient_immunization_dataframe_chi['gender'] = patient_immunization_dataframe_chi['gender'].astype("category").cat.codes

patient_immunization_dataframe_chi_cross = pd.crosstab(patient_immunization_dataframe_anova['gender'],patient_immunization_dataframe_anova['Flu_Yes_No'], margins = True)

stat, p, dof, expected = chi2_contingency(patient_immunization_dataframe_chi_cross)

# interpret test
alpha = 0.05
print("p value is " + str(p))
if p <= alpha:
    print('Dependent')
else:
    print('Independent')

# COMMAND ----------

# DBTITLE 1,Final: Clean Up
  # Unmount storage account
  dbutils.fs.unmount('/mnt/' + dbutils.widgets.get("InputMountPoint"))

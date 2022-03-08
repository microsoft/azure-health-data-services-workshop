#  Challenge-04 - Query and Search FHIR

## Introduction

Welcome to Challenge-04!

In this challenge, you will learn how to use [FHIR Search](https://www.hl7.org/fhir/search.html) operations to query the Azure API for FHIR database.

## Background
The FHIR specification defines a RESTful interface for querying Resources in a FHIR server's data store. When a client app requests access to Personal Health Information (PHI) on a FHIR server (e.g., on behalf of a patient or care provider), the app sends a query for data within certain parameters, and if the app is permitted access, the server returns the search results. The FHIR standard allows for much flexibility in setting search criteria, and in this challenge we will get practice with the various methods of searching for FHIR Resources in Azure API for FHIR. 

## Learning Objectives for Challenge-04
+ Understand the basic concepts of FHIR Search
+ Perform both Common and Composite Searches 
+ Use Modifiers in Search 
+ Use Chained & Reverse Chained Search 
+ Define a Custom Search parameter 

## Prerequisites
+ Successful completion of Challenge-01
+ Successful completion of Challenge-03 (Patient and other FHIR Resources should be loaded into Azure API for FHIR)
+ In Postman, make sure that you have loaded the `FHIR_Search.postman_collection.json` file from Challenge-01 [located here](https://github.com/microsoft/health-architectures/blob/main/Postman/api-for-fhir/FHIR_Search.postman_collection.json).  

---

## FHIR Search basics 


Each FHIR Resource is defined with specific Search parameters in addition to the [common search parameters](https://www.hl7.org/fhir/search.html#all) that apply to all FHIR Resources.  


See the official FHIR R4 [Search](https://www.hl7.org/fhir/search.html) documentation for more information about searching in REST, messaging, and services.  

+ [Patient Resource Search Parameters](https://www.hl7.org/fhir/patient.html#search)


FHIR searches can be against a specific resource type, a specified compartment, or all resources. The simplest way to execute a search in FHIR is to use a GET request. For example, if you want to pull all patients in the FHIR server database, you could use the following request:

```azurecli
GET {{FHIR_URL}}/Patient
```

You can also search using POST, which is useful if the query string is too long for a single line. To search using POST, the search parameters can be submitted as a form body. This allows for longer, more complex series of query parameters that might be difficult to see and understand in a query string.

If the search request is successful, you’ll receive a FHIR bundle response with a `type: searchset` element at the top. If the search fails, you’ll find the error details in the `OperationOutcome` to help you understand what went wrong.

## Common Search Parameters 
The following parameters apply to all FHIR Resources: ```_content```, ```_id```, ```_lastUpdated```, ```_profile```, ```_query```, ```_security```, ```_source```, ```_tag```.  In addition, the search parameters ```_text``` and ```_filter``` (documented below) also apply to all Resources (as do the search result parameters).

The search parameter ```_id``` refers to the logical id of the Resource and can be used when the search context specifies a Resource type:

```azurecli
 GET {{FHIR_URL}}/Patient?_id=23
```

This search finds the Patient Resource with the given id (there can only be one Resource for a given id). 
  

## Step 1 - Understand the basic concepts of FHIR Search
Using the FHIR Search Postman collection provided, search for Patients using the following: ```_id```, ```name```, and more.

Q: In what field does ```name``` work? What is FHIR matching against?

Azure API for FHIR supports _almost_ all resource-specific search parameters defined by the FHIR specification. The only search parameters not supported are listed here: [FHIR R4 Unsupported Search Parameters](https://github.com/microsoft/fhir-server/blob/main/src/Microsoft.Health.Fhir.Core/Data/R4/unsupported-search-parameters.json).

  
## Step 2 - Perform both Common and Composite Searches 
Composite search allows you to search against value pairs. For example, if you were searching for a height observation where the person was 60 inches, you would want to make sure that a single component of the observation contained the code ```bodyheight``` and the value of `60`. 

Azure API for FHIR supports the following search parameter type pairings:
+ Reference, Token
+ Token, Date
+ Token, Number, Number
+ Token, Quantity
+ Token, String
+ Token, Token

Using the FHIR Search Postman collection provided, search for Patients using the following: ```date```, ```lastmodified```, ```identifier```, ```value-quantity```, ```component-code-value-quantity``` and more.  

Ref: Learn more about date search in FHIR at https://www.hl7.org/fhir/search.html#date. 
  

## Step 3 - Using Search Result Parameters  
Using the FHIR Search Postman collection provided, search for Patients using the following search results parameters: ```_summary=count```, ```_total=accurate```  
  

## Step 4 - Use the Chained & Reverse Chained Search Results Parameters 
Using the FHIR Search Postman collection provided, search for Patients using ```_has```.  For more examples of chained and reverse chained search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.


## Step 5 - Use the Include & Reverse Include Search Results Parameters  
Using the FHIR Search Postman collection provided, search for PractitionerRole including the Practitioner resource in the result to reduce calls to the server. Discover all PractitionerRoles for an Organization using reverse include. For more examples of include and reverse include search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.
  

## Step 6 - Defining a Custom Search parameter 
To create a new search parameter, you need to POST the `SearchParameter` resource to the database. See the FHIR Search Postman collection provided for an example.  Read through the full example at https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/how-to-do-custom-search.

## What does success look like for Challenge-04?

+ Developed a basic understanding of how to perform FHIR search operations in Azure API for FHIR
+ Performed several FHIR search queries using paired/multiple parameters for Common and Composite Search
+ Completed at least one Chained and Reverse Chained FHIR search query
+ Completed at least one Include and Reverse Include FHIR search query

## Next Steps

Click [here](<../Challenge-05 - Export and Anonymize Data/Readme.md>) to proceed to the next challenge.
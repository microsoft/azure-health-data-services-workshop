#  Challenge-04 - Query and Search FHIR

## Introduction

Welcome to Challenge-04!

In this challenge, you will learn how to use [FHIR Search](https://www.hl7.org/fhir/search.html) operations to query the Azure API for FHIR database.

## Background
The FHIR specification defines a REST API with syntax for querying Resources in a FHIR server's data store. When a client app seeks access to FHIR Resources (e.g., on behalf of a patient or care provider), the app querries the FHIR server database for information, and if that information is within the app's permitted access, the server carries out the search and returns the results. The FHIR standard offers a variety of options for fine tuning search criteria, and in this challenge we will get practice with different methods of searching Resources in Azure API for FHIR.   

## Learning Objectives for Challenge-04
+ Understand the basic concepts of FHIR Search
+ Perform both Common and Composite Searches 
+ Use Modifiers in Search 
+ Use Chained & Reverse Chained Search 
+ Define a Custom Search parameter 

## Prerequisites
+ Successful completion of Challenge-01
+ Successful completion of Challenge-03 (`Patient` and other FHIR Resources should be loaded into Azure API for FHIR)
+ In Postman, make sure that you have loaded the `FHIR_Search.postman_collection.json` from Challenge-01 ([located here](https://github.com/microsoft/health-architectures/blob/main/Postman/api-for-fhir/FHIR_Search.postman_collection.json)).  

---

## FHIR Search basics 

At the top level, the FHIR data model is made up of a collection of Resources for structuring information generated in real-world healthcare settings. Resources in FHIR represent the different entities tied to healthcare interactions. There are Resources for the people involved (`Patient`, `Practitioner`, etc.), the events that occur (`Observation`, `Encounter`, `Procedure`, etc.), and many other aspects to do with healthcare scenarios. 

Within every Resource, FHIR defines a set of Elements for storing the details that uniquely identify each Resource *instance*. Elements such as `id` and `meta` apply to all Resources in FHIR, while many other Elements are only used in specific Resources (e.g., the `gender` Element is only found in `Patient`, `Person`, `Practitioner`, and `RelatedPerson` Resources). Furthermore, the FHIR model is designed to allow users to add Elements to Resources through extensions.

Along with Elements, each FHIR Resource is defined with a set of search parameters. When a client app makes FHIR API calls, search parameters enable fine-grained data retrieval from Elements within Resources. There are standard search parameters that apply to all Resources (e.g., `_id`, `_lastUpdated`), and there are Resource-specific search parameters (e.g., `gender` is a Resource-specific search parameter defined for `Patient`). Additionally, FHIR provides a framework for creating custom search parameters. See the links below for more information. 

+ [Standard Search Parameters](https://www.hl7.org/fhir/search.html#all)
+ [Patient Resource-specific Search Parameters](https://www.hl7.org/fhir/patient.html#search) (note that Resource-specific search parameters are always listed at the bottom of the "Content" tab in FHIR R4 Resource documentation)
+ [Defining Custom Search Parameters](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/how-to-do-custom-search)

## FHIR Search methods
When you do a search in FHIR, the starting point for the query can be any of the following:

+ A Resource type
+ A specific Resource instance
+ A specified Resource [Compartment](https://www.hl7.org/fhir/compartmentdefinition.html)
+ All Resources on a FHIR server (e.g., querying against a search parameter shared by all Resources) 

The simplest way to execute a search in FHIR is to send a `GET` request. For example, if you want to pull all Patient Resources in the FHIR server database, you could query for the `Patient` Resource type: 

```azurecli
GET {{FHIR_URL}}/Patient
```

If you want to retrieve the Resource instance for a specific patient, you could narrow your search by adding the `_id` search parameter and the `id` Element value for the Resource: 

```azurecli
GET {{FHIR_URL}}/Patient?_id=123
```

You can also search using `POST`, which is useful if the query string is too long or complex for a single line. To search using `POST`, the search parameters are delivered in JSON format in the body of the request.

If the search request is successful, you’ll receive a FHIR bundle response in JSON with a `"type": "searchset"` entry at the top. If the search fails, you’ll find the error details in the `"OperationOutcome"` part of the response.

## Common Search Parameters 
The following parameters apply to all FHIR Resources: ```_content```, ```_id```, ```_lastUpdated```, ```_profile```, ```_query```, ```_security```, ```_source```, and ```_tag```.  In addition, the search parameters ```_text``` and ```_filter``` also apply to all Resources (as do the [search result parameters](https://www.hl7.org/fhir/search.html#Summary)).

The search parameter ```_id``` refers to the logical id of a Resource instance and can be used when the query specifies a Resource type:

```azurecli
 GET {{FHIR_URL}}/Patient?_id=123
```

This search returns the `Patient` Resource instance with the given `id` (there can only be one Resource for a given `id` on a FHIR server). 
  

## Step 1 - Make FHIR API Calls with Search Parameters
Go to Postman, open the FHIR Search collection provided in Challenge-01, and search for patients using the following parameters: ```_id```, ```name```, and others.

**Q:** _What Element does Azure API for FHIR automatically search against when you assign a value to the_ `name` _parameter in a_ `Patient` _search?_

__Note:__ Azure API for FHIR supports _almost_ all Resource-specific search parameters defined by the FHIR specification. The Resource-specific search parameters that are not supported are listed here: [FHIR R4 Unsupported Search Parameters](https://github.com/microsoft/fhir-server/blob/main/src/Microsoft.Health.Fhir.Core/Data/R4/unsupported-search-parameters.json).

  
## Step 2 - Perform Composite Searches 
In cases where we want to narrow the scope of a query by specifying more than one search parameter, one way of doing this is by using the logical AND (`&`) operator. 

```azurecli
GET {{FHIRURL}}/Patient?_lastUpdated=gt2021-10-01&gender=female
```

In the example above, the query is for Patient Resources that were updated after October 1st, 2021 (`_lastUpdated=gt2021-10-01`) and whose `gender` Element value is `female` (`gender=female`).

This method with `&` works as expected when the queried Elements are all single attributes (e.g., `gender`). But in situations where Resource attributes are defined across *pairs* of Elements, the `&` operator fails to distinguish which Elements are paired together vs which ones should be treated as independent. 

For example, let's imagine we are searching for `Group` Resource instances with `characteristic=gender&value=mixed`. When we see the response, we are surprised to find a `Group` instance with `"characteristic": "gender"` and `"value": "male"` in the results. Taking a closer look, we find this was due to the Resource instance having `"characteristic" : "gender"`, `"value": "male"` *and* `"characteristic": "age"`, `"value": "mixed"`. As it turns out, the `&` operator couldn't dissassociate `"characteristic": "gender"` from `"value": "mixed"`. Hence, the search returned the unexpected result.

Composite search allows you to specify search criteria for value pairs. For example, if you were searching for a height in an `Observation` Resource where the person was 60 inches, you would want to make sure that a single component of the observation contained the code ```bodyheight``` and the value of `60`. 

Azure API for FHIR supports the following search parameter type pairings:
+ Reference, Token
+ Token, Date
+ Token, Number, Number
+ Token, Quantity
+ Token, String
+ Token, Token

Using the FHIR Search Postman collection provided, search for Patients using the following: ```date```, ```lastmodified```, ```identifier```, ```value-quantity```, ```component-code-value-quantity``` and more.  

Learn more about date search in FHIR at https://www.hl7.org/fhir/search.html#date. 
  
## Step 3 - Using Search Result Parameters  
Using the FHIR Search Postman collection provided, search for Patients using the following search results parameters: ```_summary=count```, ```_total=accurate```.  
  

## Step 4 - Use the Chained & Reverse Chained Search Results Parameters 
Using the FHIR Search Postman collection provided, search for Patients using ```_has```.  For more examples of chained and reverse chained search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.


## Step 5 - Use the Include & Reverse Include Search Results Parameters  
Using the FHIR Search Postman collection provided, search for `PractitionerRole` including the `Practitioner` Resource in the result to reduce calls to the server. Discover all `PractitionerRoles` for an Organization using reverse include. For more examples of include and reverse include search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.
  

## Step 6 - Defining a Custom Search parameter 
To create a new search parameter, you need to `POST` the `SearchParameter` Resource to the database. See the FHIR Search Postman collection provided for an example. Read through the full example at https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/how-to-do-custom-search.

## What does success look like for Challenge-04?

+ Developed a basic understanding of how to perform FHIR search operations in Azure API for FHIR
+ Performed several FHIR search queries using paired/multiple parameters for Common and Composite Search
+ Completed at least one Chained and Reverse Chained FHIR search query
+ Completed at least one Include and Reverse Include FHIR search query

## Next Steps

Click [here](<../Challenge-05 - Export and Anonymize Data/Readme.md>) to proceed to the next challenge.
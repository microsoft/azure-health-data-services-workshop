#  Challenge-04 - Query and Search FHIR

## Introduction

Welcome to Challenge-04!

In this challenge, you will learn how to use [FHIR Search](https://www.hl7.org/fhir/search.html) operations to query the FHIR service database.

## Background
The FHIR specification defines a REST API with syntax for querying Resources in a FHIR server's data store. When a client app seeks access to FHIR Resources (e.g., on behalf of a patient or care provider), the app queries the FHIR server, and if the app has the required permissions, the server carries out the search and returns the results in a [FHIR Resource Bundle](http://hl7.org/fhir/bundle.html). The FHIR standard offers a variety of options for fine tuning search criteria, and in this challenge we will get practice with different methods of querying the FHIR service database. 

## Learning Objectives for Challenge-04
+ Understand the basic concepts of FHIR Search
+ Perform both Common and Composite Searches 
+ Use Modifiers in Search 
+ Use Chained & Reverse Chained Search 
+ Define a Custom Search parameter 

## Prerequisites
+ Successful completion of Challenge-01
+ Successful completion of Challenge-03 (`Patient` and other FHIR Resources should be loaded into FHIR service)
+ In Postman, make sure that you have loaded the `FHIR_Search.postman_collection.json` from Challenge-01 ([located here](https://github.com/microsoft/health-architectures/blob/main/Postman/samples/FHIR_Search.postman_collection.json)).  

---

## FHIR Search basics 

At the top level, the FHIR data model is made up of a collection of Resources for structuring information generated in real-world healthcare settings. Resources in FHIR represent the different entities tied to healthcare interactions. There are Resources for the people involved (`Patient`, `Practitioner`, etc.), the events that occur (`Observation`, `Encounter`, `Procedure`, etc.), and many other aspects to do with healthcare scenarios. 

Within every Resource, FHIR defines a set of Elements for storing details that uniquely identify each Resource *instance*. Elements such as `id` and `meta` apply to all Resources in FHIR, while many other Elements are only used in specific Resources (e.g., the `gender` Element is only found in `Patient`, `Person`, `Practitioner`, and `RelatedPerson` Resources). Furthermore, the FHIR model is designed to allow users to add Elements to Resources through extensions.

Along with Elements, each FHIR Resource is defined with a set of search parameters. When a client app makes FHIR API calls, search parameters are used to focus the data retrieved from the FHIR server. There are standard search parameters that apply to all Resources (e.g., `_id`, `_lastUpdated`), and there are Resource-specific search parameters (e.g., `gender` is a Resource-specific search parameter defined for `Patient`). Additionally, FHIR provides a framework for creating custom search parameters. See the links below for more information. 

+ [Standard Search Parameters](https://www.hl7.org/fhir/search.html#all)
+ [Patient Resource-specific Search Parameters](https://www.hl7.org/fhir/patient.html#search) (note that Resource-specific search parameters are always listed at the bottom of the "Content" tab in FHIR R4 Resource documentation)
+ [Defining Custom Search Parameters](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/how-to-do-custom-search)

## FHIR Search methods
When doing a search on a FHIR server, the initial target for the query can be any of the following:

+ A Resource type
+ A specific Resource instance
+ A specified Resource [Compartment](https://www.hl7.org/fhir/compartmentdefinition.html)
+ All Resources on a FHIR server (e.g., querying against a search parameter shared by all Resources) 

The simplest way to execute a search in FHIR is to send a `GET` API request. For example, if you want to pull all `Patient` Resource instances in the FHIR server database, you could query for the `Patient` Resource type. 

```azurecli
GET {{FHIR_URL}}/Patient
```

If you want to retrieve a specific `Patient` Resource instance, you could narrow your search with the `_id` search parameter. 

```azurecli
GET {{FHIR_URL}}/Patient?_id=123
```

You can also call the FHIR search API with `POST`, which is useful if the query string is too long or complex for a single line. To search using `POST`, the search parameters are delivered in JSON format in the body of the request.

Whenever a search request is successful, you’ll receive a JSON FHIR bundle response with a `"type": "searchset"` entry followed by the search results. If the search request fails, you’ll find the error details in the `"OperationOutcome"` part of the response.

## Common Search Parameters 
The following parameters apply to all FHIR Resources: ```_content```, ```_id```, ```_lastUpdated```, ```_profile```, ```_query```, ```_security```, ```_source```, and ```_tag```.  In addition, the search parameters ```_text``` and ```_filter``` also apply to all Resources (as do the [search result parameters](https://www.hl7.org/fhir/search.html#Summary)).

The search parameter ```_id``` refers to the Logical ID of a Resource instance and can be used when the query specifies a Resource type (`Patient` is used as an example):

```azurecli
 GET {{FHIR_URL}}/Patient?_id=123
```

This search returns the `Patient` Resource instance with the given `id` (there can only be one Resource instance for a given Logical ID on a FHIR server). 
  

## Step 1 - Make FHIR API Calls with Search Parameters
1. Go to Postman, open the FHIR Search collection provided in Challenge-01, and search for patients using the following parameters: ```_id```, ```name```, and others.

+ **Q:** _What Element are you searching against when you assign a value to the_ `name` _parameter in a_ `Patient` _search?_

__Note:__ The FHIR service supports most Resource-specific search parameters defined in the FHIR specification. The Resource-specific search parameters that are not supported are listed here: [FHIR R4 Unsupported Search Parameters](https://github.com/microsoft/fhir-server/blob/main/src/Microsoft.Health.Fhir.Core/Data/R4/unsupported-search-parameters.json).

  
## Step 2 - Perform Composite Searches 
In cases where you want to modify the scope of a query by specifying more than one search parameter, one way of doing this is with the logical AND (`&`) operator. 

```azurecli
GET {{FHIRURL}}/Patient?_lastUpdated=gt2021-10-01&gender=female
```

In the example above, the query is for `Patient` Resource instances that were updated after October 1st, 2021 (`_lastUpdated=gt2021-10-01`) *and* whose `gender` Element value is `female` (`gender=female`).

This method with `&` works as expected when the queried Elements are single attributes (e.g., `gender`). But in situations where Resource attributes are defined across *pairs* of Elements, the `&` operator may return incorrect results if it cannot distinguish which Elements are paired together vs which ones are separate from each other. 

As an example, let's imagine we are searching for `Group` Resource instances with `characteristic=gender&value=mixed`. When we inspect the search results, to our surprise we find that the search has returned a `Group` instance with `"characteristic": "gender"` and `"value": "male"`. Taking a closer look, we discover this was due to the `Group` instance having `"characteristic" : "gender"`, `"value": "male"` *and* `"characteristic": "age"`, `"value": "mixed"`. As it turns out, the `&` operator returned a positive match on `"characteristic": "gender"` and `"value": "mixed"` despite these Elements having no connection with each other.

To remedy this shortcoming of the `&` operator, some Resources are defined with composite search parameters, which make it possible to search for Element pairs as logically inter-related units. The example below demonstrates how to perform a composite search for `Group` Resource instances that contain `"characteristic" : "gender"` paired with `"value": "mixed"`. Note the use of the `$` operator to specify the value of the paired search parameter.

```azurecli
GET {{FHIR_URL}}/Group?characteristic-value=gender$mixed
```

For composite searches, FHIR service supports the following data type pairings (the request directly above is an example of a Token, Token pairing):
+ Reference, Token
+ Token, Date
+ Token, Number, Number
+ Token, Quantity
+ Token, String
+ Token, Token

1. Using the FHIR Search collection in Postman, search for `Patient` Resource instances narrowed by the following search parameters: ```date```, ```lastmodified```, ```identifier```, and more. Then, modify the included API calls with the `&` operator to combine different search parameters.

2. In Postman, make an API call with the `GET List Patient Observations by Results Composite` request. Then modify the `http://loinc.org|8462-4` (diastolic blood pressure) value and see if you can get different search results.

To learn more about composite searches in FHIR, please visit [here](https://build.fhir.org/search.html#combining).
  
## Step 3 - Add Search Result Parameters  
FHIR specifies a group of parameters for filtering search results. Below are several examples.

|Parameter| Functionality|
----------|--------------------------------------------------------------------------------------------------------------------
|`_summary`| For returning pre-selected Elements when querying a Resource. For example, searching with the `_summary=true` parameter causes the server to only return Elements marked with `ElementDefinition.isSummary` in their base definition.
|`_total` | For returning the number of Resources that match the given search criteria. For example, `_total=estimate`, `_total=accurate`.
|`_sort`  | For setting the sorting hierarchy of search parameter results. For example, `_sort=status,date,category`.

1. Using the FHIR Search collection in Postman, perform several Patient queries with the following search result parameters: ```_summary=true```, `_summary=count`, ```_total=accurate```, `_sort=gender`.  
  
## Step 4 - Use the Chained & Reverse Chained Search Result Parameters 
Resources in FHIR are equipped with `reference` Elements for capturing relationships between the people, activities, and items associated in real-world healthcare interactions. To create a reference between Resources in FHIR, a `reference` Element in one Resource must be populated with another Resource's [Logical ID](https://www.hl7.org/fhir/resource.html#id), [Business Identifier](https://www.hl7.org/fhir/resource.html#identifiers), or [Canonical URL](https://www.hl7.org/fhir/resource.html#canonical).

Below is an excerpt from a `DiagnosticReport` Resource with a reference to a patient. Notice how `Patient/f201` is referenced as the `subject` of the report.

    {
    ...
    "entry": [
        {
      "fullUrl": "https://example.com/base/DiagnosticReport/f202",
      "resource": {
        "resourceType": "DiagnosticReport",
        "id": "f202"
        ...
        "subject": {
            "reference": "Patient/f201",
            "display": "Roel"
            }
        ...}
    ...}]
    }

In connection with `reference` Elements, Resources also have `reference` search parameters, which serve to query Resources by scoping out any references pointing to other Resources. 

For example, the following request queries a FHIR server for all `DiagnosticReport` instances that reference `Patient/f201`. The `subject` parameter in the request is a `reference` type search parameter.

```azurecli
GET {{fhirurl}}/DiagnosticReport?subject=Patient/f201
```

To simplify using multiple search parameters in a reference-based query, the FHIR standard also specifies syntax for chaining parameters with `.` to refine results. Below is a chained search for all `DiagnosticReport` instances that reference a `subject` (i.e., `Patient`) with the name of `Roel` (note the `:` after `subject`, which makes `Patient` into a [type modifier](https://www.hl7.org/fhir/codesystem-search-modifier-code.html#search-modifier-code-type)).

```azurecli
GET {{fhirurl}}/DiagnosticReport?subject:Patient.name=Roel
```

The FHIR data model's `reference` associations are one-directional, meaning that structurally, references are always from "parent" Resource to "child" Resource (without a reverse reference in the opposite direction). As demonstrated in the chained search above, `Patient` is the "child" with `DiagnosticReport` as the "parent" Resource.

Despite this, the FHIR specification does make room for reverse-chained searching through the `_has` parameter. This makes it possible to search for a "child" Resource as referenced by a "parent" Resource. This is demonstrated in the request below, which searches a FHIR server for any `Patient` with a `DiagnosticReport` containing the code `1234-5`. You can think of this as searching for a `Patient` that has this type of `DiagnosticReport` as its "parent". 

```azurecli
GET {{fhirurl}}/Patient?_has:DiagnosticReport:patient:code=1234-5
```

In the request above, the `patient` search parameter functions as a shortened form of `subject:Patient`.

1. Using the FHIR Search collection in Postman, conduct a reverse-chained search for Patients using the ```_has``` parameter.  For more examples of chained and reverse chained search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.


## Step 5 - Use the Include & Reverse Include Search Result Parameters  
1. Using the FHIR Search collection in Postman, search for `PractitionerRole` including the `Practitioner` Resource in the result to reduce calls to the server. Discover all `PractitionerRoles` for an Organization using reverse include. For more examples of include and reverse include search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/search-samples)** page.
  

## Step 6 - Defining a Custom Search parameter 
1. To create a new search parameter, you need to `POST` the `SearchParameter` Resource to the database. See the FHIR Search Postman collection provided for an example. Read through the full example at https://docs.microsoft.com/en-us/azure/healthcare-apis/azure-api-for-fhir/how-to-do-custom-search.

## What does success look like for Challenge-04?

+ Developed a basic understanding of how to perform FHIR search operations in FHIR service
+ Performed several FHIR search queries using paired/multiple parameters for Common and Composite Search
+ Completed at least one Chained and Reverse Chained FHIR search query
+ Completed at least one Include and Reverse Include FHIR search query

## Next Steps

Click [here](<../Challenge-05 - Export and Anonymize Data/Readme.md>) to proceed to the next challenge.
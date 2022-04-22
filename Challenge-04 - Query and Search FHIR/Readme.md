# Challenge-04 - Query and Search FHIR

## Introduction

Welcome to Challenge-04!

In this challenge, you will learn how to use [FHIR Search](https://www.hl7.org/fhir/search.html) operations to query data in your FHIR service.

## Background

The FHIR specification defines a RESTful API framework with a set of operations for resources either on the **resource instance** level or the **resource type** level. Resource instance interactions are focused on reading or modifying a specific, single resource while resource type interactions are focused on searching for a resource of a type based on some filter criteria.

When a client app is looking for FHIR resources per some filter criteria (e.g., on behalf of a patient or care provider), the app queries the FHIR server, and if the app has the required permissions, the server carries out the search and returns the results in a [FHIR Resource Bundle](http://hl7.org/fhir/bundle.html). The FHIR standard offers a variety of options for fine tuning search criteria, and in this challenge, we will get practice with different methods of querying the FHIR service. 

Think of these FHIR searches in user terms – a doctor may want to find all their patients or all encounters for a specific patient. These queries are focused on finding multiple resources in a single request versus working with a specific resource where the `id` is known.

## Learning Objectives for Challenge-04

By the end of this challenge you will be able to 

+ Explain the basic concepts of FHIR Search
+ Perform both Common and Composite Searches 
+ Use Modifiers in Search 
+ Use Chained & Reverse Chained Search 
+ Define a Custom Search parameter 

## Prerequisites

+ Successful completion of Challenge-01
+ Successful completion of Challenge-03 (`Patient` and other FHIR Resources should be loaded into FHIR service)
+ In Postman, make sure that you have loaded the `FHIR_Search.postman_collection.json` from Challenge-01 ([located here](../resources/docs/samples/FHIR_Search.postman_collection.json)).

---

## FHIR Search basics

At the top level, the FHIR data model is made up of a collection of Resources for structuring information generated in real-world healthcare settings. Resources in FHIR represent the different entities tied to healthcare interactions. There are Resources for the people involved (`Patient`, `Practitioner`, etc.), the events that occur (`Observation`, `Encounter`, `Procedure`, etc.), and many other aspects to do with healthcare scenarios.

Within every Resource, FHIR defines a set of Elements for storing details that uniquely identify each Resource *instance*. Elements such as `id` and `meta` apply to all Resources in FHIR, while other Elements are attached to specific Resources (e.g., the `gender` Element is only found in `Patient`, `Person`, `Practitioner`, and `RelatedPerson` Resources). Furthermore, the FHIR model is designed to allow users to add Elements to Resources through extensions.

Along with Elements, each FHIR Resource is defined with a set of search parameters. When a client app makes FHIR API calls, search parameters are used to focus the data retrieved from the FHIR server. There are standard search parameters that apply to all Resources (e.g., `_id`, `_lastUpdated`), and there are Resource-specific search parameters (e.g., `gender` is a Resource-specific search parameter defined for `Patient`). Additionally, FHIR provides a framework for creating custom search parameters. See the links below for more information. 

+ [Standard Search Parameters](https://www.hl7.org/fhir/search.html#all)
+ [Patient Resource-specific Search Parameters](https://www.hl7.org/fhir/patient.html#search) (note that Resource-specific search parameters are always listed at the bottom of the "Content" tab in FHIR R4 Resource documentation)
+ [Defining Custom Search Parameters](https://docs.microsoft.com/azure/healthcare-apis/fhir/how-to-do-custom-search)

## FHIR Search methods

When doing a search on a FHIR server, the initial target for the query can be any of the following:

+ Resource instance level interaction for a single Resource
+ Resource type level interaction for a set of Resources
+ A specified Resource [Compartment](https://www.hl7.org/fhir/compartmentdefinition.html)
+ Whole system interactions  (e.g., querying against a search parameter shared by all Resources)

The simplest way to execute a search in FHIR is to send a `GET` API request. For example, if you query for the `Patient` Resource with no search parameters specified, you will retrieve all `Patient` Resource instances in the FHIR sirvoci/

```http
GET {{fhirurl}}/Patient
```

If you want to retrieve Patient Resources that were updated last on a certain day, you can narrow your search with the `_lastUpdated` search parameter.

```http
GET {{fhirurl}}/Patient?_lastUpdated=2022-04-21
```

You can also call the FHIR search API with `POST`, which is useful if the query string is too long. To search using `POST`, the search parameters are delivered in JSON format in the body of the request.

Whenever a search request is successful, you’ll receive a FHIR Bundle response as JSON with a `"type": "searchset"` entry followed by the search results. If the search request fails, you’ll find the error details in the `"OperationOutcome"` part of the response.

## Common Search Parameters 

The following parameters apply to all FHIR Resources: ```_content```, ```_id```, ```_lastUpdated```, ```_profile```, ```_query```, ```_security```, ```_source```, and ```_tag```.  In addition, the search parameters ```_text``` and ```_filter``` also apply to all Resources (as do the [search result parameters](https://www.hl7.org/fhir/search.html#Summary)).

The search parameter ```_id``` refers to the [Logical ID](https://www.hl7.org/fhir/resource.html#id) of a Resource instance and can be used when the query specifies a Resource type (`Patient` is used as an example here):

```http
 GET {{fhirurl}}/Patient?_id=123
```

This search returns the `Patient` Resource instance inside a bundle with the given `id` (there can only be one Resource instance for a given Logical ID on a FHIR server).

Compare this to a resource instance query, which uses the RESTful API pattern of putting the resource id in the URL path instead of search query parameters with `_id`. This will return only single Resource as the result versus a single Resource inside of a bundle.

```http
GET {{fhirurl}}/Patient/123
```

## Step 1 - Save Sample Resources

1. Go to Postman, open the FHIR Search collection provided in Challenge-01. There is a request titled "Step 1 - Save Sample Resource Bundle". Send this bundle to your FHIR service using your `fhir` environment you created in Challenge-01. This will save some resources that future requests in this challenge require.

**Note:** Make sure your access token is not expired.

**Note:** The FHIR Search collection has sample requests to demonstrate many different FHIR searches. They aren't always specified by name in these instructions, but they will start with "Step # -" for reference.

## Step 2 - Make FHIR API Calls with Search Parameters

On top of common search parameters, it's possible to add modifiers right after the element name which makes these searches more powerful. Some examples are `:not`, `:exact`, `:contains`, `:gt`, and `:lt`. Take a quick look at the [modifiers section](https://www.hl7.org/fhir/search.html#modifiers) of the official FHIR documentation for more details.

1. Go to Postman, open the FHIR Search collection provided in Challenge-01, and search for patients using the following parameters: ```_id```, ```name```, and others following the examples for Step 2.

+ **Q:** *What Element are you searching against when you assign a value to the* `name` *parameter in a* `Patient` *search?*

**Note:** The FHIR service in Azure Health Data Services supports most Resource-specific search parameters defined in the FHIR specification. The Resource-specific search parameters that are not supported are listed here: [FHIR R4 Unsupported Search Parameters](https://github.com/microsoft/fhir-server/blob/main/src/Microsoft.Health.Fhir.Core/Data/R4/unsupported-search-parameters.json).
  
## Step 3 - Perform Composite Searches

### Overview

In cases where you perform searches with more than one parameter, the most obvious way of doing this is with the logical AND (`&`) operator.

```http
GET {{fhirurl}}/Patient?_lastUpdated=gt2021-10-01&gender=female
```

In the example above, the query is for `Patient` Resources that were updated after October 1st, 2021 (`_lastUpdated=gt2021-10-01`) *and* whose `gender` Element value is `female` (`gender=female`).

This method with `&` works as expected when the queried Elements are single attributes (e.g., `gender`). But in situations where Resource attributes are defined across *pairs* of Elements, the `&` operator may return incorrect results if it cannot distinguish which Elements are paired together vs which ones are separate from each other. 

```http
GET {{fhirurl}}/Group?characteristic=gender&value=mixed
```

In the above example, we are searching for `Group` Resource instances with `characteristic=gender&value=mixed`. When we inspect the search results, to our surprise we find that the search has returned a `Group` instance with `"characteristic": "gender"` and `"value": "male"`. Taking a closer look, we discover this was due to the `Group` instance having `"characteristic" : "gender"`, `"value": "male"` *and* `"characteristic": "age"`, `"value": "mixed"`. As it turns out, the `&` operator returned a positive match on `"characteristic": "gender"` and `"value": "mixed"` despite these Elements having no connection with each other.

To remedy this shortcoming of the `&` operator, some Resources are defined with composite search parameters, which make it possible to search against Element pairs as logically inter-related units. The example below demonstrates how to perform a composite search for `Group` Resource instances that contain `"characteristic" : "gender"` paired with `"value": "mixed"`. Note the use of the `$` operator to specify the value of the paired search parameter.

```http
GET {{fhirurl}}/Group?characteristic-value=gender$mixed
```

For composite searches, FHIR service supports the following parameter type pairings (the request directly above is an example of a Token, Token pairing):

+ Reference, Token
+ Token, Date
+ Token, Number, Number
+ Token, Quantity
+ Token, String
+ Token, Token

### Exercise Task

1. Using the FHIR Search collection in Postman, search for `Patient` Resource instances narrowed by the following search parameters: ```date```, ```lastmodified```, ```identifier```, and more. Then, modify the included API calls with the `&` operator to combine different search parameters.

2. In Postman, make an API call with the `Step 3 -  List Patient Observations by Results Composite` request. Then modify the `http://loinc.org|8462-4` (diastolic blood pressure) value and see if you can get different search results.

To learn more about composite searches in FHIR, please visit [here](https://build.fhir.org/search.html#combining).
  
## Step 4 - Add Search Result Parameters

### Overview

FHIR specifies a set of parameters for filtering search results. Below are several examples.

|Parameter| Functionality|
----------|--------------------------------------------------------------------------------------------------------------------
|`_elements`| For limiting the information returned to a list of Elements. For example, `_elements=identifier,birthdate,language` for a `Patient` Resource.
|`_summary`| For returning pre-selected Elements when querying a Resource. For example, searching with the `_summary=true` parameter causes the server to only return Elements marked with `ElementDefinition.isSummary` in their base definition.
|`_total` | For returning the number of Resources that match the given search criteria. For example, `_total=accurate` returns the exact number of Resources found.
|`_sort`  | For setting the sorting hierarchy of search parameter results. For example, `_sort=status,date,category`.

### Exercise Task

1. Using the FHIR Search collection in Postman, perform several Patient queries with the following search result parameters: ```_summary=true```, `_summary=count`, ```_total=accurate```, `_sort=gender`.  
  
## Step 5 - Use the Chained & Reverse Chained Search Result Parameters

### Overview 

Resources in FHIR are equipped with `reference` Elements for capturing relationships between the people, activities, and items associated in real-world healthcare interactions. To create a reference between Resources in FHIR, a `reference` Element in one Resource must be populated with another Resource's [Logical ID](https://www.hl7.org/fhir/resource.html#id), [Business Identifier](https://www.hl7.org/fhir/resource.html#identifiers), or [Canonical URL](https://www.hl7.org/fhir/resource.html#canonical).

Below is an excerpt from an `Observation` Resource with a reference to a patient. Notice how `Patient/WDT000000002` is referenced as the `subject` of the observation.

```json
{
    "resourceType": "Observation",
    "id": "6e788072-ee1a-483b-8a95-f7f3cc8300a5",
    ...
    "subject": {
        "reference": "Patient/WDT000000002",
        "display": "Ron Stoppable"
    },
    ...
}
```

In connection with `reference` Elements, Resources also have `reference` search parameters, which allow querying Resources by scoping out any references to other Resources.

For example, the following request queries a FHIR server for all `Observations` instances that reference `Patient/WDT000000002`. The `subject` parameter in the request is a `reference` type search parameter.

```http
GET {{fhirurl}}/Observation?subject=Patient/WDT000000002
```

To simplify using multiple search parameters in a reference-based query, FHIR also specifies syntax for chaining parameters with `.` to refine results. Below is a chained search for all `Observation` instances that reference a `subject` (i.e., `Patient`) with the name of `Ron Stoppable` (note the `:` after `subject`, which makes `Patient` into a [type modifier](https://www.hl7.org/fhir/codesystem-search-modifier-code.html#search-modifier-code-type)).

```http
GET {{fhirurl}}/Observation?subject:Patient.name=Ron Stoppable
```

The FHIR data model's `reference` associations are one-directional, meaning that structurally, references are always from "parent" Resource to "child" Resource (without a reference pointing in the opposite direction). As demonstrated in the chained search above, `Patient` is the "child" with `Observation` as the "parent" Resource.

Despite this, the FHIR specification does make room for reverse-chained searching with the `_has` parameter. The `_has` parameter effectively allows searching for a "child" Resource as referenced by a "parent" Resource. This is demonstrated in the reverse-chained search request below, which queries a FHIR server for any `Patient` referenced by a `Observation` containing the code `55284-4`. Note that the `patient` search parameter towards the end functions as a shortened form of `subject:Patient`.

```http
GET {{fhirurl}}/Patient?_has:Observation:patient:code=55284-4
```

### Exercise Task

1. Using the FHIR Search collection in Postman, conduct a reverse-chained search for patients using the ```_has``` parameter. For more examples of chained and reverse chained search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/search-samples)** page.

## Step 6 - Use the Include & Reverse Include Search Result Parameters

### Overview

As discussed in Step 5, a `reference` in FHIR forms a connection from one Resource to another. FHIR enables querying for and traversing `reference` connections in order to narrow search results. In some situations, you may also want to use `reference` associations between Resources to cast a wider net for exploratory searches in a FHIR server's database.

To illustrate, let's imagine you are interested in retrieving all `AllergyIntolerance` instances with a specific code, and you would also like to retrieve all `Patient` instances on the FHIR server that are referenced by this type of `AllergyIntolerance`. You could do this in two searches by first querying with `AllergyIntolerance?_code=` and then searching for referenced `Patient` instances using `_has:AllergyIntolerance:patient:code=`.

But it would be more efficient to retrieve all of this information in a single query. This capability is provided in the `_include` and `_revinclude` parameters. The example below illustrates how `_include` expands the main search (`AllergyIntolerance?_code=`) to return the referenced Resource instances as well (`patient` at the end is short for `subject:Patient`). 

```http
GET {{fhirurl}}/AllergyIntolerance?_code=123456789&_include=AllergyIntolerance:patient
```

Likewise but in the opposite direction, you can use `_revinclude` to retrieve Resources along with other Resources that refer to them. Below is an example where `Patient` instances are retrieved along with `MedicationRequest` instances that reference the `Patient` instances. The `Patient` search is limited to patients who live in the city specified in the `_address-city` parameter.

```http
GET {{fhirurl}}/Patient?_address-city='XXXXXXX'&_revinclude=MedicationRequest:patient:medication.code=1234567
```

**Note:** Because of the potential for "open-ended" searches with `_include` and `_revinclude`, the number of returned results with these search parameters is limited to 100 items on the FHIR service. 

### Exercise Task

1. Using the FHIR Search collection imported into Postman in Challenge-01, search for `PractitionerRole` Resources and include the associated `Practitioner` Resources in the results.

2. Do a search using `_revinclude` to discover all `PractitionerRole` Resources for an Organization. For more examples of searches with the `_include` and `_revinclude` parameters, please see the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/search-samples)** page.

## Step 7 - Defining a Custom Search parameter

At some point, there will be a business use case to search by a search parameter that is not defined in the FHIR service defaults. FHIR allows a way to define your own custom search parameters. 

1. To create a new search parameter, you need to `POST` the `SearchParameter` Resource to the database. See the FHIR Search Postman collection provided for an example. Read through the full example at [https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/how-to-do-custom-search](https://docs.microsoft.com/azure/healthcare-apis/fhir/how-to-do-custom-search).

## What does success look like for Challenge-04?

+ Developed a basic understanding of how to perform FHIR search operations in FHIR service
+ Performed several FHIR search queries using paired/multiple parameters for Common and Composite Search
+ Completed at least one Chained and Reverse Chained FHIR search query
+ Completed at least one Include and Reverse Include FHIR search query

## Next Steps

Click [here](<../Challenge-05 - Export and Anonymize Data/Readme.md>) to proceed to the next challenge.

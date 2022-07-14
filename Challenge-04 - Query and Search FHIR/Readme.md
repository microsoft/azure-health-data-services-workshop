# Challenge-04 - Query and Search FHIR

## Introduction

Welcome to Challenge-04!

In this challenge, you will learn how to use [FHIR Search](https://www.hl7.org/fhir/search.html) operations to query data in your FHIR service.

## Background

The FHIR specification defines a RESTful API framework for accessing Resources stored in a FHIR server database. In real-world use, the most common type of FHIR API interaction would be where a remote client seeks data from a FHIR server. This querying for data on a FHIR server falls under the category of "FHIR Search". The FHIR standard offers a rich set of parameters for fine tuning search criteria, and in this challenge, we will get practice with different methods of querying the [FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/overview) in [Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview). 

Think of these FHIR searches in user terms – a doctor may want to find all encounters for patients with a certain condition. Queries like this are focused on finding Resource instances* per some filter criteria (in this example, `Encounter` instances filtered by their reference to a type of `Condition`). 

> *Note: A Resource instance on a FHIR server has a unique, server-wide Resource `id`. This `id` is also referred to as the Resource instance's [Logical ID](https://www.hl7.org/fhir/resource.html#id). 

## Learning Objectives for Challenge-04

By the end of this challenge you will be able to 

+ explain the basic concepts of FHIR Search
+ perform both Common and Composite searches 
+ use modifiers in FHIR searches 
+ use Chained and Reverse Chained search result parameters
+ use Include and Reverse Include search result parameters
+ use a custom search parameter 

## Prerequisites

+ Successful completion of Challenge-01
+ Successful completion of Challenge-03 (`Patient` and other FHIR Resources should be loaded into your FHIR service)
+ In Postman, make sure that you have loaded the `FHIR_Search.postman_collection.json` from Challenge-01 ([located here](../resources/docs/samples/FHIR_Search.postman_collection.json)).

---

## FHIR Search basics

At the top level, the FHIR data model is made up of a collection of Resources for structuring information generated in real-world healthcare settings. Resources in FHIR represent the different entities tied to healthcare activities. There are Resources for the people involved (`Patient`, `Practitioner`, etc.), the events that occur (`Encounter`, `Observation`, `Procedure`, etc.), and many other aspects to do with healthcare scenarios.

Within every Resource, FHIR defines a set of Elements for storing details that uniquely identify each Resource *instance* on a FHIR server. Elements such as `id` and `meta` apply to all Resource types in FHIR, while other Elements are attached to specific Resource types (e.g., the `gender` Element is only found in `Patient`, `Person`, `Practitioner`, and `RelatedPerson` Resources). Furthermore, the FHIR model is designed to allow users to add Elements to Resources through extensions.

Along with Elements, each FHIR Resource is defined with a set of search parameters. When a remote client app makes a FHIR search API call, search parameters are used to focus the data retrieved from the FHIR server. There are standard search parameters that apply to all Resource types (e.g., `_id`, `_lastUpdated`), and there are search parameters specific to certain Resource types (e.g., `gender` is a search parameter defined for `Patient`). Additionally, FHIR provides a framework for creating custom search parameters. See the links below for more information. 

+ [Standard Search Parameters](https://www.hl7.org/fhir/search.html#all)
+ [Patient Resource-specific Search Parameters](https://www.hl7.org/fhir/patient.html#search) (note that Resource-specific search parameters are always listed at the bottom of the "Content" tab in FHIR R4 Resource documentation)
+ [Defining Custom Search Parameters](https://docs.microsoft.com/azure/healthcare-apis/fhir/how-to-do-custom-search)

## FHIR Search methods

When doing a search on a FHIR server, the initial target for the query can be any of the following:

+ Resource instance level interaction (returned as a single Resource instance)
+ Resource type level interaction for a set of Resource instances (returned as a `Bundle`)
+ A specified [Resource Compartment](https://www.hl7.org/fhir/compartmentdefinition.html)
+ Whole system interactions (e.g., querying against a search parameter shared by all Resources)

The simplest way to execute a search in FHIR is to send a `GET` API request. For example, if you send a request for `Patient` with no `id` or search parameters specified, you will retrieve all `Patient` Resource instances stored in the FHIR server database.

```sh
GET {{fhirurl}}/Patient
```

If you wanted to narrow this search down to `Patient` Resource instances that were last updated on a specific day, you could include the `_lastUpdated` search parameter.

```sh
GET {{fhirurl}}/Patient?_lastUpdated=2022-04-21
```

You can also call the FHIR search API with `POST`, which is useful if the query string is too long or if the query contains Personal Health Information (PHI) that must be concealed. To search using `POST`, the search parameters are put in the body of the request in JSON.

When a search request is successful, if it's a single-instance search (e.g., `GET {{fhirurl}}/Patient/123`), you'll receive a Resource instance in return (formatted in JSON). If it's a request for more than one Resource instance or a query formed with search parameters, you’ll receive a FHIR `Bundle` response containing the search results (also formatted in JSON). If the search request fails, you’ll find the error details in the `"OperationOutcome"` part of the response.

## Common Search Parameters 

The following search parameters are available for all FHIR Resources: ```_content```, ```_id```, ```_lastUpdated```, ```_profile```, ```_query```, ```_security```, ```_source```, and ```_tag```.  Moreover, the ```_text```, ```_filter```, and [search result parameters](https://www.hl7.org/fhir/search.html#Summary) also work with all Resources.

The search parameter ```_id``` is used to specify the [Logical ID](https://www.hl7.org/fhir/resource.html#id) of a Resource instance on a FHIR server.

```sh
 GET {{fhirurl}}/Patient?_id=123
```

This query returns a `Bundle` containing the `Patient` Resource instance with the given `id`.

**Response (excerpt):**
```sh
{
    "resourceType": "Bundle",
    "id": "XXXXXXXXXXXXXXXXXXXXXXXXXX",
    "meta": {
        "lastUpdated": "2022-07-06T13:23:05.1216075+00:00"
    },
    "type": "searchset",
    "link": [
        {
            "relation": "self",
            "url": "https://{{fhirurl}}/Patient?_id=123"
        }
    ],
    "entry": [
        {
            "fullUrl": "https://{{fhirurl}}/Patient/123",
            "resource": {
                "resourceType": "Patient",
                "id": "123"
                }
        }
    ],
...}
```

## Single Resource Instance Search Request

Compare the above to a single Resource instance request, which uses the RESTful API pattern of putting the Resource `id` directly in the URL path (rather than using the `_id` search parameter). With the request below, the Resource instance is returned in response, but not inside a `Bundle`.

```sh
    GET {{fhirurl}}/Patient/123
```

**Response (excerpt):**
```sh
{
    "resourceType": "Patient",
    "id": "123",
    "meta": {
        "versionId": "1",
        "lastUpdated": "2022-05-09T20:53:22.981+00:00",
        "profile": [
            "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient"
        ]
    },
...}
```

## Step 1 - Save Sample Resources
To begin, you are going to populate your FHIR service with some sample FHIR Resources.

### Exercise Task

1. Go to Postman and access the FHIR Search collection provided in Challenge-01. Make sure that the `fhir-service` environment is active and that you have a valid access token (use `POST AuthorizeGetToken` to get a token refresh).  

2. There is a request titled `Step 1 - Save Sample Resource Bundle`. Click on this request, and then click **Send** to deliver the request to your FHIR service. This will save some Resources that future requests in this challenge require.

**Note:** The FHIR Search collection has sample requests to demonstrate many different FHIR searches. They aren't always specified by name in these instructions, but in Postman they will start with "Step # -" for reference.

## Step 2 - Make FHIR API Calls with Search Parameters

On top of common search parameters, it's possible to add modifiers right after a parameter value to sharpen search results. Some example modifiers are `:not`, `:exact`, and `:contains`. Take a quick look at the [modifiers section](https://www.hl7.org/fhir/search.html#modifiers) of the official FHIR documentation to get a sense of how these are used.

### Exercise Task

1. Go to Postman, access the FHIR Search collection provided in Challenge-01, and search for patients using the following parameters: ```_id```, ```name```, and others following the examples for Step 2.

+ **Q:** *What Element(s) are you searching against when you assign a value to the* `name` *parameter in a* `Patient` *search?*

**Note:** The FHIR service in Azure Health Data Services supports most Resource-specific search parameters defined in the FHIR specification. The Resource-specific search parameters that are not supported are listed here: [FHIR R4 Unsupported Search Parameters](https://github.com/microsoft/fhir-server/blob/main/src/Microsoft.Health.Fhir.Core/Data/R4/unsupported-search-parameters.json).
  
## Step 3 - Perform Composite Searches

### Overview

In cases where you perform searches with more than one parameter, the most obvious way of doing this is with the logical AND (`&`) operator.

```sh
GET {{fhirurl}}/Patient?_lastUpdated=gt2021-10-01&gender=female
```

In the example above, the query is for `Patient` Resource instances that were updated after October 1st, 2021 (`_lastUpdated=gt2021-10-01`) *and* whose `gender` Element value is `female` (`gender=female`).

This method with `&` works as expected when the queried Elements are single attributes (e.g., `gender`). But in situations where Resource attributes are defined across *pairs* of Elements, the `&` operator may return incorrect results if it cannot distinguish which Elements are paired together vs which ones are separate from each other. 

```sh
GET {{fhirurl}}/Group?characteristic=gender&value=mixed
```

In the above example, we are searching for `Group` Resource instances with `characteristic=gender&value=mixed`. When we inspect the search results, to our surprise we find that the search has returned a `Group` instance with `"characteristic": "gender"` and `"value": "male"`. Taking a closer look, we discover this was due to the `Group` instance having `"characteristic" : "gender"`, `"value": "male"` *and* `"characteristic": "age"`, `"value": "mixed"`. As it turns out, the `&` operator returned a positive match on `"characteristic": "gender"` and `"value": "mixed"` despite these Elements having no connection with each other.

To remedy this shortcoming of the `&` operator, some Resources are defined with composite search parameters, which make it possible to search against Element pairs as logically inter-related units. The example below demonstrates how to perform a composite search for `Group` Resource instances that contain `"characteristic" : "gender"` paired with `"value": "mixed"`. Note the use of the `$` operator to specify the value of the paired search parameter.

```sh
GET {{fhirurl}}/Group?characteristic-value=gender$mixed
```

For composite searches, FHIR service in Azure Health Data Services supports the following parameter type pairings (the request directly above is an example of a Token, Token pairing):

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
        "display": "Nathan Adunosh"
    },
    ...
}
```

In connection with `reference` Elements, Resources also have `reference` search parameters, which allow querying Resources by scoping out any references to other Resources.

For example, the following request queries a FHIR server for all `Observation` instances that reference `Patient/WDT000000002`. The `subject` parameter in the request is a `reference` type search parameter.

```sh
GET {{fhirurl}}/Observation?subject=Patient/WDT000000002
```

To simplify using multiple search parameters in a reference-based query, FHIR also specifies syntax for chaining parameters with `.` to refine results. Below is a chained search for all `Observation` instances that reference a `subject` (i.e., `Patient`) with the name of `Nathan Adunosh` (note the `:` after `subject`, which makes `Patient` into a [type modifier](https://www.hl7.org/fhir/codesystem-search-modifier-code.html#search-modifier-code-type)).

```sh
GET {{fhirurl}}/Observation?subject:Patient.name=Nathan Adunosh
```

The FHIR data model's `reference` associations are one-directional, meaning that structurally, references are always from "parent" Resource to "child" Resource (without a reference pointing in the opposite direction). As demonstrated in the chained search above, `Patient` is the "child" with `Observation` as the "parent" Resource.

Despite this, the FHIR specification does make room for reverse-chained searching with the `_has` parameter. The `_has` parameter effectively allows searching for a "child" Resource as referenced by a "parent" Resource. This is demonstrated in the reverse-chained search request below, which queries a FHIR server for any `Patient` referenced by an `Observation` containing the code `55284-4`. Note that the `patient` search parameter towards the end functions as a shortened form of `subject:Patient`.

```sh
GET {{fhirurl}}/Patient?_has:Observation:patient:code=55284-4
```

### Exercise Task

1. Using the FHIR Search collection in Postman, conduct a reverse-chained search for patients using the ```_has``` parameter. For more examples of chained and reverse chained search, refer to the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/search-samples)** page.

## Step 6 - Use the Include & Reverse Include Search Result Parameters

### Overview

As discussed in Step 5, a `reference` in FHIR forms a connection from one Resource to another. FHIR enables querying for and traversing `reference` connections in order to narrow search results. In some situations, you may also want to use `reference` associations between Resources to cast a wider net for exploratory searches in a FHIR server's database.

To illustrate, let's imagine you are interested in retrieving all `AllergyIntolerance` instances with a specific code, and you would also like to retrieve all `Patient` instances on the FHIR server that are referenced by this type of `AllergyIntolerance`. You could do this in two searches by first querying with `AllergyIntolerance?_code=` and then searching for referenced `Patient` instances using `_has:AllergyIntolerance:patient:code=`.

But it would be more efficient to retrieve all of this information in a single query. This capability is provided in the `_include` and `_revinclude` parameters. The example below illustrates how `_include` expands the main search (`AllergyIntolerance?_code=`) to return the referenced Resource instances as well (`patient` at the end is short for `subject:Patient`). 

```sh
GET {{fhirurl}}/AllergyIntolerance?_code=123456789&_include=AllergyIntolerance:patient
```

Likewise but in the opposite direction, you can use `_revinclude` to retrieve Resources along with other Resources that refer to them. Below is an example where `Patient` instances are retrieved along with `MedicationRequest` instances that reference the `Patient` instances. The `Patient` search is limited to patients who live in the city specified in the `_address-city` parameter.

```sh
GET {{fhirurl}}/Patient?_address-city='XXXXXXX'&_revinclude=MedicationRequest:patient:medication.code=1234567
```

**Note:** Because of the potential for "open-ended" searches with `_include` and `_revinclude`, the number of returned results with these search parameters is capped to an arbitrary limit on the FHIR service in Azure Health Data Services. 

### Exercise Task

1. Using the FHIR Search collection imported into Postman in Challenge-01, search for `PractitionerRole` Resources and include the associated `Practitioner` Resources in the results.

2. Do a search using `_revinclude` to discover all `PractitionerRole` Resources for an `Organization`. For more examples of searches with the `_include` and `_revinclude` parameters, please see the **[FHIR search examples](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/search-samples)** page.

## Step 7 - Defining a Custom Search Parameter

At some point, you will find a use case where you need to retrieve information that none of the default search parameters in FHIR are cut out for. To address this, FHIR provides a way to define your own custom search parameters for specialized queries.  

### Exercise Task

1. To create a new search parameter, you need to `POST` a `SearchParameter` Resource to the FHIR service database. See the `Create New Search Parameter` call in the FHIR Search Postman collection for an example. When ready, go ahead and run the `Create New Search Parameter` call in Postman.

2. To perform a search using the custom search parameter that you just created, first [follow these instructions](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/how-to-do-custom-search#test-search-parameters) to test the search parameter. Return here when you have finished the process. 

3. Then, you will [run a re-index job](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/how-to-run-a-reindex) on your FHIR service to activate the new search parameter. You can use the `Reindex` call in the FHIR Search collection to accomplish this.

    _Note: Reindexing can take up to several minutes._

4. Once you have tested the new search parameter and re-indexed the FHIR service database, try the `Search by Custom Search Parameter` call in the FHIR Search collection and see what comes back in return.

## What does success look like for Challenge-04?

+ Develop a basic understanding of how to perform FHIR search operations in FHIR service.
+ Perform several FHIR search queries using paired/multiple parameters for Common and Composite Search.
+ Complete at least one Chained and one Reverse Chained FHIR search query.
+ Complete at least one Include and one Reverse Include FHIR search query.
+ Perform at least one query using a custom search parameter.

## Next Steps

Click [here](<../Challenge-05 - Export and Anonymize Data/Readme.md>) to proceed to the next challenge.

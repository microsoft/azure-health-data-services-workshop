# Challenge-02 - Convert HL7v2 and C-CDA to FHIR

## Introduction

Welcome to Challenge-02!

In this challenge, you will learn how to use the FHIR service's custom `$convert-data` operation to convert HL7v2 messages and C-CDA documents into FHIR.

## Background

In today's health industry, the FHIR R4 format has become the standard medium for storage and exchange of health data. As FHIR interoperability spreads throughout the industry, health IT operations are deploying conversion pipelines for ingesting and transforming legacy data formats into FHIR. Two of the most common legacy formats in use are [HL7v2](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=185) and [C-CDA](https://www.healthit.gov/topic/standards-technology/consolidated-cda-overview). In this challenge, we will explore how to convert data from these formats for persistence in FHIR using the Microsoft health data platform.

## Learning Objectives for Challenge-02
By the end of this challenge you will be able to 

+ specify API request parameters for converting data into FHIR
+ prepare/clean data for conversion into FHIR
+ make API calls to convert HL7v2 and C-CDA data into FHIR

## Prerequisites

+ Successful completion of Challenge-01
+ Postman installed and registered in AAD (completed in Challenge-01)
+ A text editor ([Visual Studio Code](https://code.visualstudio.com/) or [7Edit](http://7edit.com/home/) recommended)
+ [VS Code HL7 Language Support](https://marketplace.visualstudio.com/items?itemName=pbrooks.hl7) (optional)

---

## Step 1 - Prepare an API request to convert HL7v2 into FHIR
To convert HL7v2 data into FHIR, first you must prepare a `$convert-data` API request.

1. Go to Postman and create a new API request by clicking **Add request** in the `FHIR CALLS` collection imported in Challenge-01.
<img src="./media/Postman_Add_Request.png" height="328"> 

2. Rename the new request to `Convert Data - HL7`. 
3. Fill in the URL of the request with `{{fhirurl}}/$convert-data`. 
4. Change the HTTP operation from **GET** to **POST**.
<img src="./media/Postman_POST.png" height="328">  

5. Go to the **Authorization** tab of the request and make the following changes:
    + For **Type**, choose **OAuth 2.0**.
    + Add `{{bearerToken}}` below the **Available Tokens** menu.
    + Put `Bearer` in the **Header Prefix** field (if it is not already there).

    ![Request Authorization Tab](./media/request-auth.jpg)
6. Be sure to **Save** the `Convert Data - HL7` request.

## Step 2 - Set up Request Parameters

1.	Review the FHIR service [documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data) for an overview of the ```$convert-data``` operation.  

2. 	Click on [ADT_A01.hl7](./samples/ADT_A01.hl7) to view a sample HL7v2 message (you may want to click on the `Raw` button on the right for ease of viewing). 

3.	Copy and paste the HL7v2 message into the **Body** of the `Convert Data – HL7` request in Postman. Format the JSON request parameters following the example given in the `$convert-data` [documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#sample-request).

4.  In the **Body** tab in Postman, select the **raw** button and choose `JSON` from the dropdown menu on the right.
<img src="./media/Postman_JSON_Body.png" height="328"> 

5.	You will need to make some changes in the HL7v2 payload so that the formatting follows the sample request given in the `$convert-data` [documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data#sample-request). 

    __Hint:__ In the sample request in the documentation (link above), look at how the `\` escape character is used to escape the `\&` in the HL7v2 payload. Also pay attention to the way `\n` newline characters are used. You will need to add at least one `\` escape character and several `\n` newline characters in the HL7v2 message in the `Convert Data - HL7` request. Use this [online tool](https://www.freeformatter.com/json-escape.html) for automatically escaping JSON if you would prefer not to do this manually. 

    *Optional – prepare the JSON request parameters and HL7v2 payload in VS Code (with the HL7 extension installed) first before pasting into the body of the Postman request.

6. Make sure to **Save** the `Convert Data - HL7` request.

## Step 3 - Convert Data

1. In Postman, get a new AAD access token using the `POST AuthorizeGetToken` call.
2. Go to the `Convert Data - HL7` request and press **Send** to initiate the `$convert-data` operation.

After making the `$convert-data` request, you should receive a JSON FHIR `Bundle` response containing the HL7v2 message converted into FHIR R4. The top of the response should be as shown below. 

    {
    "resourceType": "Bundle",
    "type": "batch",
    "timestamp": "2021-11-05T13:13:28",
    "identifier": {
        "value": "TST5150"
    },
    "id": "b6356bc1-0175-b82e-a98c-b094a16d4bb9",
    "entry": [
        {
        "fullUrl": "urn:uuid:cf0a2d6b-21e6-48c0-70a9-2b8ae1f57e70",
        "resource": {
            "resourceType": "MessageHeader",
            "id": "cf0a2d6b-21e6-48c0-70a9-2b8ae1f57e70"
        ...
        }
    }    

> Note: If you get an error, check to make sure that `\` and `\n` characters have been properly added to the HL7v2 payload.

## Step 4 - Prepare a request to convert C-CDA data into FHIR
Now you will make another API request similar to the one above, except this time you will be converting C-CDA data into FHIR.

1. In Postman, click on **Add request** again to create another API request in the `FHIR CALLS` collection imported in Challenge-01. 
<img src="./media/Postman_Add_Request.png" height="328"> 

2. Rename the new request to `Convert Data - CCDA`. 
3. Fill in the URL of the request as before with `{{fhirurl}}/$convert-data`. 
4. Change the HTTP operation from **GET** to **POST**. 
5. Go to the **Authorization** tab of the request and make the following changes:
    + Switch the **Type** to **OAuth 2.0**.
    + Add `{{bearerToken}}` below **Available Tokens**.

    ![Request Authorization Tab](./media/request-auth.jpg)
6. Make sure to **Save** the `Convert Data - CCDA` request.

## Step 5 - Set up Request Parameters

1. Click on [CCDA_Ford_Elaine.xml](./samples/CCDA_Ford_Elaine.xml) to view a sample C-CDA data file (click on `Raw` on the right side to view the entire data string in your browser window).

2. Copy and paste the C-CDA data into VS Code or a text editor of your choice. 

3. Refer back to the FHIR service `$convert-data` [documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/convert-data) on how to arrange the parameters in the JSON body of the request. Be aware that the parameters now need to work for C-CDA data (see the table below). 

    |`"name"` | `"valueString"`|
    |-------|---------------|
    |`"inputDataType"` | `"Ccda"` |
    |`"templateCollectionReference"` | `"microsofthealth/ccdatemplates:default"` |
    |`"rootTemplate"` | `"CCD"` |


4. You will need to format the C-CDA data payload so that it sits correctly in the JSON request body.

    __Hint:__ The JSON spec requires all keys and values to be surrounded by double quotes. Any double quotes *within* the JSON data payload must be `\` escaped, however. Look at the `"` quotation marks in the C-CDA data string. These `"` quotes all need to be `\` escaped in order for the `$convert-data` request to work. This [online tool](https://www.freeformatter.com/json-escape.html) is helpful for adding `\` escape characters to JSON where needed. Alternatively, you could use a text editor and do a "find and replace". Whatever method works best for you is fine.

5. When ready, copy and paste the JSON-formatted request parameters with the C-CDA payload into the **Body** of the `Convert Data - CCDA` request in Postman.

6. Select the **raw** button and choose `JSON` from the dropdown menu on the right.

7. Make sure to **Save** the `Convert Data - CCDA` request.

## Step 6 - Convert Data

1. Get a new access token from AAD with `POST AuthorizeGetToken` (this is not strictly necessary unless it has been over 60 minutes since the last access token was issued).
2. Go to the `Convert Data - CCDA` request and press **Send**.

After making the `$convert-data` request, you should receive a FHIR `Bundle` response containing the C-CDA data converted into FHIR R4. The top of the response will be as shown below. 

    {
    "resourceType": "Bundle",
    "type": "batch",
    "entry": [
        {
        "fullUrl": "urn:uuid:0990ecf3-327d-4194-1aae-00724d4cba22",
        "resource": {
            "resourceType": "Composition",
            "id": "0990ecf3-327d-4194-1aae-00724d4cba22",
            "identifier": {
            "use": "official",
            "value": "2.16.840.1.113883.19.5.99999.1"
            },
            ...}
        ...}
    ...}

> Note: If you get an error, check that the `""` characters are properly escaped in the C-CDA payload.

## What does success look like for Challenge-02?

+ A FHIR `"resourceType": "Bundle"` response after calling ```$convert-data``` with an HL7v2 payload
+ A FHIR `"resourceType": "Bundle"` response after calling ```$convert-data``` with a C-CDA payload

## Some additional resources ##

[Caristix HL7v2 ADT_A01 Reference](https://hl7-definition.caristix.com/v2/HL7v2.6/TriggerEvents/ADT_A01)  
[HL7v2 main page](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=185)  
[Consolidated-Clinical Documentation Architecture page](https://www.healthit.gov/topic/standards-technology/consolidated-cda-overview)  

## Next Steps

Click [here](<../Challenge-03 - Ingest to FHIR/Readme.md>) to proceed to Challenge-03.

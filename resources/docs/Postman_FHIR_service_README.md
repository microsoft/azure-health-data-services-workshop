# Postman setup + sample Postman environments and collections 

## Overview 
When testing data connectivity between [FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/overview) and a remote client app, it is useful to have an API testing utility to send requests, view responses, and debug issues. One of the most popular API testing tools is [Postman](https://www.postman.com/), and in this guide we provide instructions plus a set of sample data files to help you get started with Postman as a testing platform for FHIR service in [Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/healthcare-apis-overview).

## Prerequisites
+ [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) role in your Azure Subscription
+ [Application Administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#all-roles) role in your Azure Active Directory (AAD) tenant
+ **FHIR service** deployed. To deploy FHIR service (PaaS), we recommend using the [FHIR-Starter Quickstart ARM template](https://github.com/microsoft/fhir-starter/tree/main/quickstarts), which allows you to deploy [FHIR service](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/overview), [FHIR-Proxy](https://github.com/microsoft/fhir-proxy), and [FHIR-Bulk Loader](https://github.com/microsoft/fhir-loader) all in one pass.
+ **FHIR-Proxy** deployed and set up with AAD authentication and app roles for connecting to FHIR service. To learn more about FHIR-Proxy (OSS), please visit [here](https://github.com/microsoft/fhir-proxy). For information about setting up FHIR Proxy AAD authentication and app roles, please see [here](https://github.com/microsoft/fhir-starter/tree/main/quickstarts) (Steps 2 and 3 - midway through page).
+ **Postman** installed - desktop or web client. Information about installing Postman is available [here](https://www.getpostman.com/). 

## Getting started
To set up Postman for testing FHIR service, we'll walk through these steps:

**Step 1:** Create an App Registration for Postman in AAD  
**Step 2:** Assign Azure RBAC roles for Postman  
**Step 3:** Import an environment template and collection files into Postman  
**Step 4:** Enter parameter values for two Postman environments: 
1. One for making API calls directly to FHIR service  
2. Another for making API calls via FHIR-Proxy to FHIR service 
**Step 5:** Get an authorization token from AAD  
**Step 6:** Test FHIR service with Postman

## Step 1 - Create an App Registration for Postman in AAD 

Before you can use Postman to make API calls to FHIR service, you will need to create a registered [client application](https://docs.microsoft.com/en-us/azure/healthcare-apis/register-application) to represent Postman in Azure Active Directory.

1. In Azure Portal, go to **Azure Active Directory** -> **App registrations** and click **New registration**. 
<img src="./docs/images/Screenshot_2022-02-11_065619_edit2.png" height="328">

2. Type in a name for your Postman client app in the **Name** field. 
<img src="./docs/images/Screenshot_2022-02-15_141049_edit2.png" height="328">

3. Scroll down, and under **Redirect URI (optional)**, select **Web** and then enter https://www.getpostman.com/oauth2/callback. Click **Register**. 
<img src="./docs/images/Screenshot_2022-02-15_141049_edit2_next.png" height="328"> 

4. Now you will be taken to the **Overview** blade for your Postman client app in AAD.  
<img src="./docs/images/Screenshot_2022-02-15_141337_edit2.png" height="328">  

5. Click on **API Permissions** and then click on **+Add a permission**.  
<img src="./docs/images/Screenshot_2022-02-15_141418_edit2.png" height="328">

6. Select the **My APIs** tab and you will see a list containing the FHIR-Proxy instance that you deployed and registered earlier (see the Prerequisites section). Click on the FHIR-Proxy app name.
<img src="./docs/images/Screenshot_2022-02-15_141517_edit2.png" height="328">

7. Under **Request API permissions**, click on **Delegated permissions**. 
<img src="./docs/images/Screenshot_2022-02-15_141624_edit2.png" height="328">

8. Scroll down and select **user_impersonation**. Then click **Add permissions**. 
<img src="./docs/images/Screenshot_2022-02-15_141706_edit2.png" height="328">

9. When back in the **API permissions** blade, make sure to click **Grant admin consent** (blue checkmark). 
<img src="./docs/images/Screenshot_2022-02-15_141810_edit2.png" height="328">  
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2.png" height="328">  

10. Now, in the **API permissions** blade, click on **+Add a permission** (again). 

11. Select the **My APIs** tab (again). Click on the FHIR-Proxy app name.
<img src="./docs/images/Screenshot_2022-02-15_141517_edit2.png" height="328">

12. Under **Request API permissions**, click on the **Application permissions** box on the right. 
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2_next.png" height="328">

13. Select **Resource Reader** and **Resource Writer**. Click **Add permissions**. 
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2_next2a.png" height="328">

14. When back in the **API permissions** blade, make sure to click **Grant admin consent** again (blue checkmark).
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2_next3b.png" height="328">

15. Now, in the **API permissions** blade, click **+Add a permission** (again). 

16. Under **Request API permissions**, select the **APIs my organization uses** tab. Type in "Azure Healthcare APIs" and select the item in the list. 
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2_next4.png" height="328">

17. Scroll down and select **user_impersonation**. Then click **Add permissions**. 
<img src="./docs/images/Screenshot_2022-02-15_141828_edit2_next5.png" height="328">

18. When back in the **API permissions** blade, make sure to click **Grant admin consent** again (blue checkmark). 

19. Now click on **Certificates and secrets**. Click **+New client secret**. 
<img src="./docs/images/Screenshot_2022-02-15_141926_edit2.png" height="328">

20. Under **Add a client secret**, enter a name for the secret in the **Description** field. Click **Add**. 
<img src="./docs/images/Screenshot_2022-02-15_142102_edit2.png" height="328">

21. Copy the secret **Value** and securely store it somewhere (you will need this when you configure your Postman environment). 
<img src="./docs/images/Screenshot_2022-02-15_142159_edit2.png" height="328">

For more information on registering client applications in AAD for Azure Health Data Services, please see the [Authentication and Authorization for Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/authentication-authorization) documentation. 

## Step 2 - Assign Azure RBAC roles for Postman

1. In Azure Portal, go to **Home** -> **Resource groups** and find the resource group containing your FHIR service instance. When in the resource group **Overview**, click on your FHIR service app name in the list. 
<img src="./docs/images/Screenshot_2022-02-15_142434_edit2.png" height="328">

2. Go to the **Access Control (IAM)** blade. Click on the **Roles** tab.
<img src="./docs/images/Screenshot_2022-02-15_142519_edit2_next.png" height="328">

3. Click on **+Add** -> **Add role assignment**. 
<img src="./docs/images/Screenshot_2022-02-15_142726_edit2.png" height="328">

4. In **Add role assignment** under the **Role** tab, scroll down in the list and select **FHIR Data Contributor**. Then click **Next**. 
<img src="./docs/images/Screenshot_2022-02-15_143124_edit2.png" height="328">

5. Under the **Members** tab, click on **+Select members**. Type in the name of your Postman client app in the **Select** field on the right. Highlight the name and click **Select**. Then click **Next**. 
<img src="./docs/images/Screenshot_2022-02-15_143459_edit2.png" height="328">

6. Under the **Review + assign** tab, click **Review + assign**. 
<img src="./docs/images/Screenshot_2022-02-15_143643_edit2.png" height="328">

7. When back in the **Access Control (IAM)** blade, click **+Add** -> **Add role assignment** (again). 
<img src="./docs/images/Screenshot_2022-02-15_143643_edit2_next.png" height="328">

8. In **Add role assignment** under the **Role** tab, select **FHIR Data Contributor** (again) and click **Next**. 
<img src="./docs/images/Screenshot_2022-02-15_143643_edit2_next2.png" height="328">

9. Under the **Members** tab, click on **+Select members**. Type in your name or username in the **Select** field on the right. Highlight your name, click **Select**, and then click **Next**. 
<img src="./docs/images/Screenshot_2022-02-15_144144_edit2.png" height="328">

10. Under the **Review + assign** tab, click **Review + assign**. 
<img src="./docs/images/Screenshot_2022-02-15_144245_edit2.png" height="328">

11. Now go to **Azure Active Directory** -> **Enterprise applications**. Search for your FHIR-Proxy function app name and click on it in the list. It might be easiest to search by the **Created on** date. 
<img src="./docs/images/Screenshot_2022-02-15_144433_edit2.png" height="328">

12. You will be taken to the FHIR-Proxy **Overview** blade in Enterprise Applications. Click on **Users and groups**. 
<img src="./docs/images/Screenshot_2022-02-15_144621_edit2.png" height="328">

13. Click on **+Add user/group**. 
<img src="./docs/images/Screenshot_2022-02-15_151041_edit2.png" height="328">

14. In **Add Assignment**, on the left under **Users**, click **None Selected**. Then under **Users** on the right side, type in your name or username in the search field. Click on your name, and then click **Select**. 
<img src="./docs/images/Screenshot_2022-02-15_151408_edit2.png" height="328">

15. In **Add Assignment**, under **Select a role**, click **None Selected**. On the right side, click on **Resource Writer** and then click **Select**. 
<img src="./docs/images/Screenshot_2022-02-15_151625_edit2.png" height="328">

16. Back in **Add Assignment**, click **Assign**. 
<img src="./docs/images/Screenshot_2022-02-15_151738_edit2.png" height="328">

For more information on assigning user/app roles, see [Configure Azure RBAC for Azure Health Data Services](https://docs.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac).

## Step 3 - Import environment and collection files into Postman

1. Access the Postman environment template for Azure API for FHIR [here](./api-for-fhir/api-for-fhir.postman_environment.json). Save the file locally (click on `Raw` and then do a **Save as** from your browser). 

2. Access the Postman environment template for FHIR-Proxy [here](./samples/fhir-proxy.postman_environment.json). Save the file locally (click on `Raw` and then do a **Save as** from your browser).

3. In Postman, create a new Workspace (or select an existing one if already created).

4. Click the ```Import``` button next to the workspace name. 
<img src="./docs/images/Screenshot_2022-02-16_095332_edit2.png" height="228">

5. Import the ```api-for-fhir.postman_environment.json``` file that you just saved locally.
    + Add the file to Postman using the ```Upload Files``` button. Then click `Import`. 
<img src="./docs/images/Screenshot_2022-02-16_095516_edit2.png" height="228">

6. Import the ```fhir-proxy.postman_environment.json``` file that you just saved locally.
    + Add the file to Postman using the ```Upload Files``` button. Then click `Import`. 
<img src="./docs/images/Screenshot_2022-02-16_095625_edit2.png" height="228">

7. Access the ```FHIR-CALLS.postman-collection.json``` file available in this repo [here](./samples/FHIR-CALLS.postman_collection.json) and save the file locally. Then import the file into Postman.
    + Add the file to Postman using the ```Upload Files``` button. Then click `Import`. 
<img src="./docs/images/Screenshot_2022-02-16_104345_edit2.png" height="228">

8. Access the ```FHIR_Search.postman_collection.json``` file available in this repo [here](./samples/FHIR_Search.postman_collection.json) and save the file locally. Then import the file into Postman.
    + Add the file to Postman using the ```Upload Files``` button. Then click `Import`. 
<img src="./docs/images/Screenshot_2022-02-16_104427_edit2.png" height="228">

 
## Step 4 - Configure Postman environments
Now you will configure your two Postman environments (`api-fhir` and `fhir-proxy`). 

1. For the `api-fhir` Postman environment, you will need to retrieve the following values: 

- `tenantId` - AAD tenant ID (go to **AAD** -> **Overview** -> **Tenant ID**)
- `clientId` - Application (client) ID for Postman client app (go to **AAD** -> **App registrations** -> **Name** -> **Overview** -> **Application (client) ID**) 
- `clientSecret` - Client secret stored for Postman (see Step 1 #21 above) 
- `fhirurl` - Azure API for FHIR endpoint - e.g. `https://<azure_api_for_fhir_app_name>.azurehealthcareapis.com` (go to **Resource Group** -> **Overview** -> **Name** -> **FHIR metadata endpoint** and copy *without* "/metadata" on the end)
- `resource` - Azure API for FHIR endpoint - e.g. `https://<azure_api_for_fhir_app_name>.azurehealthcareapis.com` (same as `fhirurl`)

Populate the above parameter values in your `api-fhir` Postman environment as shown below. Leave `bearerToken` blank. Make sure to click `Save` to retain the `api-fhir` environment values.  

<img src="./docs/images/Screenshot_2022-02-16_104920_edit2.png" height="328">

2. For the `fhir-proxy` Postman environment, you will need to retrieve the following values: 

- `tenantId` - AAD tenant ID (go to **AAD** -> **Overview** -> **Tenant ID**) 
- `clientId` - Application (client) ID for Postman client app (go to **AAD** -> **App registrations** -> **Name** -> **Overview** -> **Application (client) ID**) 
- `clientSecret` - Client secret stored for Postman (see Step 1 number 21 above) 
- `resource` - Application (client) ID in the AAD client app for FHIR-Proxy (go to **AAD** -> **App registrations** -> **Name** -> **Overview** -> **Application (client) ID**) 
- `fhirurl` - FHIR-Proxy endpoint appended with `/fhir` - e.g. `https://<fhir_proxy_app_name>.azurewebsites.net/fhir` (go to **Resource Group** -> **Overview** -> **Name** -> **URL**; make sure to append `/fhir` on the end when inputting into the Postman environment)


Populate the above parameter values in your `fhir-proxy` Postman environment as shown below. Leave `bearerToken` blank. Make sure to click `Save` to retain the `fhir-proxy` environment values.  

<img src="./docs/images/Screenshot_2022-02-16_105208_edit2.png" height="328">

## Step 5 - Get an access token from AAD
In order to connect to FHIR service, you will need to get an access token first. To obtain an access token from AAD via Postman, you can send a ```POST AuthorizeGetToken``` request. The ```POST AuthorizeGetToken``` call comes pre-configured as part of the `FHIR CALLS` collection that you imported earlier. 

In Postman, click on `Collections` on the left, select the `FHIR CALLS` collection, and then select `POST AuthorizeGetToken`. Press `Send` on the right.

__Important:__ Be sure to make the `fhir-proxy` environment active by selecting from the dropdown menu above the `Send` button. In the image below, `fhir-proxy` is shown as the active environment.

<img src="./docs/images/Screenshot_2022-02-16_171631_edit2.png" height="328">

On clicking ```Send```, you should receive a response in the **Body** tab like shown below. The `access_token` value is automatically saved to the ```bearerToken``` variable in the Postman environment. 

```
{
    "token_type": "Bearer",
    "expires_in": "3599",
    "ext_expires_in": "3599",
    "expires_on": "XXXXXXXXXX",
    "not_before": "XXXXXXXXXX",
    "resource": "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
    "access_token": "XXXXXXXXXXXX..."
}
```

You now have a valid access token in your Postman environment and can use the token in subsequent API calls to FHIR service - passing through FHIR-Proxy on the way in. For more information about access tokens in AAD, see [Microsoft identity platform access tokens](https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens).

__Note:__ Access tokens expire after 60 minutes. To obtain a token refresh, simply make another ```POST AuthorizeGetToken``` call and you will receive a new token valid for another 60 minutes.

## Step 6 - Test FHIR service with Postman 

1. In Postman, click on `Collections` on the left, select the `FHIR CALLS` collection, and then select the `GET List Metadata` call. Your Postman interface should look something like this: 

<img src="./docs/images/Screenshot_2022-02-17_101024_edit2.png" height="328">

2. Click `Send` to test that FHIR service and FHIR-Proxy are functioning on a basic level. The `GET List Metadata` call returns the FHIR service server's Capability Statement. If you receive an error, there should be information in the response indicating the cause of the error. If you receive a response like shown below, this means your setup has passed the first test. 

<img src="./docs/images/Screenshot_2022-02-17_101116_edit2.png" height="328">

3. Click on `POST Save Patient` in the `FHIR CALLS` collection and press `Send`. If you get a response like shown below, this means you succeeded in populating FHIR service with a Patient Resource. This indicates that your setup is functioning properly. 

<img src="./docs/images/Screenshot_2022-02-17_101224_edit2.png" height="328">

4. Try `GET List Patients` in the `FHIR CALLS` collection and press `Send`. If the response is as shown below, this means you successfully queried FHIR service for a list of every Patient Resource stored on the FHIR server. This means your setup is fully functional.

<img src="./docs/images/Screenshot_2022-02-17_101255_edit2.png" height="328">

5. Now you can experiment with other sample calls or your own FHIR API calls.

### Resources 

A tutorial for using Postman with FHIR service is available on [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/use-postman).
 
### FAQ's / Issues 

403 - Unauthorized:  Check the Azure RBAC for FHIR service ([link](https://docs.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac)).

  

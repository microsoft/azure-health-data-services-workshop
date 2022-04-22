
# Challenge-10 - FhirBlaze (Blazor app dev + FHIR)

## Introduction

Welcome to Challenge-10!

In this challenge, you will practice setting up a user-facing remote application to interact with FHIR data on the FHIR service.

## Background

With health data systems built on the FHIR standard API, organizations can use the FHIR data model as the basis for developing custom applications to meet their unique needs. In this challenge, we will work with a simple [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) frontend app called FhirBlaze as a starter application to connect to your FHIR service. FhirBlaze is a bare-bones app that enables end users to create or delete certain Resources on the FHIR service. The ability to send create and delete requests is a fundamental building block for more sophisticated use cases. We will be using the [Firely](https://fire.ly/) SDK inside of FhirBlaze to represent the FHIR object model in [.NET](https://dotnet.microsoft.com/).

## Learning Objectives for Challenge-10

By the end of this challenge you will be able to 

+ Use FHIR Resources like Patient, Practitioner, and more for real world applications
+ Use Firely SDK to accelerate FHIR application development
+ Use Blazor for web development

## Prerequisites

+ [Visual Studio](https://visualstudio.microsoft.com/) or [Visual Studio Code](https://code.visualstudio.com/) installed on your local machine. The instructions are written for Visual Studio so you will have to map the equivalent in Visual Studio Code yourself.
+ Working FHIR service instance (deployed in Challenge-01)

## Step 1 – Configure service and client application

1. Change the CORS configuration of FHIR service as per the first screenshot in [this documentation](https://docs.microsoft.com/azure/healthcare-apis/fhir/configure-cross-origin-resource-sharing).
 
2.Ensure your personal Azure Active Directory user account has the **FHIR Data Contributor** role assigned for your FHIR service.

3. In the Azure AD, **App Registration** for the **Postman** application, under **Authentication**, **Add a platform** of type **Single-page application** with redirect URI set to `https://localhost:44321/authentication/login-callback`. 
 
4. In your same **Postman App Registration**, under **API Permissions**, click **Add a permission**. If you do not see the `user_impersonation` permission for Azure Healthcare APIs, follow the instructions in the line below.
    + Go to the **APIs my organization uses** tab and find **Azure Healthcare APIs**. Add the `user_impersonation` permission.

## Step 2 – Introduction to FhirBlaze base solution

We created FhirBlaze as a sample you can use to accelerate your own web application development on top of the FHIR service. It lays the foundation for sending read and write requests to the FHIR service, allowing you to focus on developing the workflow needed for your own application.

1. Clone or download the FhirBlaze solution from [here]( https://github.com/microsoft/FhirBlaze)

2. Open FhirBlaze in **Visual Studio**.

A quick tour of FhirBlaze:

+ FhirBlaze is a web application - specifically a Blazor Web Assembly project.
+ Blazor applications allow you to run .NET instead of (or in addition to) JavaScript or TypeScript.
  + Blazor Web Assembly is an application that runs on the user’s client machine and manages the user authentication.
+ The other projects in the solution are suffixed with the name "Module". We implemented a form of a micro-frontend pattern that encourages independent and parallel development.

## Step 3 – Setup FhirBlaze for your FHIR Service

1. In **Solution Explorer** , right-click the **FhirBlaze** project, and select **Select as Startup Project**.

2. Configure the FhirBlaze application to point to your FHIR API.
    + Blazor application settings are stored in an `appsettings.json` file.

3. In **Solution Explorer**, expand the **FhirBlaze** project, expand the **wwwroot** folder, and open **appsettings.json**.

4. Modify the **Authority** and **ClientId** values to match your FHIR service instance. For example:

    ```json
    {
        "AzureAd": {
            "Authority": "https://login.microsoftonline.com/[your tenant id]",
            "ClientId": "[your Client ID]",
            "ValidateAuthority": true
        },
        ...
    ```

5. Modify the **Scope** and **FhirServerUri** values to match your FHIR service instance.

    ```json
    {
        ...
        "FhirConnection": {
            "Scope": "[your fhir server here]/user_impersonation",
            "FhirServerUri": "[your fhir server here]",
            "Authority": "https://login.microsoftonline.com"
          }, 
    ...
    ```
  
6. If you want to see where the application reads these values from the `appsettings.json` file:

    + Look in the Program.cs file
    + Build and run FhirBlaze (the debug button is the easiest way)
    + Log in with your Azure Active Directory account
      + *The navigation menu items in the left-hand pane are some of the core entities we’ve already developed.*
    + Click on any navigation menu items in the left-hand pane (e.g. Patients or Practitioners)
    + Stop running FhirBlaze

**Note:** FhirBlaze out of the box is set up to interact with the Patient, Practitioner, and Questionnaire FHIR Resources. As you build solutions, you will likely need to add Resource types.

## Step 3 – Create a new module

Let's see how to add a new module. This will add a new FHIR Resource type that we can create or delete using FhirBlaze.

1. Select a resource from [FHIR.org](https://www.hl7.org/fhir/resourcelist.html) that is not already included as a module in the FhirBlaze solution. Choose one that you have data for in your FHIR service.

2. In **Solution Explorer**, right-click the **FhirBlaze** solution, select **Add**, and then select **New Project**.

3. In the **Add a new project** dialog, set the language filter to **C#**, and then select **Class Library** (or **Library** depending on your Visual Studio version) in the list of project templates.
    + *Be sure it is a C# Class Library or .NET Standard Library and doesn’t say Universal Windows or .NET Framework behind Class Library.*

4. Click the **Next** button.

5. In the **Project Name** text box, enter **FhirBlaze.[name of your selected FHIR resource]Module**.

6. Click the **Next** button.

7. Confirm **.NET 5.0** or **.NET Standard 2.1** is selected and click the **Create** button.

8. Right-click the **FhirBlaze** project, select **Add**, and then select **Project Reference**.

9. Select the name of the module you just added to the solution.

10. In **Solution Explorer**, open **App.razor** in the FhirBlaze project and add your new module to the list of assemblies.

    ```c#
    @code {
        private IList<Assembly> AdditionalAssemblies = new[]
        {
            typeof(FhirBlaze.PatientModule.PatientList).Assembly,
            typeof(FhirBlaze.PractitionerModule.Pages.PractitionerList).Assembly, 
            // add the type of your new project here! This will show as an error until you create the proper page in the next step.
            typeof(FhirBlaze.QuestionnaireModule.Pages.QuestionnaireList).Assembly
        };
    }
    ```

    + *Adding your assembly here means the assembly will lazy-load – or only load when it’s needed. By lazy-loading assemblies, we keep the application size smaller for end users that may only use a small number of our application’s pages.*

11. Now let's add the code to the UI.

12. In **Solution Explorer**, expand the **Shared** folder, and open **NavMenu.razor**.

13. Highlight and copy the last of the list items and paste it within the unordered list.

14. Change the **NavLink** element’s **href** property to the plural name of your selected FHIR resource (e.g. Practitioners).

15. Change the text after the `<span>` element to the plural name of your FHIR resource. (e.g. Practitioners).

16. Change the below 

    ```html
    <div class="@NavMenuCssClass" @onclick="ToggleNavMenu">
        <ul class="nav flex-column">
            <li class="nav-item px-3">
                <NavLink class="nav-link" href="" Match="NavLinkMatch.All">
                    <span class="oi oi-home" aria-hidden="true"></span> Home
                </NavLink>
            </li>
            <li class="nav-item px-3">
                <NavLink class="nav-link" href="questionnaire">
                    <span class="oi oi-question-mark" aria-hidden="true"></span>Questionnaires
                </NavLink>
            </li>
            <li class="nav-item px-3">
                <NavLink class="nav-link" href="patient">
                    <span class="oi oi-person" aria-hidden="true"></span>Patients
                </NavLink>
            </li>
            <li class="nav-item px-3">
                <NavLink class="nav-link" href="practitioners">
                    <span class="oi oi-person" aria-hidden="true"></span>Practitioners
                </NavLink>
            </li>
            <!-- Insert your nav menu item here -->
        </ul>
    </div>
    ```

17. You have now set up the front end of the application for the new FHIR Resource. Our last step is to set up the backend to interact with the FHIR service.

## Step 4 – Implement the code to get, create, edit, and delete a FHIR Resource

1. In **Solution Explorer**, expand the **FhirBlaze.PractitionerModule** project.

2. Copy all of the files within that project into your new project.
    + *You’ll have to change the razor UI to match the fields you want to implement for your selected FHIR Resource. For this challenge, you only need to implement the required fields so you can create a new instance in the FHIR repository.*
    + *You’ll also have to change the code-behind files to implement the needs of your selected FHIR Resource.*

3. In **Solution Explorer**, expand the **FhirBlaze.SharedComponents** project, and then expand the **Services** folder.

4. Open **IFhirService.cs**.

5. Expand the **Practitioners** region, copy all of the code within that region, and paste into a new region named after your selected FHIR Resource.

6. Modify the method names and parameter names to be the name of your selected FHIR Resource.

7. Open **FirelyService.cs**.

8. Expand the **Practitioners** region, copy all of the code within that region, and paste into a new region named after your selected FHIR Resource.

9. Modify the method names and parameter names to be the name of your selected FHIR Resource.

10. We have not setup the entire app to handle a new FHIR service Resource type!

## What does success look like for Challenge-10?

+ Run the FhirBlaze application without errors
+ Navigate to your selected FHIR Resource’s list page
+ Retrieve and search your selected FHIR Resources
+ Create and save a new Resource to your FHIR repository
+ Edit and save a new Resource in your FHIR repository
+ Delete a Resource from your FHIR repository

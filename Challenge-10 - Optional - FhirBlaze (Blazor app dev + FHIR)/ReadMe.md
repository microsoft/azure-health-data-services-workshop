
# Challenge-10 - FhirBlaze (Blazor app dev + FHIR)

## Introduction

Welcome to Challenge-10!

In this challenge, you will practice reading from and writing to the FHIR service with a remote application called FhirBlaze.

## Background

With health data systems built on the FHIR standard API, organizations can use the FHIR data model as the basis for custom applications to meet their unique needs. In this challenge, we will use [Firely](https://fire.ly/) to represent the FHIR object model in [.NET](https://dotnet.microsoft.com/en-us/) to make calls into the FHIR service. We will use FhirBlaze as a starter application. It is a bare-bones Blazor application that enables an end user to create or delete certain resources on the FHIR server. FhirBlaze runs as a remote client application making API calls to the FHIR server. We will use FhirBlaze as a front-end interface for connecting with the FHIR server. The ability to send Create and Delete requests to the FHIR server is a fundamental building block for more sophisticated use cases.

## Learning Objectives for Challenge-10

+ Use FHIR resources like patient, practitioner, and more for real world applications.
+ Learn how Firely can accelerate development (and adherence to FHIR).
+ Learn some Blazor web development.

## Prerequisites

+ Visual Studio or Visual Studio Code installed on your local machine. The instructions are written for Visual Studio so you will have to map the equivalent in Visual Studio Code yourself.
+ Working FHIR service instance - no data is required, but it's ok if there is data present on the server.
---
## Step 1 – Configure service and client application
1. Relax the CORS configuration of FHIR service as per [the documentation](https://docs.microsoft.com/en-us/azure/healthcare-apis/fhir/configure-cross-origin-resource-sharing).<br>
2. In the Azure AD, **App Registration** for **Postman** application, under **Authentication**, **Add a platform** of type **Single-page application** with redirect URI set to **https://localhost:44321/authentication/login-callback**

## Step 2 – Intro to FhirBlaze base solution
We created FhirBlaze to accelerate web app development on top of the FHIR server. It lays the foundation for sending Reads and Writes to the FHIR server, freeing you up to build your unique workflows that meet endusers' needs. <br>
1. Clone FhirBlaze solution from [here]( https://github.com/microsoft/FhirBlaze)<br>
2. Open FhirBlaze in **Visual Studio**.<br>
<br>
A quick tour of FhirBlaze <br> 
<br>

+ FhirBlaze is a web application, specifically a Blazor Web Assembly project.
+ Blazor applications allow you to run .NET instead of – or in addition to – JavaScript. <br> Blazor Web Assembly is an application that runs on the user’s client machine,
and manages the user authentication.
+ The other projects in the solution are suffixed with the name ‘Module’. We implemented a form of a micro-frontend pattern that encourages independent and parallel development.

<br>
Let's set up FhirBlaze for your Fhir Server  <br>
<br>

In **Solution Explorer** , right-click the **FhirBlaze** project, and select **Select as Startup Project**.<br> 
<br>
_We have to configure the FhirBlaze application to point to your FHIR API (since you won’t have access to ours. 😊). <br> 
Blazor application settings are stored in an appsettings.json file._ <br> 
<br> 
In **Solution Explorer**, expand the **FhirBlaze** project, expand the **wwwroot** folder, and open **appsettings.json**. <br> 
Modify the **Authority** and **ClientId** values to match your FHIR API instance. <br> 

```  "AzureAd": {
    "Authority": "https://login.microsoftonline.com/[your tenant id]",
    "ClientId": "[your Client ID]",
    "ValidateAuthority": true
  },
Modify the **Scope** and **FhirServerUri** values to match your FHIR API instance.
  "FhirConnection": {
    "Scope": "[your fhir server here]/user_impersonation",
    "FhirServerUri": "[your fhir server here]",
    "Authority": "https://login.microsoftonline.com"
  }, 
  ```
  
If you want to see where the application reads these values from the appsettings.json file
+ Look in the Program.cs file._Build and run FhirBlaze  <br> 
+ Log in with your Active Directory account. <br> 
_The navigation menu items in the left-hand pane are some of the core entities we’ve already developed._ 
+ Click on any navigation menu items in the left-hand pane (e.g. Patients or Practitioners)  <br> 
+ Stop running FhirBlaze
<br>
FhirBlaze out of the box is set up to interact with the Patient, Practitioner, and Questionaire Fhir resources. As you build solutions, you will likely need to add resource types.
<br>
<br>
Let's see how to add a new module. This adds a new Fhir resource type that we can create or delete using FhirBlaze. <br>
<br>

Open **Solution Explorer** pane and continue on to Step 2. <br> 

## Step 3 – Create a new module
Select a resource from [FHIR.org] (https://www.hl7.org/fhir/resourcelist.html) that is not already included as a module in the FhirBlaze solution. <br> 
In **Solution Explorer**, right-click the **FhirBlaze** solution, select **Add**, and then select **New Project…**  <br> 
In the **Add a new project** dialog, set the language filter to **C#**, and then select **Class Library** in the list of project templates. <br> 
_Be sure it is a C# Class Library and doesn’t say Universal Windows or .NET Framework behind Class Library._  <br> 
Click the **Next** button.  <br> 
In the **Project Name** text box, enter **FhirBlaze.[name of your selected FHIR resource]Module**.  <br> 
Click the **Next** button.  <br> 
Confirm **.NET 5.0** is selected and click the **Create** button.  <br> 
Right-click the **FhirBlaze** project, select **Add**, and then select **Project Reference**.  <br> 
Select the name of the module you just added to the solution.   <br> 
In **Solution Explorer**, open **App.razor** and add your new module to the list of assemblies.  <br>  
```
@code {
    private IList<Assembly> AdditionalAssemblies = new[]
    {
        typeof(FhirBlaze.PatientModule.PatientList).Assembly,
        typeof(FhirBlaze.PractitionerModule.PractitionerList).Assembly, 
        // add the type of your new project here!
        typeof(FhirBlaze.QuestionnaireModule.QuestionnaireList).Assembly
    };
}
```

_Adding your assembly here means the assembly will lazy-load – or only load when it’s needed. By lazy-loading assemblies, we keep the application size smaller for end users that may only use a small number of our application’s pages._  <br>  
<br>

Now let's add it to the UI. <br>
<br>

In **Solution Explorer**, expand the **Shared** folder, and open **NavMenu.razor**.
Highlight and copy the last of the list items and paste it within the unordered list. 
Change the **NavLink** element’s **href** property to the plural name of your selected FHIR resource (e.g. practioners).  <br>  
Change the text after the <span> element to the plural name of your FHIR resource. (e.g. Practitioners)  <br>  
Change the 
    
```   
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
<br>
We have now set up the front end of the application for the new Fhir resource. Our last step is to set up the backend to interact with the Fhir server. <br>
    
## Step 4 – Implement the code to get, create, edit, and delete a FHIR resource
    
In **Solution Explorer**, expand the **FhirBlaze.PractitionerModule** project.  
Copy all of the files within that project into your new project. <br>
_You’ll have to change the razor UI to match the fields you want to implement for your selected FHIR resource. For this challenge, you only need to implement the required fields so you can create a new instance in the FHIR repository._ <br>  
You’ll also have to change the code-behind files to implement the needs of your selected FHIR resource.<br>
In **Solution Explorer**, expand the **FhirBlaze.Shared** project, and then expand the **Shared** folder. <br>
Open **IFhirService.cs**. <br>
Expand the **Practioners** region, copy all of the code within that region, and paste into a new region named after your selected FHIR resource.<br>
Modify the method names and parameter names to be the name of your selected FHIR resource. <br>  
Open **FirelyService.cs**. <br>  
Expand the **Practioners** region, copy all of the code within that region, and paste into a new region named after your selected FHIR resource. <br>  
Modify the method names and parameter names to be the name of your selected FHIR resource. <br>  
We have not setup the entire app to handle a new Fhir server resource type!    
    
## What does success look like for Challenge-10?
+ run the FhirBlaze application w/o errors
+ navigate to your selected FHIR resource’s list page
+ retrieve and search your selected FHIR resources
+ create and save a new resource to your FHIR repository
+ edit and save a new resource in your FHIR repository
+ delete a resource from your FHIR repository

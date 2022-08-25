# Challenge-00 - Check Prerequisites and Configure Environment

## Introduction

In this preliminary challenge, you will be checking the general prerequisites for this workshop to ensure you are ready for Challenge-01 and beyond.
 
## Learning Objectives for Challenge-00

+ Understand the goals for learners in this workshop.
+ Review the knowledge prerequisites.
+ Check that your Azure environment is ready for the workshop.

## Background

The Azure Health Data Services Workshop presents a series of challenges to help learners build knowledge, experience, and skills in working with [Azure Health Data Services](https://docs.microsoft.com/azure/healthcare-apis/healthcare-apis-overview). This workshop features solutions for use in real-world health data production environments. After working through the challenges, learners will have a better understanding of how to build their own solutions using the latest health data tools from Microsoft.

## What do we want learners to gain from the Azure Health Data Services Workshop?

In general, we want learners to walk away with a sense of confidence in **deploying**, **configuring**, and **implementing** Microsoft's health data solutions.

+ In completing this workshop, learners will know the capabilities of Microsoft's health data services.
+ Learners will know how to **ingest**, **transform**, and **connect health data** using the Azure health data platform.
+ The tasks require learners to locate information in technical documentation and **resolve issues independently**. This workshop is meant to give learners practice retrieving information from Microsoft documentation resources.
+ Working on the challenges will give learners a strong concept of how the components fit together. With this knowledge, learners will be prepared to **use Microsoft Health & Life Sciences (HLS) tools in real-world solutions**.

## Prerequisite Knowledge for the Azure Health Data Services Workshop

Knowledge in the areas listed below will be necessary for completing the workshop challenges. If you feel uncertain about any of these topics, please review the [More Resources section](#more-resources). Time spent building some basic knowledge about the technologies used in this workshop will help you gain *actionable experience* as you prep for real-world health data scenarios.

+ A solid foundation in **Azure fundamentals** and basic knowledge of **Azure Active Directory**
+ Familiarity with **FHIR®** and the solutions it provides versus other health data formats
+ Experience with making **RESTful API** requests using [Postman](https://www.postman.com/api-platform/api-testing/) or a similar API testing tool (like cURL or Fiddler)

**Note:** For the rest of the workshop, we will assume that you are using Postman as your API testing tool. Please use Postman unless you have a strong preference for another tool.

## Environment Prerequisites

Please make sure to have the following items ready before moving on to Challenge-01.

+ [Azure Subscription](https://azure.microsoft.com/) with [Owner rights](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner)
+ [Application Administrator](https://docs.microsoft.com/azure/active-directory/roles/permissions-reference#all-roles) role in your [Azure Active Directory (AAD) tenant](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis#:~:text=Azure%20tenant,tenant%20represents%20a%20single%20organization) (for app configuration in Challenge-07)
+ [Postman](https://www.postman.com/) installed - either desktop or web client ([link](https://www.getpostman.com/))
+ GitHub account ([link](https://github.com/))
+ A text editor (e.g., [Visual Studio Code](https://code.visualstudio.com/))

**Note:** Free Postman cloud accounts require a login via email or a Google account. Additionally, Postman recommends that if you choose to use the web client, you should also download the desktop application. You can read more and download the Postman desktop client [here](https://www.postman.com/downloads).

## Components Deployed

Below is a list of Azure and OSS components deployed in Challenge-01 of this workshop. 

Component | Purpose                               
----------|--------------------------------------------
**Azure Health Data Services workspace** | managed PaaS
**FHIR service** | managed FHIR server
**FHIR-Proxy (OSS)** Function App | for filtering FHIR data input/output in Challenge-07
**FHIR Loader (OSS)** Function App | for ingesting FHIR data in Challenge-03
App Service Plan | Shared by FHIR-Proxy and FHIR Loader function apps
Storage account | Blob storage for FHIR service `$export` operation in Challenge-05
Storage account | Storage for FHIR-Proxy function app
Storage account | Storage account for FHIR Loader
Key Vault | Stores secrets and configuration settings
Log Analytics Workspace | Logs the activity of deployed components
Application Insights | Monitors FHIR Loader application
Application Insights | Monitors FHIR-Proxy application
Event Grid System Topic | Triggers processing of FHIR bundles placed in the FHIR Loader storage account
Redis Cache | Required by FHIR-Proxy modules, Consent Opt Out


## More Resources 

If you are unfamiliar with any of the above concepts, have a look at the resources below. These are starting points to help you get the most out of this workshop.

### Azure

Microsoft Azure is a cloud computing platform that enables on-demand, highly scalable computing for organizations and individuals all over the world. It is the core of every challenge in this workshop.

+ [Azure Cloud Concepts](https://docs.microsoft.com/learn/paths/az-900-describe-cloud-concepts/)
+ [Azure Active Directory App Registrations and Auth Tokens](https://docs.microsoft.com/learn/modules/implement-app-registration/)

### FHIR

FHIR® (Fast Healthcare Interoperability Resources) is a data standard created by HL7 (Health Level Seven) for ingesting, persisting, and querying data generated in healthcare scenarios.

+ [HL7 FHIR Introduction](https://www.hl7.org/fhir/summary.html)
+ [FHIR Architect's Introduction](https://www.hl7.org/fhir/overview-arch.html)

### RESTful APIs

REST (Representational State Transfer) APIs (Application Programming Interfaces) or web APIs are a software architectural style created for internet services. Every internet user makes thousands of RESTful API requests a day, usually without knowing it since requests are handled by applications and generally not seen by users.

+ [RESTful Web API design](https://docs.microsoft.com/azure/architecture/best-practices/api-design)
+ [Representational state transfer](https://wikipedia.org/wiki/Representational_state_transfer)

### API Testing Tools (Postman)

Developers use API testing tools to inspect the call and response behavior between remote client applications and web services. Postman is one of the most popular and approachable of these types of tools. If you are new to Postman, review the resources below to install and get familiar with the application. FHIR must be tested with an API testing tool, and in this workshop, you will need to know how to craft RESTful requests in Postman and interpret the results.

+ [Installing and updating Postman](https://learning.postman.com/docs/getting-started/installation-and-updates/)
+ [Navigating Postman](https://learning.postman.com/docs/getting-started/navigating-postman/)
+ [Sending your first request](https://learning.postman.com/docs/getting-started/sending-the-first-request/)
+ [Creating a workspace](https://learning.postman.com/docs/getting-started/creating-your-first-workspace/)
+ [Creating your first collection](https://learning.postman.com/docs/getting-started/creating-the-first-collection/)
+ [Managing environments](https://learning.postman.com/docs/sending-requests/managing-environments/)

## Next Steps

Click [here](<../Challenge-01 - Deploy AHDS workspace and FHIR service/Readme.md>) to start Challenge-01.
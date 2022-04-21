# Challenge-00 - Check Prerequisites and Configure Environment

## Introduction

In this preliminary challenge, you will be checking your Azure environment and other prerequisites of the workshop to ensure you are ready for Challenge-01 and beyond.
 
## Learning Objectives for Challenge-00

+ Understand the general learner goals of this workshop.
+ Check the knowledge prerequisites for this workshop.
+ Check that your Azure environment is ready for this workshop.

## Background

The Azure Health Data Services Workshop presents a series of challenges to help learners build knowledge, experience, and skills in working with Azure Health Data Services, including the FHIR, DICOM, and MedTech services. This workshop features solutions that Microsoft has observed a need for in real-world health data production environments. After this workshop, you will have a better understanding of how to build your own solutions using the latest healthcare-focused tools from Microsoft.

## What do we want learners to gain from the Azure Health Data Services Workshop?

In general, we want learners to walk away with a sense of confidence in deploying, configuring, and implementing Microsoft's health data solutions.

+ In completing this workshop, learners will know the capabilities of Microsoft's health data services.
+ Learners will know how to **deploy**, **ingest**, **transform**, and **connect health data** using the Azure health data platform.
+ The tasks require learners to locate information in technical documentation and **resolve issues independently**. This workshop is meant to give learners practice retrieving information from Microsoft documentation resources.
+ Working on the challenges will give learners a strong concept of how the components fit together. With this knowledge, learners will be prepared to **use Microsoft Health & Life Sciences (HLS) tools in real-world solutions**.

## Prerequisite Knowledge for the Azure Health Data Services Workshop

Familiarity with these concepts will be necessary for completing the challenges in this workshop. If you feel uncertain about any of the topics below, please review the [More Resources section](#more-resources). Time spent upfront building some basic knowledge about the technologies used in this workshop will help you gain *actionable experience* in preparation for the real-world scenarios you will face.

+ A solid foundation in **Azure fundamentals** and basic knowledge of **Azure Active Directory**.
+ Familiarity with **FHIR®** and the solutions it provides versus legacy health data formats.
+ Experience with making **REST API** requests using [Postman](https://www.postman.com/api-platform/api-testing/) or a similar API testing tool (like cURL or Fiddler).

**Note:** For the rest of the workshop, instructions will be geared towards using Postman as your API testing tool. Please use Postman unless you have a strong preference for another tool.

## Environment Prerequisites

Please make sure you have the following before moving on to Challenge-01.

+ [Azure Subscription](https://azure.microsoft.com/) with [Owner rights](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner).
+ [Application Administrator](https://docs.microsoft.com/azure/active-directory/roles/permissions-reference#all-roles) role in your [Azure Active Directory (AAD) tenant](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis#:~:text=Azure%20tenant,tenant%20represents%20a%20single%20organization).
+ [Postman](https://www.postman.com/) installed - either desktop or web client ([link](https://www.getpostman.com/)).
+ GitHub account ([link](https://github.com/)).
+ A text editor (e.g., [Visual Studio Code](https://code.visualstudio.com/)).

**Note:** Free Postman cloud accounts require a login via email or a Google account. Additionally, Postman recommends that if you choose to use the web client, you should also download the desktop application. You can read more and download the Postman desktop client [here](https://www.postman.com/downloads).

## Next Steps

Click [here](<../Challenge-01 - Deploy FHIR service (PaaS), FHIR-Proxy (OSS), and FHIR-Bulk Loader (OSS)/Readme.md>) to start Challenge-01.

## More Resources

If you are unfamiliar with any of the above concepts, have a look at the resources below. These are starting points to help you get the most out of this workshop.

### Azure

Microsoft Azure is a cloud computing platform that enables on-demand, highly scalable computing for organizations and individuals all over the world. It is the core of every challenge and step in this workshop.

+ [Azure Cloud Concepts](https://docs.microsoft.com/learn/paths/az-900-describe-cloud-concepts/)
+ [Azure Active Directory App Registrations and Auth Tokens](https://docs.microsoft.com/learn/modules/implement-app-registration/)

### FHIR

FHIR® (Fast Healthcare Interoperability Resources) is a data standard created by HL7 (Health Level Seven) for ingesting, managing, and persisting health data.

+ [HL7 FHIR Introduction](https://www.hl7.org/fhir/summary.html)
+ [FHIR Architect's Introduction](https://www.hl7.org/fhir/overview-arch.html)

### REST APIs

REST (Representational State Transfer) APIs (Application Programming Interfaces) or web APIs are a software architectural style created for internet services. Every internet user makes thousands of REST API requests a day, usually without knowing this since requests are handled by applications and generally not seen by users.

+ [RESTful Web API design](https://docs.microsoft.com/azure/architecture/best-practices/api-design)
+ [Representational state transfer](https://wikipedia.org/wiki/Representational_state_transfer)

### API Testing Tools (Postman)

Since REST API requests and responses are abstracted from users, developers use an API testing tool to interact with web services prior to building applications and integrations. Postman is the most popular and approachable of these types of tools and the recommended one for learners. If you are new to Postman, review these resources below to install and get familiar with the application. FHIR must be tested with an API testing tool, and in this workshop, you will need to know how to craft REST requests and interpret the results.

+ [Installing and updating Postman](https://learning.postman.com/docs/getting-started/installation-and-updates/)
+ [Navigating Postman](https://learning.postman.com/docs/getting-started/navigating-postman/)
+ [Sending your first request](https://learning.postman.com/docs/getting-started/sending-the-first-request/)
+ [Creating a workspace](https://learning.postman.com/docs/getting-started/creating-your-first-workspace/)
+ [Creating your first collection](https://learning.postman.com/docs/getting-started/creating-the-first-collection/)
+ [Managing environments](https://learning.postman.com/docs/sending-requests/managing-environments/)

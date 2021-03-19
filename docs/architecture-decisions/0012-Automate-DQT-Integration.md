# 11. Automate DQT Integration with Claim service 

Date: 2021-03-19

## Status

Accepted

## Context
DfE needs to validate the teacher's identity and qualification before approving 
the claim. The GOV verify is depreciated now and needs to replace with other system
to validate teacher's identity. 

## Decision

The service will replace GOV verify with Database for Qualified Teachers ([DQT](https://teacherservices.education.gov.uk/SelfService/Login)) for teacher's identity and QTS check before approving the 
claims. The DQT will provide the DQT dataset according to the policy on daily basis 
and the service will validate the teacher's identity and QTS against the DQT via API. 
The claim service team will be responsible to manage the temporary DQT API and data until 
actual DQT API ready to server all requests. 

This DQT integration automation will also replace the manually verify claims through DQT CSV report. 

## Consequences

The claim service team needs to ensure that DQT dataset is protected and only accessible 
via protected API. The team must replace the temporary DQT API whenever actual DQT API will be ready to serve 
requests and the claim team must delete the DQT dataset and destroy temporary DQT API. 

The service operator will manually validate the teacher's identity and QTS checks if the
DQT automation process fails. 

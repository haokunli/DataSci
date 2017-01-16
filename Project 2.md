### Direct marketing of term deposits

#### Introduction

There are two main approaches for companies to promote products and/or services: through mass campaigns, targeting general indiscriminate public, or through direct marketing, targeting a specific set of contacts. Nowadays, in a global competitive world, positive responses to mass campaigns are typically very low. Alternatively, direct marketing focus on targets that assumably will be keener to that specific product/service, making these campaigns more attractive, because of their efficiency. But the increasingly vast number of marketing campaigns has reduced their effect on the general public. Furthermore, economical pressures and competition has led marketing managers to invest on direct campaigns with a strict and rigorous selection of contacts.

Due to the internal competition and the current financial crisis, there are huge pressures for European banks to increase their financial assets. One strategy is to offer attractive long-term deposit applications with good interest rates, in particular by using direct marketing campaigns. A Portuguese institution has been offering term deposits to its clients for the past two years, but in a way that the board finds disorganized and inefficient. It looks as if too many contacts were made, for the subscriptions obtained.

The bank has been using its own contact-center to carry out direct marketing campaigns. The telephone was the dominant marketing channel, although sometimes with an auxiliary use of the Internet online banking channel (e.g. by showing information to a specific targeted client). Furthermore, each campaign was managed in an integrated fashion and the results for all channels were outputted together.

The manager in charge of organizing the next campaign is expected to optimize the effort. His objective is to find a predictive model, based on data of the preceding campaign, which can explain the success of a contact, i.e. if the client subscribes the deposit. Such model can increase the campaign's efficiency by identifying the main characteristics that affect success, helping in a better management of the available resources (e.g. human effort, phone calls and time) and the selection of a high quality and affordable set of potential customers. To be useful for the direct campaign, a predictive model should allow to reduce the number of
calls in a relevant way without loosing a relevant number of subscribers.

#### The data set

The data collected come from the previous campaign, which involved a total of 45,211 contacts. During this phone campaign, an attractive long-term deposit application, with good interest rates, was offered. The contacts led to 5,829 subscriptions (11.7% success rate).

The data set combines demographic data with data about the interaction of the customer and the bank. The variables are:

* Age in years (`age`).

* Type of job (`job`). The values are "admin", "unknown", "unemployed", "management", "housemaid", "student", "retired", "self-employed", "entrepreneur", "technician" and "services".

* Marital status (`marital`). The values are "married", "divorced" and "single".

* Education level (`education`). The values are "unknown", "secondary", "primary" and "tertiary".

* Has credit in default? (`default`). The values are "yes" and "no".

* Average yearly balance in euros (`balance`).

* Has housing loan? (`housing`). The values are "yes" and "no".

* Has personal loan? (`loan`). The values are "yes" and "no".

* Usual communication channel (`contact`). The values are "unknown", "telephone" and "cellular".

* Duration of last contact before the campaign in seconds (`duration`).  

* Number of days passed by after the client was last contacted from a previous campaign (`pdays`). When the client has not been not previously contacted, it takes value -1.

* Number of contacts performed before this campaign and for this client (`previous`).

* Outcome of the previous marketing campaign (`poutcome`). The values are "unknown", "other", "failure" and "success".

* Has the client subscribed a term deposit? (`deposit`). The values are "yes" and "no".

Source: S Moro, R Laureano & P Cortez (2011), Using data mining for bank direct marketing --- An application of the CRISP-DM methodology, *Proceedings of the European Simulation and Modelling Conference* (Guimarães, Portugal). 

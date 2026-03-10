# Projet 8 – Salesforce CRM pour GlobalGroupTravel

Développement d’un back-end Salesforce complet pour automatiser la gestion des voyages de groupe (Trip__c) à partir des opportunités gagnées.

## 🧭 Sommaire

- [Contexte](#contexte)
- [Architecture](#architecture)
- [Diagrammes UML](#diagrammes-uml)
- [Diagrammes Mermaid](#diagrammes-mermaid)
- [Technologies utilisées](#technologies-utilisées)
- [Auteur](#auteur)

---

## 📌 Contexte

GlobalGroupTravel souhaite optimiser ses processus de vente et de suivi client via une solution CRM Salesforce.  
Le projet inclut :

- Création de l’objet personnalisé `Trip__c`
- Automatisation via triggers Apex
- Batchs Apex pour annulation et mise à jour des statuts
- Relations entre Account, Opportunity, Trip__c, Task, User
- 100 % de couverture de test

---

## 🧱 Architecture

```mermaid
flowchart TD
    A[Selector] --> B[Orchestrator]
    B --> C[Service]
    C --> D[Trigger]
    D --> E[Trip__c]
    C --> F[Batch GGT-04]
    C --> G[Batch GGT-05]
```

---

## 🧠 Diagrammes UML


### Diagramme de Classes

```mermaid
classDiagram
    class Account {
        - idAccount
        - Name
        - Phone
        - Email
        + getOpportunities()
        + getTrips()
    }

    class Opportunity {
        - idOpportunity
        - Amount
        - StageName
        - Destination__c
        - Start_Date__c
        - End_Date__c
        - Number_of_Participants__c
        + updateStage()
        + createTrip()
    }

    class Trip__c {
        - idTrip
        - TripName
        - Status__c
        - Destination__c
        - Start_Date__c
        - End_Date__c
        - Number_of_Participants__c
        - Total_Cost__c
        + validateDates()
        + updateStatus()
    }

    class Task {
        - idTask
        - Subject
        - ActivityDate
        - Status
        + createTask()
        + closeTask()
    }

    class User {
        - idUser
        - Name
        - Role
        - Email
        + assignTask()
        + manageOpportunities()
    }

    Account --> Opportunity : possède >
    Account --> Trip__c : lié à >
    Opportunity --> Trip__c : crée >
    User --> Task : assigne >
    Account --> Task : associé à >
```

---

## 🎭 Diagrammes Mermaid

### Séquence – Trigger Opportunity

```mermaid
sequenceDiagram
    autonumber
    actor Commercial
    participant TriggerOpp as Opportunity Trigger
    participant Service as TripService
    participant Trip as Trip__c
    participant DB as Database

    Commercial ->> TriggerOpp: Update Opportunity\n(Stage = Closed Won)
    TriggerOpp ->> TriggerOpp: Check StageName == "Closed Won"
    TriggerOpp ->> Service: createTripFromOpportunity(opp)

    Service ->> Trip: new Trip__c()
    Service ->> Trip: mapFieldsFromOpportunity()
    Service ->> DB: insert Trip__c

    DB -->> Service: Trip created
    Service -->> TriggerOpp: Confirmation
    TriggerOpp -->> Commercial: Trip created automatically
```

### Activité – Batch GGT-04

```mermaid
flowchart TD
    A[Start] --> B[Select Trips\nStart_Date = Today + 7 days]
    B --> C{Participants < 10 ?}

    C -->|Yes| D[Set Status = Annulé]
    D --> E[Update Trip]

    C -->|No| F[Do nothing]

    E --> G[Stop]
    F --> G
```

### Activité – Batch GGT-05

```mermaid
flowchart TD
    A[Start] --> B[Select all Trips]

    B --> C{Today < Start_Date ?}
    C -->|Yes| D[Status = A_venir]
    C -->|No| E{Today <= End_Date ?}

    E -->|Yes| F[Status = En_cours]
    E -->|No| G[Status = Termine]

    D --> H[Update Trip]
    F --> H
    G --> H

    H --> I[Stop]
```

---

## 🛠️ Technologies utilisées

- Salesforce Apex  
- Triggers & Batch Apex  
- Salesforce DX  
- Git & GitHub  
- Mermaid (diagrammes)  
- VS Code  

---

## 👩‍💻 Auteur

Murielle Majesté – Développeuse Salesforce  
GitHub : https://github.com/muriellemajeste1971-collab  
LinkedIn : https://www.linkedin.com/in/murielle-majesté-52698620 

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
- Triggers Apex pour automatiser la création et la validation  
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

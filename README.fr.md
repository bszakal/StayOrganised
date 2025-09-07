# StayOrganised - Application iOS de Gestion de Tâches

Une application iOS de gestion de tâches construite avec SwiftUI, démontrant les pratiques modernes de développement iOS, une architecture propre et des stratégies de tests complètes.

## 📱 Captures d'écran

| Vue d'accueil | Création de tâches | Vue calendrier |
|---------------|-------------------|----------------|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 51 32" src="https://github.com/user-attachments/assets/99a57945-0e3d-48a4-ae2a-1b5fcd8f5e43" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 52 28" src="https://github.com/user-attachments/assets/92f796ca-d95d-4e2f-92db-e28cae468efc" /> |<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 52 54" src="https://github.com/user-attachments/assets/7b740cd6-01b2-484d-9e18-06f18a0f7857" /> |

## 🏗️ Vue d'ensemble de l'architecture

Cette application suit le modèle **MVVM (Model-View-ViewModel) + Services** avec une adhérence stricte aux **principes SOLID**, garantissant un code maintenable, testable et évolutif.

### Composants architecturaux principaux

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Vues        │◄───┤   ViewModels    │◄───┤   Services      │
│   (SwiftUI)     │    │   (Observable   │    │ (Core Data,     │
│                 │    │    Objects)     │    │ Parseurs, etc.) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │ Modèles Métier  │
                       │   (Domaine)     │
                       └─────────────────┘
```

### Décisions architecturales clés

#### 1. **Injection de dépendance & Pattern Factory**
- **Pattern Factory** : Tous les ViewModels sont créés via `ViewModelsFactory` pour une injection de dépendance cohérente
- **Conception orientée protocole** : Tous les services implémentent des protocoles pour faciliter les tests et la modularité
- **Abstraction Core Data** : La logique métier n'importe jamais directement Core Data - tout passe par les couches de service

#### 2. **Séparation des responsabilités**
- **Vues** : SwiftUI pur avec logique minimale, ne gèrent que la mise en page et les interactions utilisateur
- **ViewModels** : Gèrent la logique métier, la gestion d'état et coordonnent entre les services
- **Services** : Gèrent la persistance des données, le parsing et les intégrations externes
- **Modèles** : Objets métier propres sans dépendances Core Data

#### 3. **Architecture de flux de données**
```
Core Data ➜ CoreDataService ➜ TaskParser ➜ CoreDataManager ➜ ViewModel ➜ Vue
    ↓               ↓              ↓              ↓           ↓        ↓
Données     ➜   Entités    ➜   Modèles    ➜    État      ➜ Propriétés ➜ UI
Brutes                        Métier         Publié        @Published
```

## 🛠️ Implémentation technique

### Stack Core Data
- **CoreDataFactory** : Crée et gère la pile Core Data avec injection de dépendance
- **CoreDataService** : Gère les opérations CRUD sur les entités Core Data
- **TaskParser** : Convertit entre les entités Core Data et les modèles métier
- **CoreDataManager** : Orchestre les opérations de données et publie les changements

### Gestion d'état
- **Framework Combine** : Programmation réactive pour le flux de données
- **Propriétés @Published** : Mises à jour automatiques de l'UI lors des changements de données
- **Pattern Publisher** : CoreDataManager publie les mises à jour de tâches aux ViewModels

### Localisation et thèmes
- **Support bilingue** : Localisation anglais et français
- **Gestion de thèmes** : Changement de thème dynamique avec personnalisation des couleurs
- **Enum LocalizedString** : Clés de localisation type-safe

## 📱 Fonctionnalités

### ✅ Fonctionnalités principales
- **Gestion des tâches** : Créer, modifier, supprimer et basculer le statut de completion
- **Filtrage** : Filtrer par plage de dates, catégorie et statut de completion
- **Actions de balayage** : Accès rapide pour modifier, supprimer et marquer comme terminé

### 📅 Autres fonctionnalités
- **Intégration calendrier** : Vue mensuelle avec indicateurs de tâches et sélection de plage de dates
- **Suivi des progrès** : Barres de progression visuelles montrant les taux de completion
- **Système de catégories** : Organiser les tâches par Travail, Personnel, Santé, Éducation, Courses

## 🧪 Stratégie de tests

### Tests unitaires
Couverture complète des tests unitaires se concentrant sur l'isolation de la logique métier :

#### **Tests CoreDataManager**
- ✅ Création de tâches avec dépendances mockées
- ✅ Vérification de la persistance des données
- ✅ Validation du comportement des publishers

#### **Tests ViewModel**
- ✅ **TaskListViewModel** : Filtrage par date, filtrage par catégorie, gestion d'état des tâches
- ✅ **CreateTaskViewModel** : Flux de création, modification et suppression de tâches

### Tests d'intégration
Tests full-stack avec Core Data en mémoire :

#### **Tests d'intégration CreateTaskViewModel**
- ✅ Flux de création de tâches de bout en bout
- ✅ Modification de tâches avec changements de propriétés
- ✅ Vérification de suppression de tâches
- ✅ Tests d'intégration des publishers

### Architecture de tests
```
┌─────────────────┐    ┌─────────────────┐    
│  Tests unitaires│    │Tests intégration│    
│                 │    │                 │    
│ • ViewModels    │    │ • Full Stack    │ 
│ • Services      │    │ • Core Data     │ 
│ • Dép. mockées │    │ • Publishers    │  
└─────────────────┘    └─────────────────┘
```

## 🏛️ Implémentation des principes SOLID

### Principe de responsabilité unique (SRP)
- Chaque classe a un objectif clair (ex: `TaskParser` ne gère que la conversion de données)
- Les ViewModels se concentrent uniquement sur la logique de leur vue spécifique

### Principe Liskov de substitution (LSP)
- Toutes les implémentations de service peuvent être substituées via leurs protocoles
- Les mocks remplacent de manière transparente les services de production dans les tests

### Principe de ségrégation d'interface (ISP)
- Protocoles séparés pour différentes responsabilités (`CoreDataServiceProtocol`, `TaskParserProtocol`)
- Aucun client ne dépend de méthodes qu'il n'utilise pas

### Principe d'inversion de dépendance (DIP)
- Les modules de haut niveau dépendent d'abstractions (protocoles), pas d'implémentations concrètes
- Dépendances injectées via constructeurs et factories

## 🚀 Démarrage

### Prérequis
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Cloner le dépôt
2. Ouvrir `StayOrganised.xcodeproj` dans Xcode
3. Sélectionner votre appareil/simulateur cible
4. Appuyer sur `Cmd + R` pour construire et exécuter

### Exécution des tests
- **Tests unitaires** : `Cmd + U` ou sélectionner des fichiers de test spécifiques
- **Tests d'intégration** : Situés dans `StayOrganisedTests/IntegrationTests/`
- **Couverture** : Activer la couverture de code dans les paramètres de schéma Xcode

## 📁 Structure du projet

```
StayOrganised/
├── Models/                     # Modèles métier
│   └── Task.swift
├── CoreData/                   # Couche de données
│   ├── CoreDataFactory.swift
│   ├── CoreDataManager.swift
│   ├── CoreDataService.swift
│   └── TaskParser.swift
├── Views/                      # Vues SwiftUI & ViewModels
│   ├── Home/
│   ├── Calendar/
│   ├── CreateTask/
│   ├── Profile/
│   └── SharedViews/
├── Utils/                      # Utilitaires & Helpers
│   ├── LocalizedString.swift
│   └── ThemeManager.swift
└── Resources/                  # Fichiers de localisation
    ├── en.lproj/
    └── fr.lproj/

StayOrganisedTests/
├── Unit Tests/                 # Tests unitaires isolés
│   ├── CoreDataManagerTests.swift
│   ├── TaskListViewModelTests.swift
│   └── Mocks/
└── IntegrationTests/           # Tests de bout en bout
    └── CreateTaskViewModelTests.swift
```

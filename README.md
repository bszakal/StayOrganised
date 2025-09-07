# Other README
[![fr](https://img.shields.io/badge/lang-fr-red.svg)](https://github.com/bszakal/StayOrganised/blob/main/README.fr.md)

# StayOrganised - iOS To-Do App

An iOS to-do application built with SwiftUI, demonstrating modern iOS development practices, clean architecture, and comprehensive testing strategies.

## 📱 Screenshots

| Home View | Task Creation | Calendar View |
|-----------|---------------|---------------|
| <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 51 32" src="https://github.com/user-attachments/assets/99a57945-0e3d-48a4-ae2a-1b5fcd8f5e43" /> | <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 52 28" src="https://github.com/user-attachments/assets/92f796ca-d95d-4e2f-92db-e28cae468efc" /> |<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-07 at 18 52 54" src="https://github.com/user-attachments/assets/7b740cd6-01b2-484d-9e18-06f18a0f7857" /> |

## 🏗️ Architecture Overview

This application follows the **MVVM (Model-View-ViewModel) + Services** pattern with strict adherence to **SOLID principles**, ensuring maintainable, testable, and scalable code.

### Core Architecture Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     Views       │◄───┤   ViewModels    │◄───┤   Services      │
│   (SwiftUI)     │    │   (Observable   │    │ (Core Data,     │
│                 │    │    Objects)     │    │  Parsers, etc.) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │ Business Models │
                       │   (Domain)      │
                       └─────────────────┘
```

### Key Architectural Decisions

#### 1. **Dependency Injection & Factory Pattern**
- **Factory Pattern**: All ViewModels are created through `ViewModelsFactory` for consistent dependency injection
- **Protocol-Oriented Design**: All services implement protocols for easy testing and modularity
- **Core Data Abstraction**: Business logic never directly imports Core Data - everything goes through service layers

#### 2. **Separation of Concerns**
- **Views**: Pure SwiftUI with minimal logic, only handle layout and user interactions
- **ViewModels**: Handle business logic, state management, and coordinate between services
- **Services**: Handle data persistence, parsing, and external integrations
- **Models**: Clean business objects without Core Data dependencies

#### 3. **Data Flow Architecture**
```
Core Data ➜ CoreDataService ➜ TaskParser ➜ CoreDataManager ➜ ViewModel ➜ View
    ↓               ↓              ↓              ↓           ↓       ↓
Raw Data    ➜   Entities   ➜  Business    ➜   Published  ➜ @Published ➜ UI
                              Models          State         Properties
```

## 🛠️ Technical Implementation

### Core Data Stack
- **CoreDataFactory**: Creates and manages Core Data stack with dependency injection
- **CoreDataService**: Handles CRUD operations on Core Data entities
- **TaskParser**: Converts between Core Data entities and business models
- **CoreDataManager**: Orchestrates data operations and publishes changes

### State Management
- **Combine Framework**: Reactive programming for data flow
- **@Published Properties**: Automatic UI updates when data changes
- **Publisher Pattern**: CoreDataManager publishes task updates to ViewModels

### Localization & Theming
- **Dual Language Support**: English and French localization
- **Theme Management**: Dynamic theme switching with color customization
- **LocalizedString Enum**: Type-safe localization keys

## 📱 Features

### ✅ Core Functionality
- **Task Management**: Create, edit, delete, and toggle completion status
- **Filtering**: Filter by date range, category, and completion status
- **Swipe Actions**: Quick access to edit, delete, and mark complete

### 📅 Other Features
- **Calendar Integration**: Month view with task indicators and date range selection
- **Progress Tracking**: Visual progress bars showing completion rates
- **Category System**: Organize tasks by Work, Personal, Health, Education, Grocery

## 🧪 Testing Strategy

### Unit Tests
Comprehensive unit test coverage focusing on business logic isolation:

#### **CoreDataManager Tests**
- ✅ Task creation with mocked dependencies
- ✅ Data persistence verification
- ✅ Publisher behavior validation

#### **ViewModel Tests**
- ✅ **TaskListViewModel**: Date filtering, category filtering, task state management
- ✅ **CreateTaskViewModel**: Task creation, modification, and deletion workflows

### Integration Tests
Full-stack testing with in-memory Core Data:

#### **CreateTaskViewModel Integration Tests**
- ✅ End-to-end task creation flow
- ✅ Task modification with property changes
- ✅ Task deletion verification
- ✅ Publisher integration testing

### Testing Architecture
```
┌─────────────────┐    ┌─────────────────┐    
│   Unit Tests    │    │Integration Tests│    
│                 │    │                 │    
│ • ViewModels    │    │ • Full Stack    │ 
│ • Services      │    │ • Core Data     │ 
│ • Mocked Deps   │    │ • Publishers    │  
└─────────────────┘    └─────────────────┘
```

## 🏛️ SOLID Principles Implementation

### Single Responsibility Principle (SRP)
- Each class has one clear purpose (e.g., `TaskParser` only handles data conversion)
- ViewModels focus solely on their specific view's logic

### Liskov Substitution Principle (LSP)
- All service implementations can be substituted via their protocols
- Mocks seamlessly replace production services in tests

### Interface Segregation Principle (ISP)
- Separate protocols for different responsibilities (`CoreDataServiceProtocol`, `TaskParserProtocol`)
- No client depends on methods it doesn't use

### Dependency Inversion Principle (DIP)
- High-level modules depend on abstractions (protocols), not concrete implementations
- Dependencies injected through constructors and factories

## 🚀 Getting Started

### Prerequisites
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `StayOrganised.xcodeproj` in Xcode
3. Select your target device/simulator
4. Press `Cmd + R` to build and run

### Running Tests
- **Unit Tests**: `Cmd + U` or select specific test files
- **Integration Tests**: Located in `StayOrganisedTests/IntegrationTests/`
- **Coverage**: Enable code coverage in Xcode scheme settings

## 📁 Project Structure

```
StayOrganised/
├── Models/                     # Business Models
│   └── Task.swift
├── CoreData/                   # Data Layer
│   ├── CoreDataFactory.swift
│   ├── CoreDataManager.swift
│   ├── CoreDataService.swift
│   └── TaskParser.swift
├── Views/                      # SwiftUI Views & ViewModels
│   ├── Home/
│   ├── Calendar/
│   ├── CreateTask/
│   ├── Profile/
│   └── SharedViews/
├── Utils/                      # Utilities & Helpers
│   ├── LocalizedString.swift
│   └── ThemeManager.swift
└── Resources/                  # Localization Files
    ├── en.lproj/
    └── fr.lproj/

StayOrganisedTests/
├── Unit Tests/                 # Isolated Unit Tests
│   ├── CoreDataManagerTests.swift
│   ├── TaskListViewModelTests.swift
│   └── Mocks/
└── IntegrationTests/           # End-to-End Tests
    └── CreateTaskViewModelTests.swift
```

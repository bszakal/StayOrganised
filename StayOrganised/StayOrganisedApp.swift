//
//  StayOrganisedApp.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 02/09/2025.
//

import SwiftUI
import CoreData

@main
struct StayOrganisedApp: App {
    
    @StateObject private var themeManager = ThemeManager()
    
    private let coreDataService: CoreDataServiceProtocol
    private let taskParser: TaskParserProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    init() {
        let persistentContainer = NSPersistentContainer(name: "StayOrganisedModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        
        let coreDataService = CoreDataService(context: persistentContainer.viewContext)
        let taskParser = TaskParser(context: persistentContainer.viewContext)
        let coreDataManager = CoreDataManager(coreDataService: coreDataService, taskParser: taskParser)
        
        self.coreDataService = coreDataService
        self.taskParser = taskParser
        self.coreDataManager = coreDataManager
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(themeManager)
                .environment(\.coreDataManager, coreDataManager)
        }
    }
}

private struct CoreDataManagerKey: EnvironmentKey {
    static let defaultValue: CoreDataManagerProtocol? = nil
}

extension EnvironmentValues {
    var coreDataManager: CoreDataManagerProtocol? {
        get { self[CoreDataManagerKey.self] }
        set { self[CoreDataManagerKey.self] = newValue }
    }
}

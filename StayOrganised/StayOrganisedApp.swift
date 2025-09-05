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

    private let coreDataManager: CoreDataManagerProtocol
    private let mainTabViewModel: MainTabViewModel
    
    init() {

        self.coreDataManager = CoreDataManager(coreDataFactory: CoreDataFactory())
        let viewModelsFactory = ViewModelsFactory(coreDataManager: coreDataManager)
        
        self.mainTabViewModel = MainTabViewModel(homeViewModelFactory: viewModelsFactory, calendarViewModelFactory: viewModelsFactory)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(viewModel: mainTabViewModel)
                .environmentObject(themeManager)
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

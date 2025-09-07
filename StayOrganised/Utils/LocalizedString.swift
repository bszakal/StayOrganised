import Foundation

enum LocalizedString: String, CaseIterable {
    case letsGo = "lets_go"
    case calendar = "calendar"
    case yourTimeline = "your_timeline"
    case todaysTasks = "todays_tasks"
    case completed = "completed"
    case createTask = "create_task"
    case modifyTask = "modify_task"
    case taskTitle = "task_title"
    case taskActivity = "task_activity"
    case date = "date"
    case time = "time"
    case taskCategory = "task_category"
    case taskType = "task_type"
    case members = "members"
    case profile = "profile"
    case home = "home"
    case track = "track"
    case challenges = "challenges"
    case changeTheme = "change_theme"
    case languagePreferences = "language_preferences"
    case contactSupport = "contact_support"
    case accountDetails = "account_details"
    case challengeStatistics = "challenge_statistics"
    case chooseTheme = "choose_theme"
    case dareToAchieve = "dare_to_achieve"
    
    case categoryAll = "category_all"
    case categoryGrocery = "category_grocery"
    case categoryPersonal = "category_personal"
    case categoryWork = "category_work"
    case categoryHealth = "category_health"
    case categoryEducation = "category_education"
    
    case priority = "priority"
    case priorityLow = "priority_low"
    case priorityMedium = "priority_medium"
    case priorityHigh = "priority_high"
    case priorityUrgent = "priority_urgent"
    
    case typeIndividual = "type_individual"
    case typeTeam = "type_team"
    
    case edit = "edit"
    case delete = "delete"
    case markAsDone = "mark_as_done"
    case markAsUndone = "mark_as_undone"
    case cancel = "cancel"
    case save = "save"
    case writeHere = "write_here"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

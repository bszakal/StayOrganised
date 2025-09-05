import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    let title: String
    let taskDescription: String?
    let category: TaskCategory
    let priority: TaskPriority
    let taskType: TaskType
    let dueDate: Date
    let isCompleted: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        taskDescription: String? = nil,
        category: TaskCategory = .personal,
        priority: TaskPriority = .medium,
        taskType: TaskType = .individual,
        dueDate: Date,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.category = category
        self.priority = priority
        self.taskType = taskType
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum TaskCategory: String, CaseIterable {
    case all = "all"
    case grocery = "grocery"
    case personal = "personal"
    case work = "work"
    case health = "health"
    case education = "education"
    
    var displayName: String {
        switch self {
        case .all: return LocalizedString.categoryAll.rawValue
        case .grocery: return LocalizedString.categoryGrocery.rawValue
        case .personal: return LocalizedString.categoryPersonal.rawValue
        case .work: return LocalizedString.categoryWork.rawValue
        case .health: return LocalizedString.categoryHealth.rawValue
        case .education: return LocalizedString.categoryEducation.rawValue
        }
    }
    
    var iconName: String {
        switch self {
        case .all: return "list.bullet"
        case .grocery: return "cart"
        case .personal: return "person"
        case .work: return "briefcase"
        case .health: return "heart"
        case .education: return "book"
        }
    }
}

enum TaskPriority: Int16, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    case urgent = 3
    
    var displayName: String {
        switch self {
        case .low: return LocalizedString.priorityLow.rawValue
        case .medium: return LocalizedString.priorityMedium.rawValue
        case .high: return LocalizedString.priorityHigh.rawValue
        case .urgent: return LocalizedString.priorityUrgent.rawValue
        }
    }
}

enum TaskType: String, CaseIterable {
    case individual = "individual"
    case team = "team"
    
    var displayName: String {
        switch self {
        case .individual: return LocalizedString.typeIndividual.rawValue
        case .team: return LocalizedString.typeTeam.rawValue
        }
    }
}

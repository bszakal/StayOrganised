import Foundation
@testable import StayOrganised

class CreateTaskViewModelFactoryMock: CreateTaskViewModelFactoryProtocol {
    
    // Callback that tests can set
    var createCreateTaskViewModelCallback: ((Task?) -> CreateTaskViewModel)?
    
    func createCreateTaskViewModel(task: Task?) -> CreateTaskViewModel {
        return createCreateTaskViewModelCallback?(task) ?? CreateTaskViewModel(coreDataManager: CoreDataManagerMock(), task: task)
    }
}
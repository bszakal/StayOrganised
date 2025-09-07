import Foundation
import CoreData
@testable import StayOrganised

class TaskParserMock: TaskParserProtocol {
    
    // Callbacks that tests can set
    var convertToBusinessModelCallback: ((TaskEntity) -> Task?)?
    var convertToCoreDataModelCallback: ((Task) -> TaskEntity?)?
    var updateCoreDataModelCallback: ((TaskEntity, Task) -> Void)?
    
    func convertToBusinessModel(_ entity: TaskEntity) -> Task? {
        return convertToBusinessModelCallback?(entity)
    }
    
    func convertToCoreDataModel(_ task: Task) -> TaskEntity? {
        return convertToCoreDataModelCallback?(task)
    }
    
    func updateCoreDataModel(_ entity: TaskEntity, with task: Task) {
        updateCoreDataModelCallback?(entity, task)
    }
}
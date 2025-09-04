import Foundation

protocol TaskParserProtocol {
    func convertToBusinessModel(_ entity: TaskEntity) -> Task?
    func convertToCoreDataModel(_ task: Task) -> TaskEntity?
    func updateCoreDataModel(_ entity: TaskEntity, with task: Task)
}
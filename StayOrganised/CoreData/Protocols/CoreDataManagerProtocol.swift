import Foundation
import Combine

protocol CoreDataManagerProtocol {
    var tasks: AnyPublisher<[Task], Never> { get }
    
    func createTask(_ task: Task) -> Bool
    func updateTask(_ task: Task) -> Bool
    func deleteTask(_ task: Task) -> Bool
    func toggleTaskCompletion(_ task: Task) -> Bool
}

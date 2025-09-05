//
//  TaskRowViewModel.swift
//  StayOrganised
//
//  Created by Benjamin Szakal on 04/09/2025.
//

import Foundation

class TaskRowViewModel {
    
    public let task: Task
    private let onTapCompletion: (Task) -> Void
    private let onToggleCompletion: (Task) -> Void
    private let onDeleteCompletion: (Task) -> Void
    
    init(task: Task,
         onTapCompletion: @escaping (Task) -> Void,
         onToggleComplete: @escaping (Task) -> Void,
         onDelete: @escaping (Task) -> Void) {
        
        self.task = task
        self.onTapCompletion = onTapCompletion
        self.onToggleCompletion = onToggleComplete
        self.onDeleteCompletion = onDelete
    }
    
    func onTap() {
        onTapCompletion(task)
    }
    
    func onToggle() {
        onToggleCompletion(task)
    }
    
    func onDelete() {
        onDeleteCompletion(task)
    }
}

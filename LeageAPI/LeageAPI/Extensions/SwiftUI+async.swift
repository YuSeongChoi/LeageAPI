//
//  SwiftUI+async.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import SwiftUI

private struct TaskModifier: ViewModifier {
    
    var priority: TaskPriority
    var action: @Sendable () async -> Void
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content
            .onDisappear {
                task?.cancel()
                task = nil
            }
            .onAppear {
                task?.cancel()
                task = Task(priority: priority, operation: action)
            }
    }
    
}

@available(iOS 14.0, *)
private struct TaskIdentityModifier<T:Equatable>: ViewModifier {
    
    var id: T
    var priority: TaskPriority
    var action: @Sendable () async -> Void
    @State private var task: Task<Void, Never>?
    
    func body(content: Content) -> some View {
        content.onChange(of: id) { newValue in
            task?.cancel()
            task = Task(priority: priority, operation: action)
        }
        .onDisappear {
            task?.cancel()
            task = Task(priority: priority, operation: action)
        }
        .onDisappear {
            task?.cancel()
            task = nil
        }
    }
    
}

public extension View {
    @ViewBuilder
    func async(priority: TaskPriority = .userInitiated, _ action: @Sendable @escaping () async -> Void) -> some View {
        if #available(iOS 15.0, *) {
            task(priority: priority, action)
        } else {
            modifier(TaskModifier(priority: priority, action: action))
        }
    }
}

@available(iOS 14.0, *)
public extension View {
    @ViewBuilder
    func async<T:Equatable>(id value: T, priority: TaskPriority = .userInitiated, _ action: @Sendable @escaping () async -> Void) -> some View {
        if #available(iOS 15.0, *) {
            task(id: value, priority: priority, action)
        } else {
            modifier(TaskIdentityModifier(id: value, priority: priority, action: action))
        }
    }
}


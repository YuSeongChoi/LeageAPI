//
//  TodoListViewModel.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import Alamofire

@MainActor
final class TodoListViewModel: ObservableObject, Identifiable {
    
    @Published var todoList: [Todo] = []
    
}

// MARK: - Request API
extension TodoListViewModel {
    
    func requestTodos() async throws {
        do {
            todoList = try await getTodos()
            print("todolsit : \(todoList)")
        } catch AFError.explicitlyCancelled {
            
        }
    }
    
}

// MARK: - APIs
extension TodoListViewModel {
    
    private func getTodos() async throws -> [Todo] {
        return try await HTTPRequestList.TodoRequest()
            .buildDataRequest()
            .serializingDecodable([Todo].self, automaticallyCancelling: true)
            .result.mapError{ $0.underlyingError ?? $0 }.get()
    }
    
}

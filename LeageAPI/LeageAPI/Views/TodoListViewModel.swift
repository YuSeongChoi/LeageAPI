//
//  TodoListViewModel.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import Foundation
import Alamofire
import Combine

@MainActor
final class TodoListViewModel: ObservableObject, Identifiable {
    
    @Published var todoList: [Todo] = []
    
    private var cancelBag = Set<AnyCancellable>()
    
}

// MARK: - Request API
extension TodoListViewModel {
    
    func requestTodos() async throws {
        do {
            todoList = try await getTodos()
            print("todolsit : \(todoList.count)")
        } catch AFError.explicitlyCancelled {
            
        }
    }

    func requestPost(userId: Int, id: Int) {
        HTTPRequestList.TodoPosts(userId: userId, id: id)
            .buildDataRequest()
            .publishDecodable(type: [Post].self, queue: .global())
            .value()
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                
            } receiveValue: { [unowned self] posts in
                print(posts)
            }.store(in: &cancelBag)
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

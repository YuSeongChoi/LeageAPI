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
            print("todolsit : \(todoList.count)")
        } catch AFError.explicitlyCancelled {
            
        }
    }
    
    func requestSummonerInfo(name: String) async throws {
        do {
            try await getSummonerInfo(name: name)
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
    
    private func getSummonerInfo(name: String) async throws {
        try await HTTPRequestList.UserDataRequest(summonerName: name)
            .buildDataRequest()
            .serializingData(automaticallyCancelling: true)
            .result.mapError{ $0.underlyingError ?? $0 }.get()
    }
    
}

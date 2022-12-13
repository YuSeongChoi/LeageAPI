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
    @Published var summonerInfo: SummonerInfo = SummonerInfo()
    
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
    
    func requestSummonerInfo(name: String) async throws {
        do {
            summonerInfo = try await getSummonerInfo(name: name)
            print("LCK summoner : \(summonerInfo)")
        } catch AFError.explicitlyCancelled {
            
        }
    }
    
    func requestSummoerInfo2(name: String) {
        Task {
            let result = await HTTPRequestList.UserDataRequest(summonerName: name)
                .buildDataRequest()
                .serializingData(automaticallyCancelling: true)
                .result
            switch result {
            case .failure(let error):
                print("ERROR! : \(error.localizedDescription)")
            case .success(_):
                print("")
            }
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
    
    
    private func getSummonerInfo(name: String) async throws -> SummonerInfo {
        try await HTTPRequestList.UserDataRequest(summonerName: name)
            .buildDataRequest()
//            .serializingData(automaticallyCancelling: true)
            .serializingDecodable(SummonerInfo.self, automaticallyCancelling: true)
            .result.mapError{ $0.underlyingError ?? $0 }.get()
    }
    
    func getChampionImage(name: String) async throws {
        try await HTTPRequestList.ChampionImageRequest(championName: name)
            .buildDataRequest()
            .serializingData(automaticallyCancelling: true)
            .result.mapError{ $0.underlyingError ?? $0 }.get()
    }
    
    func getItemList() async throws {
        try await HTTPRequestList.ItemListRequest()
            .buildDataRequest()
            .serializingData(automaticallyCancelling: true)
            .result.mapError{ $0.underlyingError ?? $0 }.get()
    }
    
}

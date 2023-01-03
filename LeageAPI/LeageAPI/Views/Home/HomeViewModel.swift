//
//  HomeViewModel.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/13.
//

import Foundation
import Combine

import Alamofire

@MainActor
final class HomeViewModel: ObservableObject, Identifiable {
    
    @Published var summonerInfo: SummonerInfo = SummonerInfo()
    @Published var summonerID: String = ""
    private var cancelBag = Set<AnyCancellable>()
    
}

// MARK: - Request API

extension HomeViewModel {
    
    func requestSummonerInfo(name: String) async throws {
        do {
            summonerInfo = try await getSummonerInfo(name: name)
            print("LCK summoner : \(summonerInfo)")
        } catch AFError.explicitlyCancelled {
            
        }
    }
    
    func requestSummonerInfo2(name: String) {
        Task {
            do {
                let result = await HTTPRequestList.UserDataRequest(summonerName: name)
                    .buildDataRequest()
                    .serializingDecodable(SummonerInfo.self, automaticallyCancelling: true)
    //                .serializingData(automaticallyCancelling: true)
                    .result
                switch result {
                case .success(let value):
                    print("VALUE : \(value)")
                case .failure(let error):
                    print("ERROR! : \(error.localizedDescription)")
                    throw error.underlyingError ?? error
                }
            } catch AFError.explicitlyCancelled {
                
            }
        }
    }
    
    func requestSummoerInfo3(name: String) {
        HTTPRequestList.UserDataRequest(summonerName: name)
            .buildDataRequest()
            .publishDecodable(type: SummonerInfo.self, queue: .global())
            .value()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [unowned self] value in
                print("VALUE : \(value)")
                summonerID = value.id
            }.store(in: &cancelBag)
    }
    
}

// MARK: - APIs

extension HomeViewModel {
    
    private func getSummonerInfo(name: String) async throws -> SummonerInfo {
        try await HTTPRequestList.UserDataRequest(summonerName: name)
            .buildDataRequest()
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

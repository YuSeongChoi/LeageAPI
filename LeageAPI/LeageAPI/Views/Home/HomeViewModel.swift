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
    
    var userInfo: UserInfo = {
        var userInfo = UserInfo()
        userInfo.userName = "DS Khan"
        userInfo.age = 32
        return userInfo
    }()
    
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
    //                .serializingData(automaticallyCancelling: true) 디코딩 안하고 반환
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

extension HomeViewModel {
    
    func basicRequest() {
        let params: Parameters = ["userName": "DS Khan", "age" : 20]
        
        AF.request("https://httpbin.org/post", method: .post, parameters: params)
            .responseDecodable(of: HttpbinResponse.self) { (response: DataResponse<HttpbinResponse, AFError>) -> Void in
                switch response.result {
                case .success(let value):
                    print("[RESPONSE]")
                    print(response.data?.toPrettyPrintedString)
                case .failure(let error):
                    print("API Failure")
                    print(error)
                }
            }
    }
    
    func getRequestByRouter() {
        let router = APIRouter(path: APIPath.getPractice, httpMethod: .get, parameters: userInfo.toData, apiType: .service)
        AF.request(router).responseDecodable(of: HttpbinResponse.self) { (response: DataResponse<HttpbinResponse, AFError>) -> Void in
            switch response.result {
            case .success(let value):
                print("[RESPONSE]")
                print("URL : \(value.url ?? "")")
                print("Response Data: \(response.data?.toPrettyPrintedString ?? "")")
            case .failure(let error):
                print("API Failure")
                print(error)
            }
        }
    }
    
    func postRequestByRouter() {
        let router = APIRouter(path: APIPath.postPractice, httpMethod: .post, parameters: userInfo.toData, apiType: .service)
        AF.request(router).responseDecodable(of: HttpbinResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("[RESPONSE]")
                print("URL : \(value.url ?? "")")
                print("json body: \(value.json ?? UserInfo())")
                print("Response Data : \(response.data?.toPrettyPrintedString ?? "")")
            case .failure(let error):
                print("API Failure")
                print(error)
            }
        }
    }
    
    func requestUsingSession() {
        let router = APIRouter(path: APIPath.postPractice, httpMethod: .post, parameters: userInfo.toData, apiType: .service)
        APIManager.shared.session.request(router).responseDecodable(of: HttpbinResponse.self) { response in
            print("LCK response : \(response.data?.toPrettyPrintedString)")
        }
    }
    
}

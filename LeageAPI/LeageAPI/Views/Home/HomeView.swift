//
//  HomeView.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/13.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var userNameField: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("유저명", text: $userNameField) {
                    Task {
                        do {
                            try await viewModel.requestSummonerInfo(name: userNameField)
                        } catch {
                            NetworkAlert.dismissNetworkAlert()
                        }
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await viewModel.requestSummonerInfo(name: userNameField)
                        } catch {
                            NetworkAlert.dismissNetworkAlert()
                        }
                    }
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            .border(R.color.veryLightPink.swiftColor, width: 1)
            
            
            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(height: 1)
                .foregroundColor(.gray)
        }
        .async {
            do {
                try await viewModel.requestChampionList()
            } catch  {
                await MainActor.run {
                    NetworkAlert.dismissNetworkAlert()
                }
            }
        }
    }
    
}

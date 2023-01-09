//
//  HomeView.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/13.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
//            Text("Home")
//            Text(viewModel.summonerID)
            DottedLine()
        }
        .onAppear {
//            viewModel.requestSummonerInfo2(name: "iOS KING")
            viewModel.requestSummoerInfo3(name: "Hide on Bush")
        }
    }
    
}

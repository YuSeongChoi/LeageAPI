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
                TextField("유저명", text: $userNameField)
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 16, leading: 20, bottom: 15, trailing: 20))
                    .border(R.color.veryLightPink.swiftColor, width: 1)
                    .background(Color.white)
                
                
            }
            
            
            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(height: 1)
                .foregroundColor(.gray)
        }
        .onAppear {
//            viewModel.requestSummonerInfo2(name: "iOS KING")
            viewModel.requestSummoerInfo3(name: "Hide on Bush")
        }
    }
    
}

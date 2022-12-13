//
//  TodoListView.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var viewModel = TodoListViewModel()
    
    @State private var dateToggle: Bool = false
    @State private var today: Date = Date()
    
    var body: some View {
        VStack {
            Button {
                dateToggle.toggle()
            } label: {
                Rectangle()
                    .fill(.green)
                    .frame(width: 250, height: 250)
            }
            .fullScreenCover(isPresented: $dateToggle) {
                DatePickerView(date: $today)
                    .ignoresSafeArea()
            }
            
        }
        .async {
            do {
//                try await viewModel.requestSummonerInfo(name: "iOS KING")
//                try await viewModel.getChampionImage(name: "Ezreal")
//                try await viewModel.getItemList()
            } catch {
                await MainActor.run {
                    NetworkAlert.dismissNetworkAlert()
                }
            }
        }
        .onAppear {
            viewModel.requestPost(userId: 1, id: 1)
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}


struct DatePickerView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var date: Date
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            VStack(spacing: 0) {
                Text("확인")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 63)
                //                .background(R.color.yellowOrange.swiftColor)
                    .background(Color.orange)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .background(Color.white)
                    .frame(height: 250)
                
            }
        }
    }
    
}

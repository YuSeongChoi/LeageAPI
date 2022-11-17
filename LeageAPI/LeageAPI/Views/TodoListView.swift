//
//  TodoListView.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var viewModel = TodoListViewModel()
    
    var body: some View {
        VStack {
            Text("TODO LIST")
        }
        .async {
            do {
                try await viewModel.requestTodos()
            } catch {
                await MainActor.run {
                    NetworkAlert.dismissNetworkAlert()
                }
            }
        }
        
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}

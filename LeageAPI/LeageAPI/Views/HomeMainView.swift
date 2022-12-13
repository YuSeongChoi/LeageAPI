//
//  HomeMainView.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/12/13.
//

import SwiftUI

struct HomeMainView: View {
    
    typealias TabItemType = Constants.HomeTabItem
    
    @State private var tabSelection: TabItemType = .Home
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView()
                .tag(TabItemType.Home)
                .tabItem {
                    Label("홈", systemImage: "house.fill")
                }
            ChampionView()
                .tag(TabItemType.Champion)
                .tabItem {
                    Label("챔피언", systemImage: "crown.fill")
                }
            SettingView()
                .tag(TabItemType.Setting)
                .tabItem {
                    Label("설정", systemImage: "gearshape")
                }
        }
    }
    
}

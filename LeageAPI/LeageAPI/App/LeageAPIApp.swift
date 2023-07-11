//
//  LeageAPIApp.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/16.
//

import SwiftUI

@main
struct LeageAPIApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    @MainActor
    init() {
        let barAppearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .white
            appearance.backButtonAppearance.normal.titleTextAttributes[.foregroundColor] = UIColor.clear
            appearance.buttonAppearance.normal.titleTextAttributes[.font] = UIFont.boldSystemFont(ofSize: 17)
            let inset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            let newIndicator = appearance.backIndicatorImage.withAlignmentRectInsets(inset).withTintColor(.black, renderingMode: .alwaysOriginal)
            let newTransition = appearance.backIndicatorTransitionMaskImage.withAlignmentRectInsets(inset).withTintColor(.black, renderingMode: .alwaysOriginal)
            appearance.setBackIndicatorImage(newIndicator, transitionMaskImage: newTransition)
            return appearance
        }()
        let naviProxy = UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self])
        naviProxy.standardAppearance = barAppearance
        naviProxy.barTintColor = .white
        naviProxy.tintColor = .black
    }
    
}

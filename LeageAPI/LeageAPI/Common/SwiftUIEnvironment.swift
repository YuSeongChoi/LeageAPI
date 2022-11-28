//
//  SwiftUIEnvironment.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2022/11/28.
//

import SwiftUI

struct SimpleViewRepresenter<SimpleView:UIView>: UIViewRepresentable {
    
    typealias UIViewType = SimpleView
    
    let view: @MainActor (Context) -> SimpleView
    var update: @MainActor (SimpleView, Context) -> () = { _, _ in }
    
    func makeUIView(context: Context) -> SimpleView {
        view(context)
    }
    
    func updateUIView(_ uiView: SimpleView, context: Context) {
        update(uiView, context)
    }
    
}

extension SimpleViewRepresenter {
    init(view: @MainActor @autoclosure @escaping () -> SimpleView, update: @MainActor @escaping (SimpleView, Context) -> () = { _, _ in }) {
        self.view = { _ in view() }
        self.update = update
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.background(SimpleViewRepresenter{ _ in
            let view = UIView()
            Task { @MainActor in
                view.superview?.superview?.backgroundColor = nil
            }
            return view
        })
    }
    
}

extension View {
    
    func clearModalBackground() -> some View {
        modifier(ClearBackgroundViewModifier())
    }
    
}

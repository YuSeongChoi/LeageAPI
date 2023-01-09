//
//  DottedLine.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/01/09.
//

import SwiftUI

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

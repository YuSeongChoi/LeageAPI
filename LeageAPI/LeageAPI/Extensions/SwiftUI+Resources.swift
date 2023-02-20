//
//  SwiftUI+Resources.swift
//  LeageAPI
//
//  Created by YuSeongChoi on 2023/02/20.
//

import SwiftUI

import RswiftResources

public extension ImageResource {
    var swiftImage: SwiftUI.Image {
        .init(self)
    }
}

public extension ColorResource {
    var swiftColor: SwiftUI.Color {
        .init(self)
    }
}

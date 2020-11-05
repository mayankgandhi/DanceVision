//
//  BlurView.swift
//  Playground
//
//  Created by Mayank on 25/04/20.
//  Copyright © 2020 Mayank. All rights reserved.
//

import SwiftUI

public struct BlurView: UIViewRepresentable {
    public var style: UIBlurEffect.Style
    public var cornerRadius: CGFloat?
    
    public init(_ style: UIBlurEffect.Style, cornerRadius: CGFloat? = nil) {
        self.style = style
        self.cornerRadius = cornerRadius
    }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        if let cornerRadius = self.cornerRadius {
            uiView.clipsToBounds = true
            uiView.layer.cornerRadius = cornerRadius
        }
    }
}

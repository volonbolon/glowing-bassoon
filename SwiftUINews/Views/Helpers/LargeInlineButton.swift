//
//  LargeInlineButton.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI

struct LargeInlineButton: View {
    let title: String
    let color: Color = Color.blue
    let action: () -> Void
    
    var body: some View {
        Button(title, action: action)
            .scaleEffect(0.8)
            .font(.title)
            .frame(minWidth: 0,
                   idealWidth: 100,
                   maxWidth: .infinity,
                   minHeight: 0,
                   idealHeight: 60,
                   maxHeight: 60,
                   alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2))
            .padding(.leading, 40)
            .padding(.trailing, 40)
    }
}

struct LargeInlineButtonPreviews: PreviewProvider {
    static var previews: some View {
        LargeInlineButton(title: "Button", action: {})
            .previewLayout(.sizeThatFits)
    }
}

//
//  AddKeywordView.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI

struct AddKeywordView: View {
    @State var newKeyboard = ""
    let completed: (String) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 50, content: {
            Text("New keyboard")
                .font(.largeTitle)
                .padding(.top, 40)
            
            TextField("", text: $newKeyboard)
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2.0))
                .padding()
            
            LargeInlineButton(title: "Add keyword") {
                guard !self.newKeyboard.isEmpty else {
                    return
                }
                self.completed(self.newKeyboard)
                self.newKeyboard = ""
            }
        })
    }
}

struct AddKeywordViewPreviews: PreviewProvider {
    static var previews: some View {
        AddKeywordView(completed: {_ in })
    }
}

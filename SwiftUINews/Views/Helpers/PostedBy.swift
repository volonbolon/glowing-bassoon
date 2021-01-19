//
//  PostedBy.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI

struct PostedBy: View {
    let time: TimeInterval
    let user: String
    let currentDate: Date
    
    private static var relativeFormatter = RelativeDateTimeFormatter()
    
    private var relativeTimeString: String {
        return PostedBy.relativeFormatter.localizedString(fromTimeInterval: time - currentDate.timeIntervalSince1970)
    }
    
    var body: some View {
        Text("\(relativeTimeString) by \(user)")
            .font(.headline)
            .foregroundColor(Color.gray)
    }
}

struct PostedByPreviews: PreviewProvider {
    static var previews: some View {
        PostedBy(time: Date().timeIntervalSince1970 - 180,
                 user: "Someone",
                 currentDate: Date())
            .previewLayout(.sizeThatFits)
    }
}

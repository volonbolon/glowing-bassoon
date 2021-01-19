//
//  TimeBadge.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI

struct TimeBadge: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        
        return f
    }()
    
    let time: TimeInterval
    
    var body: some View {
        Text(TimeBadge.formatter.string(from: Date(timeIntervalSince1970: time)))
            .font(.headline)
            .fontWeight(.heavy)
            .padding(10)
            .foregroundColor(Color.white)
            .background(self.colorScheme == .light ? Color.blue : Color.orange)
            .cornerRadius(6)
            .frame(idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .padding(.bottom, 10)
    }
}

struct TimeBadgePreviews: PreviewProvider {
    static var previews: some View {
        TimeBadge(time: Date().timeIntervalSince1970)
    }
}

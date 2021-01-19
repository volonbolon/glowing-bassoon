//
//  StoryItem.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI
import SwiftUINewsKit

struct StoryItem: View {
    let story: Story
    @Binding var currentDate: Date
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            TimeBadge(time: story.time)
            
            Text(story.title)
                .frame(maxHeight: 100, alignment: .leading)
                .font(.title)
            
            PostedBy(time: story.time, user: story.by, currentDate: currentDate)
            
            StoryItemButton(story: story, activeSheet: $activeSheet)
        })
    }
}

struct StoryItemButton: View {
    let story: Story
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        Button(story.url) {
            activeSheet = .selectedStory(story)
        }
        .font(.subheadline)
        .foregroundColor(.blue)
        .padding(.top, 6)
    }
}

//
//  ReaderView.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI
import SwiftUINewsKit

enum ActiveSheet: Identifiable {
    case settings
    case selectedStory(Story)
    
    var id: Int {
        switch self {
        case .settings:
            return 1
        case .selectedStory(_):
            return 2
        }
    }
}

struct ReaderView: View {
    @State var activeSheet: ActiveSheet?
    @State var currentDate = Date()
    
    @EnvironmentObject var settings: Settings
    
    @ObservedObject var model: ReaderViewModel
    
    private let timer = Timer.publish(every: 10,
                                      on: .main,
                                      in: .common)
      .autoconnect()
      .eraseToAnyPublisher()
    
    init(model: ReaderViewModel) {
        self.model = model
        
        self.model.fetchStories()
    }
    
    var body: some View {
        let keywords = self.settings.keywords.map { $0.value}.joined(separator: " ")
        let filter = keywords
        NavigationView {
            List {
                Section(header: Text(filter).padding(.leading, -10)) {
                    ForEach(self.model.allStories) { story in
                        StoryItem(story: story, currentDate: $currentDate, activeSheet: $activeSheet)
                    }
                    .onReceive(timer) {
                        self.currentDate = $0
                    }
                }.padding()
            }
            .sheet(item: $activeSheet, content: { (item: ActiveSheet) -> AnyView in
                switch item {
                case .settings:
                    return AnyView(SettingsView())
                case .selectedStory(let story):
                    guard let url = URL(string: story.url) else {
                        return AnyView(Text("NO URL"))
                    }
                    return AnyView(SafariView(url: url))
                }
            })
            .alert(item: $model.error, content: { (error) -> Alert in
                Alert(
                    title: Text("Network error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .cancel()
                )
            })
            .navigationBarTitle(Text("\(model.allStories.count) Stories"))
            .navigationBarItems(trailing: Button("Settings") {
                                        self.activeSheet = ActiveSheet.settings
                                    }
            )
        }
    }
}

#if DEBUG
struct ReaderViewPreviews: PreviewProvider {
    static var previews: some View {
        ReaderView(model: ReaderViewModel())
    }
}
#endif

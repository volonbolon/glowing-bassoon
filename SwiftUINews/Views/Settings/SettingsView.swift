//
//  SettingsView.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import SwiftUI
import SwiftUINewsKit

fileprivate struct SettingsBarItem {
    let add: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 20, content: {
            Button(action: add, label: {
                Image(systemName: "plus")
            })
            EditButton()
        })
    }
}

struct SettingsView: View {
    @State var presentingAddKeywordSheet = false
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        
        return NavigationView {
            List {
                Section(header: Text("Filter keywords")) {
                    ForEach(settings.keywords) { keyword in
                        HStack(alignment: .top) {
                            Image(systemName: "star")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .scaleEffect(0.67)
                                .background(Color.yellow)
                                .cornerRadius(5)
                            Text(keyword.value)
                        }
                    }
                    .onMove(perform: moveKeyword)
                    .onDelete(perform: deleteKeyword)
                }
            }
            .sheet(isPresented: $presentingAddKeywordSheet, content: { () -> AddKeywordView in
                AddKeywordView(completed: { newKeyword in
                    let new = FilterKeyword(value: newKeyword)
                    self.settings.keywords.append(new)
                    self.presentingAddKeywordSheet = false
                })
            })
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(trailing: HStack(alignment: .center, spacing: 20, content: {
                Button(action: addKeyword, label: {
                    Image(systemName: "plus")
                })
                EditButton()
            }))
        }
    }
    
    private func moveKeyword(from source: IndexSet, to destination: Int) {
        guard let source = source.first, destination != settings.keywords.endIndex else {
            return
        }
        let destIndex = source > destination ? destination : destination - 1
        settings.keywords.swapAt(source, destIndex)
    }
    
    private func deleteKeyword(at index: IndexSet) {
        settings.keywords.remove(at: index.first!)
    }
    
    private func addKeyword() {
        presentingAddKeywordSheet = true
    }
}

struct SettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

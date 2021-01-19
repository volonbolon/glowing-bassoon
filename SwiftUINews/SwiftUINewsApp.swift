//
//  SwiftUINewsApp.swift
//  SwiftUINews
//
//  Created by Ariel Rodriguez on 15/01/2021.
//

import SwiftUI
import SwiftUINewsKit
import Combine
import VolonbolonKit

@main
struct SwiftUINewsApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    private var subscriptions = Set<AnyCancellable>()
    private let model = ReaderViewModel()
    private let settings = Settings()
    
    init() {
        setUpSettings()
    }

    var body: some Scene {
        WindowGroup {
            ReaderView(model: model)
                .environmentObject(settings)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                loadSettings()
            case .inactive:
                saveSettings()
            case .background:
                print("background")
            @unknown default:
                fatalError("Unexpected value")
            }
        }
    }
}

private extension SwiftUINewsApp {
    mutating func setUpSettings() {
        settings.$keywords
            .map { $0.map { $0.value }}
            .assign(to: \.filter, on: model)
            .store(in: &subscriptions)
    }
    
    func loadSettings() {
        do {
            let keywords: [FilterKeyword]  = try VolonbolonKit.FileIOHelper.loadValue(named: "Settings")
            settings.keywords = keywords
            print(keywords)
        } catch {
            print(error)
        }
    }
    
    func saveSettings() {
        do {
            let keywords = settings.keywords
            try VolonbolonKit.FileIOHelper.save(value: keywords, named: "Settings")
        } catch {
            print(error)
        }
    }
}

//
//  ReaderViewModel.swift
//  SwiftUINewsKit
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import Foundation
import Combine

public class ReaderViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    let apiClient = APIClient()
    
    @Published public var error: APIClient.Error? = nil
    @Published public var allStories: [Story] = []
    @Published public var filter: [String] = []
    
    public init() {}
    
    public func fetchStories() {
        apiClient
            .stories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            }) { (stories) in
                self.allStories = stories
                self.error = nil
            }
            .store(in: &subscriptions)
    }
}

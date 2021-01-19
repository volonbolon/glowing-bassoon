//
//  APIClient.swift
//  SwiftUINewsKit
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import Foundation
import Combine
import VolonbolonKit

public struct APIClient {
    public enum Error {
        case addressUnreachable(URL)
        case invalidResponse
    }
    
    let apiQueue = DispatchQueue(label: "Parsing",
                                 qos: .default,
                                 attributes: .concurrent)
    private let apiManager: APIManager
    private let decoder = JSONDecoder()
    
    public init(manager: APIManager = VolonbolonKit.Networking.Manager.init()) {
        self.apiManager = manager
    }
    
    public func  story(id: Int) -> AnyPublisher<Story, APIClient.Error> {
        let urlString = "https://hacker-news.firebaseio.com/v0/item/\(id).json"
        guard let url = URL(string: urlString) else {
            fatalError("Unable to produce story url")
        }
        return apiManager.loadData(from: url)
            .receive(on: apiQueue)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
    
    internal func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, APIClient.Error> {
        precondition(!storyIDs.isEmpty)
        
        let storyIDs = Array(storyIDs.prefix(10))
        
        let initialPublisher = story(id: storyIDs[0])
        let remainder = Array(storyIDs.dropFirst())
        
        return remainder
            .reduce(initialPublisher) { (combined, id) -> AnyPublisher<Story, Error> in
                return combined.merge(with: story(id: id))
                    .eraseToAnyPublisher()
            }
    }
    
    public func stories() -> AnyPublisher<[Story], APIClient.Error> {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json") else {
            fatalError("Unable to get the URL")
        }
        let apiQueue = DispatchQueue(label: "Parsing",
                                     qos: .default,
                                     attributes: .concurrent)
        
        return apiManager.loadData(from: url)
            .receive(on: apiQueue)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { error -> APIClient.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(url)
                default:
                    return Error.invalidResponse
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { storyIDs in
                return self.mergedStories(ids: storyIDs)
            }
            .scan([], { (stories, story) -> [Story] in
                return stories + [story]
            })
            .map { stories in
                return stories.sorted()
            }
            .eraseToAnyPublisher()
    }
}

extension APIClient.Error: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Unable to parse response"
        case .addressUnreachable(let url):
            return "Unable to reach \(url.absoluteURL)"
        }
    }
}

extension APIClient.Error: Identifiable {
    public var id: String {
        return localizedDescription
    }
}

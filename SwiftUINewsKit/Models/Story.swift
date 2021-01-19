//
//  Story.swift
//  SwiftUINewsKit
//
//  Created by Ariel Rodriguez on 15/01/2021.
//

import Foundation

public struct Story: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let by: String
    public let time: TimeInterval
    public let url: String
    
    public init(id: Int,
         title: String,
         by: String,
         time: TimeInterval,
         url: String) {
        self.id = id
        self.title = title
        self.by = by
        self.time = time
        self.url = url
    }
}

extension Story: Comparable {
    public static func <(lhs: Story, rhs: Story) -> Bool {
        return lhs.time > rhs.time
    }
}

extension Story: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\n\(title)\nby \(by)\n\(url)\n-----"
    }
}

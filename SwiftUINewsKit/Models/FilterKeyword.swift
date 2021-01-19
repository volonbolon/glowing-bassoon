//
//  FilterKeyword.swift
//  SwiftUINewsKit
//
//  Created by Ariel Rodriguez on 16/01/2021.
//

import Foundation

public struct FilterKeyword: Identifiable, Codable {
    public var id: String {
        value
    }
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
}

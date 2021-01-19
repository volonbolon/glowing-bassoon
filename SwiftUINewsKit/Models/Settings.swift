//
//  Settings.swift
//  SwiftUINewsKit
//
//  Created by Ariel Rodriguez on 18/01/2021.
//

import SwiftUI

final public class Settings: ObservableObject {
    public init() {}
    
    @Published public var keywords: [FilterKeyword] = []
}

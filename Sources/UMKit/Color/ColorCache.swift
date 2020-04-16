//
//  ColorCache.swift
//  UMKit
//
//  Created by brennobemoura on 16/04/20.
//

import Foundation

class ColorCache {
    private static weak var weakShared: Cache<String, UMColor>!
    static var shared: Cache<String, UMColor> {
        if let shared = self.weakShared {
            return shared
        }

        let shared = Cache<String, UMColor>()
        self.weakShared = shared
        return shared
    }
}

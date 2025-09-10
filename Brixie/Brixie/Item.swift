//
//  Item.swift
//  Brixie
//
//  Created by Matthias Wallner-Géhri on 10.09.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

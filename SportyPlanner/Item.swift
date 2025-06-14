//
//  Item.swift
//  SportyPlanner
//
//  Created by Florian Merlau on 14.06.25.
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

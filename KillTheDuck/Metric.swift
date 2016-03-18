//
//  Metric.swift
//  KillTheDuck
//
//  Created by Cédric Wider on 18/03/16.
//  Copyright © 2016 Cédric Wider. All rights reserved.
//

import Foundation

class Metric {
    var name : String
    var endpoint : String
    
    init(name: String, endpoint: String) {
        self.name = name
        self.endpoint = endpoint
    }
}
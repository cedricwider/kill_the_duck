//
//  System.swift
//  KillTheDuck
//
//  Created by Cédric Wider on 18/03/16.
//  Copyright © 2016 Cédric Wider. All rights reserved.
//

import Foundation

class System {
    
    enum Status : String {
        case OK = "okay",
            WARNING = "warning",
            ERROR = "error"
    }
    
    var status : Status
    var name : String
    
    init(state : String, name: String) {
        self.name = name
        if let state = Status(rawValue: state) {
            self.status = state
        } else {
            self.status = .ERROR
        }
    }
    
    init(status: Status, name: String) {
        self.name = name
        self.status = status
    }
}


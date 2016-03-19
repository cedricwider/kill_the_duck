//
//  SystemTest.swift
//  KillTheDuck
//
//  Created by Cédric Wider on 19/03/16.
//  Copyright © 2016 Cédric Wider. All rights reserved.
//

import XCTest
@testable import KillTheDuck

class SystemTest : XCTestCase {
    
    func testCreateWithOkayResponse() {
        // given
        let statusString = "okay"
        
        // when
        let system = System(state: statusString, name: "XCTest")
        
        // then
        XCTAssertEqual(System.Status.OK, system.status)
    }
    
}

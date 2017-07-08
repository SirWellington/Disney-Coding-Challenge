//
//  PugMeAPITests.swift
//  DisneyCodingChallenge
//
//  Created by Wellington Moreno on 7/7/17.
//  Copyright © 2017 Disney, Inc. All rights reserved.
//

import Foundation
@testable import DisneyCodingChallenge
import XCTest

class PugMeAPITests: XCTestCase {
    
    
    func testAPICall() {
        
        let promise = expectation(description: "Pugs come back")
        
        PugMeAPI.loadPugs() { pugs in
            
            LOG.info("Promise has been fulfilled and \(pugs.count) pugs have been loaded")
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 3000, handler: nil)
        
    }
    
    func testStripNumber() {
        
        let url = "http://27.media.tumblr.com/tumblr_lit0fgki1Z1qfh1tao1_500.jpg"
        let expected = "http://media.tumblr.com/tumblr_lit0fgki1Z1qfh1tao1_500.jpg"
        
        let result = PugMeAPI.stripNumber(url: url)
        XCTAssertEqual(result, expected)
    }
    
    func testLoadingData() {
        
        let first = URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/7f/Pug_portrait.jpg")!
        let second = URL(string: "https://media.tumblr.com/tumblr_lsvcpxVBgd1qzgqodo1_500.jpg")!
        
        var data = try! Data(contentsOf: first)
        
        do {
            data = try Data(contentsOf: second)
        } catch let ex {
            LOG.error("Failed to load URL \(second) | \(ex)")
        }
        
    }
}

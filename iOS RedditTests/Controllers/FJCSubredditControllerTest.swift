//
//  FJCSubredditControllerTest.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit
import XCTest


class FJCSubredditControllerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        LSNocilla.sharedInstance().start()
    }
    
    override func tearDown() {
        LSNocilla.sharedInstance().stop()
        
        super.tearDown()
    }
    
    
    func testCategory() {
        
        XCTAssertEqual(FJCSubredditController.Category.fromInt(0), .Hot, "0 != .Hot")
        XCTAssertEqual(FJCSubredditController.Category.fromInt(1), .New, "1 != .New")
        XCTAssertEqual(FJCSubredditController.Category.fromInt(2), .Top, "2 != .Top")
        
        XCTAssertEqual(FJCSubredditController.Category.fromInt(45), .Hot, "45 != .Hot")
        XCTAssertEqual(FJCSubredditController.Category.fromInt(-2), .Hot, "-2 != .Hot")
        
    }
    
    
    func testThatHTTPFailsCorrectly() {
        let expectation = expectationWithDescription("Did complete")
        
        let stubbedError = NSError(domain: "foo", code: 404, userInfo: [NSLocalizedDescriptionKey: "bar"])
        stubRequest("GET", "https://reddit.com/r/ios/hot.json").andFailWithError(stubbedError)
        
        
        FJCSubredditController.GETiOSListingForCategory(.Hot) { (listing, error) -> () in
            
            XCTAssertNil(listing, "\(listing)")
            XCTAssertEqual(error!, stubbedError, "\(error) != \(stubbedError)")
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    
    func testThatJSONParserFailsCorrectly() {
        
        let expectation = expectationWithDescription("Did complete")
        
        stubRequest("GET", "https://reddit.com/r/ios/hot.json").andReturnRawResponse("foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        
        
        FJCSubredditController.GETiOSListingForCategory(.Hot) { (listing, error) -> () in
            
            XCTAssertNil(listing, "\(listing)")
            XCTAssertNotNil(error, "\(error)")
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    
    func testThatItSucceeds() {
        
        let expectation = expectationWithDescription("Did complete")
        
        let mockFilePath = NSBundle(forClass: FJCSubredditListingTest.self).pathForResource("mock", ofType: "json")
        stubRequest("GET", "https://reddit.com/r/ios/hot.json").andReturnRawResponse(NSData(contentsOfFile: mockFilePath!))
        
        
        FJCSubredditController.GETiOSListingForCategory(.Hot) { (listing, error) -> () in
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            XCTAssertNil(error, "\(error)")
            XCTAssertNotNil(listing, "\(listing)")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    
    func testCategoryRouting() {
        
        // Hot Category
        let hotExpectation = expectationWithDescription("Did complete hot")
        
        let hotStubbedError = NSError(domain: "foo", code: 404, userInfo: [NSLocalizedDescriptionKey: "bar"])
        stubRequest("GET", "https://reddit.com/r/ios/hot.json").andFailWithError(hotStubbedError)
        
        
        FJCSubredditController.GETiOSListingForCategory(.Hot) { (listing, error) -> () in
            
            XCTAssertNil(listing, "\(listing)")
            XCTAssertEqual(error!, hotStubbedError, "\(error) != \(hotStubbedError)")
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            hotExpectation.fulfill()
        }
        
        
        // New Category
        let newExpectation = expectationWithDescription("Did complete new")
        
        let newStubbedError = NSError(domain: "foo", code: 303, userInfo: [NSLocalizedDescriptionKey: "bar"])
        stubRequest("GET", "https://reddit.com/r/ios/new.json").andFailWithError(newStubbedError)
        
        
        FJCSubredditController.GETiOSListingForCategory(.New) { (listing, error) -> () in
            
            XCTAssertNil(listing, "\(listing)")
            XCTAssertEqual(error!, newStubbedError, "\(error) != \(newStubbedError)")
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            newExpectation.fulfill()
        }
        
        
        // Top Category
        let topExpectation = expectationWithDescription("Did complete top")
        
        let topStubbedError = NSError(domain: "foo", code: 505, userInfo: [NSLocalizedDescriptionKey: "bar"])
        stubRequest("GET", "https://reddit.com/r/ios/top.json").andFailWithError(topStubbedError)
        
        
        FJCSubredditController.GETiOSListingForCategory(.Top) { (listing, error) -> () in
            
            XCTAssertNil(listing, "\(listing)")
            XCTAssertEqual(error!, topStubbedError, "\(error) != \(topStubbedError)")
            
            XCTAssertTrue(NSThread.isMainThread(), "Not on main queue")
            
            topExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
}

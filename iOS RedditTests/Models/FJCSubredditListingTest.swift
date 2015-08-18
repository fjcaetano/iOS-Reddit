//
//  FJCSubredditListingTest.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit
import XCTest


class FJCSubredditListingTest: XCTestCase {

    func testConstructorContract() {
        var result: FJCSubredditListing?
        
        // Nil Parameters
        result = FJCSubredditListing(jsonObject: NSDictionary())
        XCTAssertNotNil(result, "\(result)")
        
        
        // Partial Parameters
        let name = "foo"
        result = FJCSubredditListing(jsonObject: ["title": name])
        XCTAssertNotNil(result, "\(result)")
        XCTAssertNotNil(result!.name, "\(result!.name)")
        XCTAssertEqual(result!.name!, name, "\(result!.name) != \(name)")
        
        let author = "bar"
        result = FJCSubredditListing(jsonObject: ["author": author])
        XCTAssertNotNil(result, "\(result)")
        XCTAssertNotNil(result!.authorName, "\(result!.authorName)")
        XCTAssertEqual(result!.authorName!, author, "\(result!.authorName) != \(author)")
        
        let url = "xpto"
        result = FJCSubredditListing(jsonObject: ["thumbnail": url])
        XCTAssertNotNil(result, "\(result)")
        XCTAssertNotNil(result!.thumbURL, "\(result!.thumbURL)")
        XCTAssertEqual(result!.thumbURL!.absoluteString!, url, "\(result!.thumbURL) != \(url)")
        
        
        // Complete Parameters
        result = FJCSubredditListing(jsonObject: ["title": name, "author": author, "thumbnail": url])
        XCTAssertNotNil(result, "\(result)")
        XCTAssertNotNil(result!.name, "\(result!.name)")
        XCTAssertNotNil(result!.authorName, "\(result!.authorName)")
        XCTAssertNotNil(result!.thumbURL, "\(result!.thumbURL)")
        
        XCTAssertEqual(result!.name!, name, "\(result!.name) != \(name)")
        XCTAssertEqual(result!.authorName!, author, "\(result!.authorName) != \(author)")
        XCTAssertEqual(result!.thumbURL!.absoluteString!, url, "\(result!.thumbURL) != \(url)")
    }

}

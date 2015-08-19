//
//  UIImageView+FJCAsyncTest.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class UIImageView_FJCAsyncTest: XCTestCase {
    
    let url = "http://foo.com"
    var stubbedImageData: NSData!

    override func setUp() {
        super.setUp()
        
        LSNocilla.sharedInstance().start()
    
        let stubbedImage = _imageWithColor(UIColor.blackColor())
        stubbedImageData = UIImagePNGRepresentation(stubbedImage)
        
        stubRequest("GET", url).andReturnRawResponse(stubbedImageData)
    }
    
    override func tearDown() {
        LSNocilla.sharedInstance().stop()
        
        super.tearDown()
    }

    func testThatItFailsCorrectly() {
        var imageView = UIImageView()
        
        imageView.FJC_setImageWithURL(nil, placeholder: nil)
        XCTAssertNil(imageView.image, "\(imageView.image)")
        
        imageView.FJC_setImageWithURL(NSURL(string: "an invalid url"), placeholder: nil)
        XCTAssertNil(imageView.image, "\(imageView.image)")
        
        
        // Nil URL with placeholder
        let mockImage = UIImage()
        imageView.FJC_setImageWithURL(nil, placeholder: mockImage)
        XCTAssertEqual(imageView.image!, mockImage, "\(imageView.image) != \(mockImage)")
    }
    
    func testValidURLAndNilPlaceholder() {
        var imageView = UIImageView()
        
        var expectation = expectationWithDescription("Did complete")
        
        
        // Valid URL with nil placeholder
        imageView.FJC_setImageWithURL(NSURL(string: url), placeholder: nil) { (data, image, error) -> () in
            
            XCTAssertNil(imageView.image, "\(imageView.image)")
            
            XCTAssertEqual(data!, self.stubbedImageData, "\(data) != \(self.stubbedImageData)")
            
            expectation.fulfill()
        }
    
        XCTAssertNil(imageView.image, "\(imageView.image)")
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testValidURLAndPlaceholder() {
        var imageView = UIImageView()
        let mockImage = UIImage()
        
        var expectation = expectationWithDescription("Did complete")
        
        // Valir URL with placeholder
        imageView.FJC_setImageWithURL(NSURL(string: url), placeholder: mockImage) { (data, image, error) -> () in
            
            XCTAssertEqual(imageView.image!, mockImage, "\(imageView.image) != \(mockImage)")
            
            XCTAssertEqual(data!, self.stubbedImageData, "\(data) != \(self.stubbedImageData)")
            
            expectation.fulfill()
        }
        
        XCTAssertEqual(imageView.image!, mockImage, "\(imageView.image) != \(mockImage)")
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
    
// MARK: - Private Functions

private func _imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
}

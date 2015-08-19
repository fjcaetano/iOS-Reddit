//
//  FJCSubredditController.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit


typealias FJCCompletionClosure = (listing: [FJCSubredditListing]?, error: NSError?) -> ()


class FJCSubredditController: NSObject {
   
    enum Category: String {
        case Hot = "hot"
        case New = "new"
        case Top = "top"
        
        static func fromInt(let idx: Int) -> Category {
            switch idx {
            case 1:
                return .New
                
            case 2:
                return .Top
                
            default:
                return .Hot
            }
        }
    }
    
    // MARK: - Properties
    
    private static let _processorQueue = dispatch_queue_create("com.flaviocaetano.Reddit", DISPATCH_QUEUE_CONCURRENT)
    
    
    // MARK: - Methods
    
    class func GETiOSListingForCategory(category: Category, completion: FJCCompletionClosure) -> NSURLSessionDataTask?
    {
        // Dispatch completion on main queue
        let safeCompletion: FJCCompletionClosure = { (listing, error) -> () in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                completion(listing: listing, error: error)
                
            }
            
        }
        
        
        let url = NSURL(string: "https://reddit.com/r/ios/\(category.rawValue).json")!
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            dispatch_async(self._processorQueue) {
                
                if let safeError = error {
                    safeCompletion(listing: nil, error: safeError)
                    
                    return
                }
                
                // Parsing JSON response
                var jsonError: NSError?
                let jsonObj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as? NSDictionary
                
                
                if let safeError = jsonError {
                    safeCompletion(listing: nil, error: safeError)
                    
                    return
                }
                
                
                // To be sent to success closure
                var result = [FJCSubredditListing]()
                
                if let childrenJson = jsonObj?.valueForKeyPath("data.children.data") as? Array<NSDictionary> {
                    result = childrenJson.map { (var json) -> FJCSubredditListing in
                        
                        FJCSubredditListing(jsonObject: json)
                        
                    }
                }
                
                
                // Dispatching completion
                safeCompletion(listing: result, error: nil)
                
            }
            
        }
        
        dataTask.resume()
        
        return dataTask
    }
}

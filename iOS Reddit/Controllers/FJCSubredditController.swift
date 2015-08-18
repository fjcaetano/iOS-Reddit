//
//  FJCSubredditController.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit


typealias FJCSuccessClosure = ([FJCSubredditListing]!) -> ()
typealias FJCFailureClosure = (NSError!) -> ()


class FJCSubredditController: NSObject {
   
    enum FJCSubredditCategory: String {
        case Hot = "hot"
        case New = "new"
        case Top = "top"
    }
    
    // mark - Properties
    
    private static let _processorQueue = dispatch_queue_create("com.flaviocaetano.Nubank", DISPATCH_QUEUE_CONCURRENT)
    
    
    // mark - Methods
    
    class func GETiOSListingForCategory(category: FJCSubredditCategory, success: FJCSuccessClosure?, failure:FJCFailureClosure?) -> NSURLSessionDataTask?
    {
        if success == nil && failure == nil {
            return nil
        }
        
        let url = NSURL(string: "https://reddit.com/r/ios/\(category).json")!
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            dispatch_async(self._processorQueue) {
                
                if let safeError = error {
                    // Dispatch failure on main queue
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        failure?(safeError)
                        
                    }
                    
                    return
                }
                
                // Parsing JSON response
                var jsonError: NSError?
                let jsonObj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as? NSDictionary
                
                
                if let safeError = jsonError {
                    // Dispatch failure on main queue
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        failure?(safeError)
                        
                    }
                    
                    return
                }
                
                
                // To be sent to success closure
                var result = [FJCSubredditListing]()
                
                if let childrenJson = jsonObj?.valueForKeyPath("data.children") as? Array<NSDictionary> {
                    result = childrenJson.map { (var json) -> FJCSubredditListing in
                        
                        FJCSubredditListing(jsonObject: json)
                        
                    }
                }
                
                
                
                // Dispatch success on main queue
                dispatch_async(dispatch_get_main_queue()) {
                    
                    success?(result)
                    
                }
                
            }
            
        }
        
        dataTask.resume()
        
        return dataTask
    }
}

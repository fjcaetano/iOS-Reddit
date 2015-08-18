//
//  FJCSubredditListing.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit


class FJCSubredditListing: NSObject
{
    
    var name: String
    var authorName: String
    
    var thumbURL: NSURL?
    
    // MARK: - Methods
    
    init(jsonObject: NSDictionary)
    {
        name = jsonObject["title"] as! String
        authorName = jsonObject["author"] as! String
        
        if let thumbnailStringURL = jsonObject["thumbnail"] as? String {
            thumbURL = NSURL(string: thumbnailStringURL)
        }
    }
   
}

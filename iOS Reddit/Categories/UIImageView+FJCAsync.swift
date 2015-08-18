//
//  UIImageView+FJCAsync.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
private var _dataTaskHandle: UInt8 = 0


extension UIImageView {
    
    private static let _processorQueue = dispatch_queue_create("com.flaviocaetano.Reddit.img", DISPATCH_QUEUE_CONCURRENT)
    
    private var dataTask: NSURLSessionDataTask?  {
        get {
            return objc_getAssociatedObject(self, &_dataTaskHandle) as? NSURLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &_dataTaskHandle, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    func FJC_setImageWithURL(url: NSURL?, placeholder: UIImage?) {
        image = placeholder
        
        if let safeURL = url {
            dataTask?.cancel()
            
            
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(safeURL) { (data, response, error) -> Void in
                
                if let newImage = UIImage(data: data) {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.image = newImage
                        
                    }
                    
                }
            }
            
            dataTask?.resume()
        }
    }
    
}

//
//  FJCMainTableViewController.swift
//  iOS Reddit
//
//  Created by Flávio Caetano on 8/18/15.
//  Copyright (c) 2015 Flávio Caetano. All rights reserved.
//

import UIKit

class FJCMainTableViewController: UITableViewController {
    private struct Static {
        static let CellIdentifier = "Cell"
    }
    
    // Outlets
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    // Properties
    private var listingArray: [FJCSubredditListing]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding activity indicator to the tableview
        activityIndicatorView.center = tableView.center
        tableView.addSubview(activityIndicatorView)
        
        // Load initial data
        didChangeSegmented(segmentedControl)
    }
    
    // MARK: - UI Actions
    
    @IBAction func didChangeSegmented(sender: UISegmentedControl) {
     
        // Clearing the tableview
        listingArray = nil
        tableView.reloadData()
        activityIndicatorView.startAnimating()
        
        
        // Loading data
        let category = FJCSubredditController.Category.fromInt(sender.selectedSegmentIndex)
        FJCSubredditController.GETiOSListingForCategory(category) { (listing, error) -> () in
            
            self.activityIndicatorView.stopAnimating()
            
            if let safeError = error {
                let alertController = UIAlertController(title: "Erro", message: "Foo", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            self.listingArray = listing
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Static.CellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        cell.imageView?.contentMode = .ScaleAspectFit

        if let listing = listingArray?[indexPath.row] {
            cell.textLabel?.text = listing.name
            cell.detailTextLabel?.text = listing.authorName
            cell.imageView?.FJC_setImageWithURL(listing.thumbURL, placeholder: UIImage(named: "listingPlaceholder"))
        }

        return cell
    }

}

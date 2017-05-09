//
//  TwitterViewController.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/20/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterViewController: TWTRTimelineViewController {
    
    var lat = ""
    var long = ""
    var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Add a button to the center of the view to show the timeline
        
        print(lat, long)
        
        //Fabric Framework creates a guest client
        let client = TWTRAPIClient()
        
        //Fabric Framework searches for tweets with the specified query
        let ex = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: client)
        //ex.geocodeSpecifier = "\(lat),\(long),50mi" <- limits tweets to a certain radius, but I have to way of telling if no tweets were returned
        //ex.languageCode = "en" <- read-only get does not allow me to specify language for some reason
        
        //sets datasource for TwitterKit
        self.dataSource = ex
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

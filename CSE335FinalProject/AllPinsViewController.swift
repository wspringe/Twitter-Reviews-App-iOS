//
//  AllPinsViewController.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/20/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit
import CoreData


class AllPinsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pinTable: UITableView!
    
    var pinData:PinData = PinData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //tells tableview how many cells to use
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinData.fetchRecord()
    }
    
    //function to customize cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! PinTableViewCell
      
        
        cell.cellImage.image = UIImage(named: "pin.jpeg")
        cell.cellTitle.text = pinData.fetchResults[indexPath.row].title
        cell.cellSubtitle.text = pinData.fetchResults[indexPath.row].subtitle
        return cell
    }
    
    //tells mapview where to zoom in upon row press
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex: IndexPath = self.pinTable.indexPath(for: sender as! PinTableViewCell)!
        
        let lat = pinData.fetchResults[selectedIndex.row].lat
        let long = pinData.fetchResults[selectedIndex.row].long
        
        if(segue.identifier == "GoToPins"){
            if let ViewController: ViewController = segue.destination as? ViewController {
                ViewController.seguedLat = lat
                ViewController.seguedLong = long
            }
        }
    }
    
    //reloads tabledata
    @IBAction func reloadData(_ sender: Any) {
        pinTable.reloadData()
    }

}

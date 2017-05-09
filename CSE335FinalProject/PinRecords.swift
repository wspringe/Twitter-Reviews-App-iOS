//
//  PinRecords.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/21/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PinRecords: NSManagedObject
{
    @NSManaged var title:String
    @NSManaged var lat:Double
    @NSManaged var long:Double
    
    
}

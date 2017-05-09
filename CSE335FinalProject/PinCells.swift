//
//  PinCells.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/22/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.borderWidth = 0.5
        cellImage.layer.masksToBounds = false
        cellImage.layer.borderColor = UIColor.gray.cgColor
        cellImage.layer.cornerRadius = cellImage.frame.height/2
        cellImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


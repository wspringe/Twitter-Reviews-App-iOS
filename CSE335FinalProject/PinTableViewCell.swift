//
//  PinTableViewCell.swift
//  CSE335FinalProject
//
//  Created by Wesley Springer on 4/22/17.
//  Copyright © 2017 ASU. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.borderWidth = 0.5
        cellImage.layer.borderColor = UIColor.gray.cgColor
        cellImage.layer.masksToBounds = false
        cellImage.layer.cornerRadius = cellImage.frame.height/2
        cellImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

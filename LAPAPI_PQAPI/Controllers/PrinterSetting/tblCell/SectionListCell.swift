//
//  SectionListCell.swift
//  BaplsID
//
//  Created by Ahmad's MacMini on 25/01/23.
//  Copyright © 2023 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class SectionListCell: UITableViewCell {

    @IBOutlet var viewCell: UIView!
    @IBOutlet var lblStepper: UIStepper!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var lblSectionName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

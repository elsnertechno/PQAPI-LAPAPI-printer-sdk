//
//  LabelSettingTBLViewCell.swift
//  BaplsID
//
//  Created by admin on 16/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class LabelSettingTBLViewCell: UITableViewCell {

    //MARK:- OBJECTS & OUTLETS
    
    @IBOutlet var btnSelection: UIButton!
    @IBOutlet var lblFieldTitle: UILabel!
    
    //MARK:- CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

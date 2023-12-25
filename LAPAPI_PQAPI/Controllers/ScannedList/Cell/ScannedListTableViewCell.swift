//
//  ScannedListTableViewCell.swift
//  BaplsID
//
//  Created by nteam on 16/09/19.
//  Copyright © 2019 Hardik's Mac Mini. All rights reserved.
//

import UIKit

class ScannedListTableViewCell: UITableViewCell {

    //Marks : IBOutlets
    
    @IBOutlet weak var scannedDetailLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

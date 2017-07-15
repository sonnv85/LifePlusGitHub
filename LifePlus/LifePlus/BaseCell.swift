//
//  BaseCell.swift
//  Rental App
//
//  Created by Ninh Vo on 8/19/16.
//  Copyright © 2016 IdeaBox. All rights reserved.
//

import UIKit

let BaseCellId = "BaseCell"

class BaseCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}

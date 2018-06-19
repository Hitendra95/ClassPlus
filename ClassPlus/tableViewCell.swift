//
//  tableViewCell.swift
//  ClassPlus
//
//  Created by Hitendra Dubey on 19/06/18.
//  Copyright © 2018 Hitendra Dubey. All rights reserved.
//

import UIKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfCar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

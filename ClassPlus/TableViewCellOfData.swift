//
//  TableViewCellOfData.swift
//  ClassPlus
//
//  Created by Hitendra Dubey on 19/06/18.
//  Copyright © 2018 Hitendra Dubey. All rights reserved.
//

import UIKit

class TableViewCellOfData: UITableViewCell {
    //MARK: All elements of a cell is comnnected to class TableViewCellOfData
    @IBOutlet weak var subjectName: UILabel!
    
    @IBOutlet weak var totalNumberOfClassCompleted: UILabel!
    
    @IBOutlet weak var firstStudentImage: UIImageView!
    @IBOutlet weak var secondStudentImage: UIImageView!
    @IBOutlet weak var thirdStudentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

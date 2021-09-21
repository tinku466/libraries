//
//  DPCountryCell.swift
//  Dojo
//
//  Created by Ankit Saini on 04/12/19.
//  Copyright © 2019 softobiz. All rights reserved.
//

import UIKit
/// Country Cell
class DPCountryCell: UITableViewCell {
    /// Flag image
    @IBOutlet weak var imgVPic: UIImageView!
    /// Country Code
    @IBOutlet weak var lblCode: UILabel!
    /// Country name
    @IBOutlet weak var lblName: UILabel!
    
    
    /// Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Selection
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

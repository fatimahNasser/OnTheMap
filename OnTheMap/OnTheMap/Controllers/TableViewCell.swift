//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by ToOoMa on 2019-01-22.
//  Copyright © 2019 Fatimah. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func tableCell(location: StudentLocation) {
        userName.text = "\(location.firstName ?? "") \(location.lastName ?? "")"
        userLocation.text = "\(location.mediaURL ?? "")"
    }

}

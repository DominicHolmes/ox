//
//  RoomCell.swift
//  ox
//
//  Created by Dominic Holmes on 12/8/19.
//  Copyright © 2019 Dominic Holmes. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
    
    var room: Room?
    
    static let identifier = "RoomCell"
    
    @IBOutlet weak var labelPrimary: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var iconView: UIImageView!
}

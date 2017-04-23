//
//  BlogFilterTableViewCell.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit

class BlogFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var tagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(tag: BlogTags, accessoryType: UITableViewCellAccessoryType) {
        tagNameLabel.text = tag.tagName
            self.accessoryType = accessoryType
    }
}

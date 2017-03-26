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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCell(tag: BlogTags) {
        tagNameLabel.text = tag.tagName
        self.accessoryView = .none
    }
}

//
//  BlogTableViewCell.swift
//  12parsecs
//
//  Created by Alan Glasby on 18/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BlogTableViewCell: UITableViewCell {
    @IBOutlet weak var featuredImageImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var extractLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }

    override func draw(_ rect: CGRect) {
        featuredImageImageView.layer.cornerRadius = 5.0
        featuredImageImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(post: BlogPost) {
        titleTextField.text = post.title
        extractLabel.attributedText = post.excerpt.htmlAttributedString()
        dateTextField.text = post.date_gmt
        
        let authorId = post.author
        var author: String = ""
        if users.count != 0 {
            author = users[authorId-1].userName
        }
        authorTextField.text = author

        var categoryNames: String = ""
        if categories.count != 0 && post.categories.count != 0 {
            for cat in 0...post.categories.count-1 {
                let catId = post.categories[cat]
                let catName = categories[catId-1].categoryName
                categoryNames += catName
            }
        }
        categoryTextField.text = categoryNames

        var tagNames: String = ""
        if tags.count != 0 && post.tags.count != 0 {
            for tag in 0...post.tags.count-1 {
                let tagId = post.tags[tag]
                let tagName = tags[tagId-1].tagName
                tagNames += tagName
            }
        }
        tagLabel.text = tagNames
        if post.featured_media == 0 {
            self.featuredImageImageView.image = #imageLiteral(resourceName: "12pc@1x")
        } else {
            if mediaInfo.count != 0 {
                if let i = mediaInfo.index(where: {$0.mediaId == post.featured_media}) {
                    getMedia(action: wordpressAction.media, mediaUrl: mediaInfo[i].mediaThumbUrl)
                }
            }
        }
    }


    func getMedia(action: wordpressAction, mediaUrl: String) {
        let mediaId = mediaUrl
        let serverUrl = URL(string: (mediaId))
        var urlRequest = URLRequest(url: serverUrl!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue("alan:admin", forHTTPHeaderField: "Authorisation")

        Alamofire.request(urlRequest).responseImage { response in
            guard let image = response.result.value else {
                print("error")
                print("\(response.debugDescription)")
                return
            }
            self.featuredImageImageView.image = image
        }
    }
}

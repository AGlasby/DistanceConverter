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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var extractLabel: UILabel!


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

    func configureCell(post: BlogPosts) {
        titleTextField.text = post.title
        extractLabel.attributedText = post.excerpt?.htmlAttributedString()
        var date_gmt = "0000-01-01"
        guard let dateGmtRange = post.dateGmt?.range(of: "T")
            else {
                return
        }
        date_gmt = (post.dateGmt?.substring(to: dateGmtRange.lowerBound))!
        dateTextField.text = date_gmt
        
        if post.featuredMedia == 0 {
            self.featuredImageImageView.image = #imageLiteral(resourceName: "12pc@1x")
        } else {
            if mediaInfo.count != 0 {
                if let i = mediaInfo.index(where: {$0.mediaId == post.featuredMedia}) {
                    getMedia(action: wordpressAction.media, mediaUrl: mediaInfo[i].mediaThumbUrl!)
                }
            }
        }
    }


    func getMedia(action: wordpressAction, mediaUrl: String) {
        let mediaId = mediaUrl
        let serverUrl = URL(string: (mediaId))
        var urlRequest = URLRequest(url: serverUrl!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

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

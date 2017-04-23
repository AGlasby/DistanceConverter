//
//  BlogTableViewCell.swift
//  12parsecs
//
//  Created by Alan Glasby on 18/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import CoreData
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

    func configureCell(post: NSManagedObject, context: NSManagedObjectContext) {
        titleTextField.text = post.value(forKey: "title") as? String
        let excerpt = post.value(forKey: "excerpt") as? String
        extractLabel.attributedText = excerpt?.htmlAttributedString()
        var date_gmt = "0000-01-01"
        guard let dateGmt = post.value(forKey: "dateGmt") as? String else {
            return
        }
        let dateGmtRange = dateGmt.range(of: "T")
        date_gmt = (dateGmt.substring(to: dateGmtRange!.lowerBound))
        dateTextField.text = date_gmt

        self.featuredImageImageView.image = #imageLiteral(resourceName: "12pc@1x")
        if let mediaId = post.value(forKey: "featuredMedia") as? Int {
            getMedia(mediaId: mediaId, context: context)
        }
    }


    func getMedia(mediaId: Int, context: NSManagedObjectContext) {
        let fetch: NSFetchRequest<MediaDetails> = MediaDetails.createFetchRequest()
        fetch.predicate = NSPredicate(format: "mediaId == %d", mediaId)
        var mediaDetailsResults: [MediaDetails]? = nil
        do {
            mediaDetailsResults = try context.fetch(fetch) 
        } catch {
            fatalError("Failed to retrieve blogPost images from core data \(error)")
        }
        guard let first = mediaDetailsResults?.first else {
            return
        }
        guard let imageData = first.thumbnailImage else {
            guard let featuredImageUrl = first.mediaThumbUrl else {
                return
            }
            guard let serverUrl = URL(string: (featuredImageUrl)) else {
                return
            }
            var urlRequest = URLRequest(url: serverUrl)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            Alamofire.request(urlRequest).responseImage { response in
                guard let image = response.result.value else {
                    print("error")
                    print("\(response.debugDescription)")
                    return
                }
                self.featuredImageImageView.image = image
                let imageData = UIImagePNGRepresentation(image)
                first.thumbnailImage = imageData! as NSData
                do {
                    try first.managedObjectContext?.save()
                } catch {
                    fatalError("Failed to save blogPost image to core data \(error)")
                }
            }
        return
        }
        let image: UIImage = UIImage(data: imageData as Data)!
        self.featuredImageImageView.image = image
    }
}

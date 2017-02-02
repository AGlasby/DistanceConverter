//
//  BlogViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 18/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var posts = [BlogPost]()
var users = [BlogUser]()
var tags = [BlogTag]()
var categories = [BlogCategory]()
var mediaInfo = [MediaDetails]()

class BlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
@IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        blogTableView.delegate = self
        blogTableView.dataSource = self

        getWordpressData(action: wordpressAction.posts)
        getWordpressData(action: wordpressAction.users)
        getWordpressData(action: wordpressAction.tags)
        getWordpressData(action: wordpressAction.categories)
        getWordpressData(action: wordpressAction.media)
    }


// MARK: UITableViewDelegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogTableViewCell
        cell.configureCell(post: posts[indexPath.row])
        return cell
    }


// MARK: WordPress Methods

    func getWordpressData(action: wordpressAction) {
        let serverUrl = URL(string: "\(WORDPRESSADDRESS)\(action)")
        var urlRequest = URLRequest(url: serverUrl!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

// Temporary authorisation using basic authorisation
        urlRequest.addValue("WORDPRESSUSERNAME:WORDPRESSPASSWORD", forHTTPHeaderField: "Authorisation")

        Alamofire.request(urlRequest)
            .responseJSON {response in
                guard response.result.isSuccess else {
                    print("error: \(response.debugDescription)")
                    return
                }

                if let result = response.result.value {
                    let json = result as! [Dictionary<String, Any>]
                    for j in 0..<json.count {
                        let data = json[j]
                        switch action {
                        case wordpressAction.posts:
                            let post = self.extractPost(entry: data)
                            posts.append(post)
                            break
                        case wordpressAction.tags:
                            let tag = self.extractTag(entry: data)
                            tags.append(tag)
                            break
                        case wordpressAction.users:
                            let user = self.extractUser(entry: data)
                            users.append(user)
                            break
                        case wordpressAction.categories:
                            let category = self.extractCategory(entry: data)
                            categories.append(category)
                            break
                        case wordpressAction.media:
                            let media = self.extractMedia(entry: data)
                            mediaInfo.append(media)
                            break
                        }
                    }
                }
                self.do_table_refresh()
        }
    }

// The following needs work to industrialise
    func extractPost(entry: Dictionary<String, Any>) -> BlogPost {
        let date_gmt_tmp = entry["date_gmt"] as! String
        var date_gmt = "0000-01-01"
        if let range = date_gmt_tmp.range(of: "T") {
            date_gmt = date_gmt_tmp.substring(to: range.lowerBound)
        }
        let id = entry["id"] as! Int
        let slug = entry["slug"] as! String
        let titleTemp = entry["title"] as? [String: Any]
        let title = titleTemp?["rendered"] as! String
        let contentTemp = entry["content"] as? [String: Any]
        let content = contentTemp?["rendered"] as! String
        let author = entry["author"] as! Int
        let excerptTemp = entry["excerpt"] as? [String: Any]
        let excerpt = excerptTemp?["rendered"] as! String
        let featuredMedia = entry["featured_media"] as! Int
        let categories = entry["categories"] as! [Int]
        let tags = entry["tags"] as! [Int]
        let link = entry["link"] as! String
        let post = BlogPost(date_gmt: date_gmt, id: id, slug: slug, title: title, content: content, author: author, excerpt: excerpt, featured_media: featuredMedia, categories: categories, tags: tags, link: link)
        return post
    }

    
    func extractUser(entry: Dictionary<String, Any>) -> BlogUser {
        let userId = entry["id"] as! Int
        let userName = entry["name"] as! String
        let user = BlogUser(userId: userId, userName: userName)
        return user
    }


    func extractTag(entry: Dictionary<String, Any>) -> BlogTag {
        let tagId = entry["id"] as! Int
        let tagName = entry["name"] as! String
        let tag = BlogTag(tagId: tagId, tagName: tagName)
        return tag
    }


    func extractCategory(entry: Dictionary<String, Any>) -> BlogCategory {
        let categoryId = entry["id"] as! Int
        let categoryName = entry["name"] as! String
        let category = BlogCategory(categoryId: categoryId, categoryName: categoryName)
        return category
    }


    func extractMedia(entry: Dictionary<String, Any>) -> MediaDetails {
        let mediaId = entry["id"] as! Int
        let mediaLink = entry["link"] as! String
        let mediaDetails = entry["media_details"] as! Dictionary<String, Any>
        let mediaSizes = mediaDetails["sizes"] as! Dictionary<String, Any>
        let mediaThumb = mediaSizes["thumbnail"] as! Dictionary<String, Any>
        let mediaThumbUrl = mediaThumb["source_url"] as! String
        let mediaCaption = ""
        let mediaDescription = ""
        let media = MediaDetails(id: mediaId, link: mediaLink, caption: mediaCaption, desc: mediaDescription, thumbUrl: mediaThumbUrl)
        return media
    }


    func do_table_refresh()
    {
        DispatchQueue.main.async (execute: {
            self.blogTableView.reloadData()
            return
        })
    }


// MARK: Segue Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as! UINavigationController
        let blogDetailVC = nc.topViewController as! blogDetailViewController
        if let indexPath = self.blogTableView.indexPathForSelectedRow{
            let selectedBlog = posts[indexPath.row].link
            blogDetailVC.postLink = selectedBlog
            blogDetailVC.postTitle = posts[indexPath.row].title
        }
    }

    @IBAction func backFromModalDetail(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }
}

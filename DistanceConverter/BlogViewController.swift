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


    func do_table_refresh() {
        DispatchQueue.main.async (execute: {
            self.blogTableView.reloadData()
            return
        })
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
                            if let post = BlogPost(json: data) {
                                posts.append(post)
                                break
                            } else {
                                // Handle error
                                break
                            }
                        case wordpressAction.tags:
                            if let tag = BlogTag(json: data) {
                                tags.append(tag)
                                break
                            } else {
                                // Handle error
                                break
                            }
                        case wordpressAction.users:
                            if let user = BlogUser(json: data) {
                                users.append(user)
                                break
                            } else {
                                // Handle error
                                break
                            }
                        case wordpressAction.categories:
                            if let category = BlogCategory(json: data) {
                                categories.append(category)
                                break
                            } else {
                                // Handle error
                                break
                            }
                        case wordpressAction.media:
                            if let media = MediaDetails(json: data) {
                                mediaInfo.append(media)
                                break
                            } else {
                                // Handle error
                                break
                            }
                        }
                    }
                }
                self.do_table_refresh()
        }
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

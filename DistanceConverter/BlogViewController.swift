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
import CoreData


var blogPosts = [BlogPost]()
var users = [BlogUsers]()
var tags = [BlogTags]()
var categories = [BlogCategories]()
var mediaInfo = [MediaDetails]()

var container: NSPersistentContainer!

class BlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
@IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        container = NSPersistentContainer(name: "BlogModel")
        container.loadPersistentStores {NSPersistentStoreDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        blogTableView.delegate = self
        blogTableView.dataSource = self
        loadSavedData()

        performSelector(inBackground: #selector(updateBlogData), with: nil)
    }


// MARK: UITableViewDelegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogTableViewCell
        cell.configureCell(post: blogPosts[indexPath.row])
        return cell
    }


    func do_table_refresh() {
        DispatchQueue.main.async (execute: {
            self.blogTableView.reloadData()
            return
        })
    }

// MARK: Core Data Methods

    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                print("Saved posts")
            } catch {
                print("A fatal error has ocurred whilst saving: \(error)")
            }
        }
    }

    func loadSavedData() {
        let loadPosts = BlogPost.createFetchRequest()
        let sortPosts = NSSortDescriptor(key: "id", ascending: false)
        loadPosts.sortDescriptors = [sortPosts]
        do {
            blogPosts = try container.viewContext.fetch(loadPosts)
            print("Got results, \(blogPosts.count) posts retreived")
            do_table_refresh()
        } catch {
            print("Fetch posts failed")
            return
        }
        let loadMedia = MediaDetails.createFetchRequest()
        let sortMedia = NSSortDescriptor(key: "mediaId", ascending: false)
        loadMedia.sortDescriptors = [sortMedia]
        do {
            mediaInfo = try container.viewContext.fetch(loadMedia)
            print("Got results, \(mediaInfo.count) media retreived")
            do_table_refresh()
        } catch {
            print("Fetch media failed")
            return
        }
    }


// MARK: WordPress Methods

    func updateBlogData() {


        let per_page = 10
        var lastDatePosts = "2000-00-00T00:00:00"
        var lastDateMedia = "2000-00-00T00:00:00"
        if blogPosts.count > 0 {
            lastDatePosts = blogPosts[blogPosts.count-1].date!
        }
        if mediaInfo.count > 0 {
            lastDateMedia = mediaInfo[mediaInfo.count-1].mediaDate!
        }
        let parametersPosts = [
            "context" : "view",
            "per_page" : per_page] as [String : Any]
        self.getWordpressData(action: wordpressAction.posts, parameters: parametersPosts)
        let parametersMedia = [
            "context" : "view",
            "per_page" : per_page] as [String : Any]
        self.getWordpressData(action: wordpressAction.media, parameters: parametersMedia)
    }


    func getWordpressData(action: wordpressAction, parameters: [String : Any]) {

        let serverUrl = URL(string: "\(WORDPRESSADDRESS)\(action)")
        var urlRequest = URLRequest(url: serverUrl!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue

            Alamofire.request(serverUrl!, method: .get, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON {response in
                    guard response.result.isSuccess else {
                        self.handleErrorRetrievingJSON(action: action)
                        return
                    }
                    guard let result = response.result.value else {
                        self.handleErrorRetrievingJSON(action: action)
                        return
                    }
                    guard let json = result as? [Dictionary<String, Any>] else {
                        self.handleErrorRetrievingJSON(action: action)
                        return
                    }
                    let postsInCoreData = blogPosts.count
                    self.extractAndSave(action: action, json: json)
                    self.do_table_refresh()

                    let postsDownloaded = json.count
                    let page = 2
                    var parametersNew = parameters
                    var stillToDownload = 0
                    if let httpResponse = response.response?.allHeaderFields {
                        if let xwpTotal = httpResponse["x-wp-total"] as? String {
                            guard let totalPostsInWP = Int(xwpTotal) else {
                                self.handleErrorRetrievingJSON(action: action)
                                return
                            }
                            if totalPostsInWP <= postsInCoreData {
                                print("yes \(action)")
                            } else {
                                    stillToDownload = totalPostsInWP - postsInCoreData - postsDownloaded
                                    if stillToDownload <= 0 {
                                        return
                                    }
                                    parametersNew["page"] = page
                                    Alamofire.request(serverUrl!, method: .get, parameters: parametersNew, encoding: JSONEncoding.default)
                                        .responseJSON {response in
                                            guard response.result.isSuccess else {
                                                self.handleErrorRetrievingJSON(action: action)
                                                return
                                            }
                                            guard let result = response.result.value else {
                                                self.handleErrorRetrievingJSON(action: action)
                                                return
                                            }
                                            guard let json = result as? [Dictionary<String, Any>] else {
                                                self.handleErrorRetrievingJSON(action: action)
                                                return
                                            }
                                            self.extractAndSave(action: action, json: json)
                                            self.do_table_refresh()
                        }
                    }
                }
            }
        }
    }


    func extractAndSave(action: wordpressAction, json: [Dictionary<String, Any>]) {
        DispatchQueue.main.async {[unowned self] in
            for j in 0..<json.count {
                let data = json[j]
                switch action {
                case wordpressAction.posts:
                    let id: Int32 = data["id"] as! Int32
                    if !blogPosts.contains(where: {$0.id == id}) {
                        let post = BlogPost(context: container.viewContext)
                        guard BlogPost.extractPost(json: data, blogPost: post)! else {
                            self.handleErrorDeserialisingJSON(action: action)
                            break
                        }
                    } else {
                        print("Duplicate")
                    }
                    break
                case wordpressAction.tags:
                    let tag = BlogTags(context: container.viewContext)
                    guard BlogTags.extractTag(json: data, tag: tag)! else {
                        self.handleErrorDeserialisingJSON(action: action)
                        break
                    }
                    break
                case wordpressAction.users:
                    let user = BlogUsers(context: container.viewContext)
                    guard BlogUsers.extractUsers(json: data, user: user)! else {
                        self.handleErrorDeserialisingJSON(action: action)
                        break
                    }
                    break
                case wordpressAction.categories:
                    let category = BlogCategories(context: container.viewContext)
                    guard BlogCategories.extractCategories(json: data, category: category)! else {
                        self.handleErrorDeserialisingJSON(action: action)
                        break
                    }
                    break
                case wordpressAction.media:
                    let media = MediaDetails(context: container.viewContext)
                    guard MediaDetails.extractMedia(json: data, media: media)! else {
                        self.handleErrorDeserialisingJSON(action: action)
                        break

                    }
                    break
                }
            }
            self.saveContext()
            self.loadSavedData()
        }
    }


    func handleErrorDeserialisingJSON(action: wordpressAction) {
        showAlert(title: "Error handling data from blog site", message: "There was an error handling the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.", viewController: self)
    }
    func handleErrorRetrievingJSON(action: wordpressAction) {
        showAlert(title: "Error retrieving data from blog site", message: "There was an error retrieving the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.", viewController: self)
    }

// MARK: Segue Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nc = segue.destination as! UINavigationController
        let blogDetailVC = nc.topViewController as! blogDetailViewController
        if let indexPath = self.blogTableView.indexPathForSelectedRow{
            let selectedBlog = blogPosts[indexPath.row].link
            blogDetailVC.postLink = selectedBlog
            blogDetailVC.postTitle = blogPosts[indexPath.row].title
        }
    }

    @IBAction func backFromModalDetail(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }
}

//
//  BlogViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 18/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


var blogPosts: [BlogPosts]!
var users: [BlogUsers]!
var tags: [BlogTags]!
var categories: [BlogCategories]!
var mediaInfo: [MediaDetails]!

var filteredTags = [Int32]()
var filter = false

var container: NSPersistentContainer!
var blogPredicate: NSPredicate?

class BlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var blogNavigationBar: UINavigationBar!
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        blogNavigationBar.topItem!.title = "12 parsecs"
        container = NSPersistentContainer(name: "BlogModel")
        container.loadPersistentStores {NSPersistentStoreDescription, error in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                self.handleErrorAccessingCoreData(action: wordpressAction.posts, operation: "retrieving", error: error)
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
            } catch {
                handleErrorAccessingCoreData(action: wordpressAction.posts, operation: "saving", error: error)
            }
        }
    }

    func loadSavedData() {
        loadPosts(sortField: "id", ascending: false)
        loadMedia(sortField: "mediaId")
        loadTags(sortField: "tagId")
        loadCategories(sortField: "categoryId")
    }

    func loadPosts(sortField: String, ascending: Bool) {
        let loadPosts = BlogPosts.createFetchRequest()
        let sortPosts = NSSortDescriptor(key: sortField, ascending: ascending)
        loadPosts.sortDescriptors = [sortPosts]
        if filter {
            blogPredicate = NSPredicate(format: "ANY tags.tagId in %@", filteredTags)
            loadPosts.predicate = blogPredicate
        }
        do {
            blogPosts = try container.viewContext.fetch(loadPosts)
            do_table_refresh()
        } catch {
            handleErrorAccessingCoreData(action: wordpressAction.posts, operation: "retrieving", error: nil)
            return
        }
    }

    func loadMedia(sortField: String) {
        let loadMedia = MediaDetails.createFetchRequest()
        let sortMedia = NSSortDescriptor(key: sortField, ascending: true)
        loadMedia.sortDescriptors = [sortMedia]
        do {
            mediaInfo = try container.viewContext.fetch(loadMedia)
        } catch {
            handleErrorAccessingCoreData(action: wordpressAction.media, operation: "retrieving", error: nil)
            return
        }
    }

    func loadTags(sortField: String) {
        let loadTags = BlogTags.createFetchRequest()
        let sortTags = NSSortDescriptor(key: sortField, ascending: true)
        loadTags.sortDescriptors = [sortTags]
        do {
            tags = try container.viewContext.fetch(loadTags)
        } catch {
            handleErrorAccessingCoreData(action: wordpressAction.tags, operation: "retrieving", error: nil)
            return
        }
    }

    func loadCategories(sortField: String) {
        let loadCategories = BlogCategories.createFetchRequest()
        let sortCategories = NSSortDescriptor(key: sortField, ascending: true)
        loadCategories.sortDescriptors = [sortCategories]
        do {
            categories = try container.viewContext.fetch(loadCategories)
        } catch {
            handleErrorAccessingCoreData(action: wordpressAction.categories, operation: "retrieving", error: nil)
            return
        }
    }


// MARK: WordPress Methods

    func updateBlogData() {

        let parameters = [
            "context" : "view",
            "per_page" : WORDPRESSPAGESIZE] as [String : Any]
        self.getWordpressData(action: wordpressAction.posts, parameters: parameters)
        self.getWordpressData(action: wordpressAction.tags, parameters: parameters)
        self.getWordpressData(action: wordpressAction.media, parameters: parameters)
        self.getWordpressData(action: wordpressAction.categories, parameters: parameters)
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
                    self.extractAndSave(action: action, json: json)
                    var parametersNew = parameters
                    if let httpResponse = response.response?.allHeaderFields {
                        if let xWpTotal = httpResponse["x-wp-total"] as? String {
                            guard Int(xWpTotal) != nil else {
                                self.handleErrorRetrievingJSON(action: action)
                                return
                            }
                            if let xWpTotalPages = httpResponse["x-wp-totalpages"] as? String {
                                guard let totalPagesInWP = Int(xWpTotalPages) else {
                                    self.handleErrorRetrievingJSON(action: action)
                                    return
                                }
                                if totalPagesInWP > 1 {
                                for page in 2...totalPagesInWP {
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
                                    }
                                }
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
                    let post = BlogPosts(context: container.viewContext)
                    guard BlogPosts.extractPost(json: data, blogPost: post, blogTags: tags, blogCategories: categories)! else {
                        self.handleErrorDeserialisingJSON(action: action)
                        break
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
            if action == wordpressAction.posts {
                self.loadSavedData()
            }
        }
    }

    func handleErrorAccessingCoreData(action: wordpressAction, operation: String, error: Error?) {
        showAlert(title: "Error \(operation) data", message: "There was an error \(operation) the \(action) data. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.", viewController: self)
    }

    func handleErrorRetrievingJSON(action: wordpressAction) {
        showAlert(title: "Error retrieving data from blog site", message: "There was an error retrieving the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.", viewController: self)
    }

    func handleErrorDeserialisingJSON(action: wordpressAction) {
        showAlert(title: "Error handling data from blog site", message: "There was an error handling the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.", viewController: self)
    }


// MARK: Segue Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBlogPostFilter" {
        } else if segue.identifier == "showPost" {
            let blogDetailVC = segue.destination as! blogDetailViewController
            if let indexPath = self.blogTableView.indexPathForSelectedRow {
            let selectedBlog = blogPosts[indexPath.row].link
            blogDetailVC.postLink = selectedBlog
            blogDetailVC.postTitle = blogPosts[indexPath.row].title
            }
        }
    }


    @IBAction func backFromModalDetail(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? BlogFilterViewController {
            filter = true
            filteredTags = sourceViewController.filterByTags
            blogPredicate = NSPredicate(format: "ANY tags.tagId in %@", filteredTags)
            loadSavedData()
            self.tabBarController?.selectedIndex = 1
        }
    }


// MARK: Sort Methods

    @IBAction func showSortOptions(_ sender: Any) {
        let ac = UIAlertController(title: "Sort Posts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "By Date", style: .default) { [unowned self] _ in
            self.loadPosts(sortField: "date", ascending: false)
            })
        ac.addAction(UIAlertAction(title: "By Title", style: .default) { [unowned self] _ in
            self.loadPosts(sortField: "title", ascending: true)
        })
        ac.addAction(UIAlertAction(title: "By Author", style: .default) { [unowned self] _ in
            self.loadPosts(sortField: "author", ascending: true)
        })
        ac.addAction(UIAlertAction(title: "By ID", style: .default) { [unowned self] _ in
            self.loadPosts(sortField: "id", ascending: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}










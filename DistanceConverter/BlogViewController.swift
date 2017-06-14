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

var filteredTags = [Int32]()
var filter = false
enum sortField {
    case id
    case author
    case date
    case title
}
var downloadTracker = ActionDownloadsStatus()

class BlogViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var spinnerActivityIndicator: UIActivityIndicatorView!
    var fetchPredicate: NSPredicate?
    var fRC: NSFetchedResultsController<BlogPosts>?
    internal let refreshControl = UIRefreshControl()
    var sortMode = sortField.id
    var timer = Timer()


    @IBOutlet weak var blogNavigationBar: UINavigationBar!
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        blogNavigationBar.topItem!.title = "12 parsecs"
        var notificationName = Notification.Name(INITIALIZED)
        NotificationCenter.default.addObserver(self, selector: #selector(completeUISetUp), name: notificationName, object: nil)
        notificationName = Notification.Name(REFRESHCOMPLETE)
        NotificationCenter.default.addObserver(self, selector: #selector(endTableRefresh), name: notificationName, object: nil)

        spinnerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        spinnerActivityIndicator.center = view.center
        spinnerActivityIndicator.becomeFirstResponder()
        view.addSubview(spinnerActivityIndicator)
        spinnerActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        spinnerActivityIndicator.startAnimating()
        spinnerActivityIndicator.hidesWhenStopped = true
    }


    func completeUISetUp() {
        let sortBy = [NSSortDescriptor(key: "id", ascending: false)]
        self.fetchPosts(sortBy: sortBy, filterBy: nil)

        self.blogTableView.delegate = self
        self.blogTableView.dataSource = self
        self.setUpTableView()
        if !isInternetAvailable() {
            self.handleErrorNoNetworkConnection()
        } else {
            self.updateBlogData()
        }
    }

    func handleErrorNoNetworkConnection() {
        showAlert(title: "No Network Connection", message: "Unable to retrieve blog data as there is no internet connection. Please check connectivity and try again")
    }

    func fetchPosts(sortBy: [NSSortDescriptor], filterBy: NSPredicate?) {
        let fetch: NSFetchRequest<BlogPosts> = BlogPosts.createFetchRequest()
        fetch.sortDescriptors = sortBy
        if filterBy != nil {
            fetch.predicate = filterBy
        }
        guard let moc = dataController?.mainContext else {
            self.handleMOCError()
            return
        }
        self.fRC = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        self.fRC?.delegate = self
        do {
            try
                self.fRC?.performFetch()
        } catch {
            fatalError("Unable to fetch \(error)")
        }
        blogTableView.reloadData()
    }

    func handleMOCError() {
        showAlert(title: "MOC Error", message: "Error getting MOC. Unable to access data.")
    }
    
// MARK: UITableViewDelegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = fRC?.sections?.count else {
            fatalError("Failed to resolve FetchedResultsController")
        }
        return count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fRC?.sections?[section] else {
            fatalError("Failed to resolve FetchedResultsController")
        }
        return sectionInfo.numberOfObjects
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let moc = dataController?.mainContext else {
            handleMOCError()
            fatalError("Unable to get main context")
        }
        guard let obj = fRC?.object(at: indexPath) else {
            fatalError("Unable to get object from fetched results controller")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogTableViewCell
        cell.configureCell(post: obj, context: moc)
        return cell
    }


    func setUpTableView() {
        if #available(iOS 10.0, *) {
            blogTableView.refreshControl = refreshControl
        } else {
            blogTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(updateBlogData), for: .valueChanged)
        let attributes = [NSFontAttributeName: UIFont(name: "Georgia", size: 16.0)!, NSForegroundColorAttributeName: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching blog posts ...", attributes: attributes)
        refreshControl.tintColor = UIColor.white
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(refreshTimeout), userInfo: nil, repeats: false)

    }

    public func endTableRefresh(_ notification: Notification) {
        spinnerActivityIndicator.stopAnimating()
        timer.invalidate()
        print("Timer invalidated")
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        let sortBy = [NSSortDescriptor(key: "id", ascending: false)]
        fetchPosts(sortBy: sortBy, filterBy: nil)
    }

    func refreshTimeout(){
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

// MARK: FetchedResultsController Methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blogTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            blogTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            blogTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move: break
        case .update: break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let nip = newIndexPath else {
                fatalError("Unknown error with fetched results controller")
            }
            blogTableView.insertRows(at: [nip], with: .fade)
        case .delete:
            guard let ip = indexPath else {
                fatalError("Unknown error with fetched results controller")
            }
            blogTableView.deleteRows(at: [ip], with: .fade)
        case .move:
            guard  let ip = indexPath else {
                fatalError("Unknown error with fetched results controller")
            }
            guard let nip = newIndexPath else {
                fatalError("Unknown error with fetched results controller")
            }
            blogTableView.deleteRows(at: [ip], with: .fade)
            blogTableView.insertRows(at: [nip], with: .fade)
        case .update:
            guard let ip = indexPath else {
                fatalError("Unknown error with fetched results controller")
            }
            blogTableView.reloadRows(at: [ip], with: .fade)
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blogTableView.endUpdates()
    }


// MARK: WordPress Methods

    func updateBlogData() {

        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshTimeout), userInfo: nil, repeats: false)
        let parameters = setUpParameters()
        getWordpressData(action: wordpressAction.tags, parameters: parameters)
        getWordpressData(action: wordpressAction.media, parameters: parameters)
        getWordpressData(action: wordpressAction.posts, parameters: parameters)
    }


// MARK: Segue Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("Unidentified segue")
        }
        switch identifier {
            case "ShowBlogPostFilter":
                prepareForBlogPostFilterSegue(segue)
            case "showPost":
                prepareForBlogDetailSegue(segue)
            default:
                    fatalError("Unidentified segue \(identifier)")
        }
    }


    func prepareForBlogPostFilterSegue(_ segue: UIStoryboardSegue) {
        let fetch: NSFetchRequest<BlogTags> = BlogTags.createFetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "tagId", ascending: true)]
        guard let moc = dataController?.mainContext else {
            handleMOCError()
            return
        }
        var blogTags: [BlogTags]? = nil
        do {
            blogTags = try moc.fetch(fetch)
        } catch {
            fatalError("Failed to retrieve blogPost images from core data \(error)")
        }
        let nc = segue.destination as! UINavigationController
        let blogFilterVC = nc.topViewController as! BlogFilterViewController
        blogFilterVC.tagDetails = blogTags
        blogFilterVC.filterByTags = filteredTags
    }


    func prepareForBlogDetailSegue(_ segue: UIStoryboardSegue) {
        let blogDetailVC = segue.destination as! blogDetailViewController
        if let indexPath = self.blogTableView.indexPathForSelectedRow {
            let post = fRC?.object(at: indexPath)
            let selectedBlog = post?.value(forKey: "link")
            post?.newPost = false
            guard let moc = dataController?.writerContext else {
                handleMOCError()
                return
            }
            moc.performAndWait {
                do {
                    try moc.save()
                    dataController?.saveContext()
                } catch {
                    fatalError("Failed to save writer context: \(error)")
                }
            }
            blogDetailVC.postLink = selectedBlog as! String
            blogDetailVC.postTitle = post!.value(forKey: "title") as! String
        }
    }


    @IBAction func backFromModalDetail(segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 1
    }


    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? BlogFilterViewController {
            filter = true
            let newPosts = sourceViewController.newSelected
            filteredTags = sourceViewController.filterByTags
            let all = sourceViewController.allSelected
            if !all {
                if !newPosts {
                    let fetch: NSFetchRequest<PostsForTag> = PostsForTag.createFetchRequest()
                    fetch.sortDescriptors = [NSSortDescriptor(key: "tagId", ascending: false)]
                    fetch.predicate = NSPredicate(format: "tagId IN %@", filteredTags)
                    guard let moc = dataController?.mainContext else {
                        handleMOCError()
                        return
                    }
                    var postsForTags: [PostsForTag]? = nil
                    do {
                        postsForTags = try moc.fetch(fetch)
                    } catch {
                        fatalError("Failed to retrieve postsForTag images from core data \(error)")
                    }
                    var posts = [Int32]()
                    for s in 0..<postsForTags!.count {
                        let setOfPosts = postsForTags![s].post
                        let postsInSet = setOfPosts!.allObjects as! [BlogPosts]
                        for p in 0..<postsInSet.count {
                            posts.append(postsInSet[p].id)
                        }
                }
                let sortDescriptors = sortSelectedPosts(sortBy: sortMode)
                fetchPredicate = NSPredicate(format: "id IN %@", posts)
                fetchPosts(sortBy: sortDescriptors, filterBy:fetchPredicate)
                } else {
                    let sortDescriptor = [NSSortDescriptor(key: "id", ascending: false)]
                    let fetchPredicate = NSPredicate(format: "newPost == %@", NSNumber(booleanLiteral: true))
                    fetchPosts(sortBy: sortDescriptor, filterBy: fetchPredicate)
                }
            } else {
                let sortDescriptor = [NSSortDescriptor(key: "id", ascending: false)]
                fetchPredicate = NSPredicate(value: true)
                fetchPosts(sortBy: sortDescriptor, filterBy: fetchPredicate)
            }
            if blogTableView.numberOfRows(inSection: 0) > 0 {
                let tableViewTop = IndexPath(row: 0, section: 0)
                self.blogTableView.scrollToRow(at: tableViewTop, at: UITableViewScrollPosition.top, animated: true)
            }
            self.tabBarController?.selectedIndex = 1
        }
    }


// MARK: Sort Methods

    @IBAction func showSortOptions(_ sender: Any) {
        let ac = UIAlertController(title: "Sort Posts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "By Date", style: .default) { _ in
            self.sortMode = sortField.date
            let sortBy = self.sortSelectedPosts(sortBy: sortField.date)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
            })
        ac.addAction(UIAlertAction(title: "By Title", style: .default) { _ in
            self.sortMode = sortField.title
            let sortBy = self.sortSelectedPosts(sortBy: sortField.title)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "By Author", style: .default) { _ in
            self.sortMode = sortField.author
            let sortBy = self.sortSelectedPosts(sortBy: sortField.author)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "Default", style: .default) { _ in
            self.sortMode = sortField.id
            let sortBy = self.sortSelectedPosts(sortBy: sortField.id)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func sortSelectedPosts(sortBy: sortField) -> [NSSortDescriptor] {
        var sortDescriptor = [NSSortDescriptor]()
        switch sortBy {
            case sortField.author:
                sortDescriptor.append(NSSortDescriptor(key: "author", ascending: true))
            case sortField.date:
                sortDescriptor.append(NSSortDescriptor(key: "date", ascending: true))
            case sortField.id:
                sortDescriptor.append(NSSortDescriptor(key: "id", ascending: false))
            case sortField.title:
                sortDescriptor.append(NSSortDescriptor(key: "title", ascending: true))
        }
        return sortDescriptor
    }

    @IBAction func markAllPostsRead(_ sender: Any) {
        guard let moc = dataController?.writerContext else {
            handleMOCError()
            return
        }
        moc.perform({
            let request = NSBatchUpdateRequest(entityName: "BlogPosts")
            let predicate = NSPredicate(format: "newPost == %@", NSNumber(booleanLiteral: true))
            request.predicate = predicate
            request.propertiesToUpdate = ["newPost": false]
            request.resultType = .updatedObjectIDsResultType
            do {
                guard let result = try moc.execute(request) as? NSBatchUpdateResult else {
                    fatalError("Unexpected result from batch update")
                }
                guard let resultArray = result.result as? [NSManagedObjectID] else {
                    fatalError("Unexpected result from batch update")
                }
                if resultArray.count != 0 {
                    self.mergeExternalChanges(resultArray, ofType: NSUpdatedObjectsKey)
                }
            } catch {
                fatalError("Failed to execute batch update")
            }
        })
    }

    func mergeExternalChanges(_ objectIDArray: [NSManagedObjectID], ofType type: String) {
        guard let main = dataController?.mainContext, let writer = dataController?.writerContext else {
            handleMOCError()
            return
        }
        let save = [type: objectIDArray]
        let contexts = [main, writer]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: contexts)
    }
}










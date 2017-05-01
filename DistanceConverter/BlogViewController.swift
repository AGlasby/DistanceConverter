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
import SystemConfiguration

var filteredTags = [Int32]()
var filter = false
enum sort {
    case id
    case author
    case date
    case title
}


class BlogViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var managedObjectContext: NSManagedObjectContext?
    var fetchPredicate: NSPredicate?
    var fRC: NSFetchedResultsController<BlogPosts>?
    private let refreshControl = UIRefreshControl()
    var sortMode = sort.id

    @IBOutlet weak var blogNavigationBar: UINavigationBar!
    @IBOutlet weak var blogTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        blogNavigationBar.topItem!.title = "12 parsecs"
        var notificationName = Notification.Name(INITIALIZED)
        NotificationCenter.default.addObserver(self, selector: #selector(completeUISetUp), name: notificationName, object: nil)
        notificationName = Notification.Name(REFRESHCOMPLETE)
        NotificationCenter.default.addObserver(self, selector: #selector(endTableRefresh), name: notificationName, object: nil)
    }


    func completeUISetUp() {
        DispatchQueue.main.async {
            let sortBy = [NSSortDescriptor(key: "id", ascending: false)]
            self.fetchPosts(sortBy: sortBy, filterBy: nil)

            self.blogTableView.delegate = self
            self.blogTableView.dataSource = self

            self.setUpTableView()
            if !self.isInternetAvailable() {
                self.handleErrorNoNetworkConnection()
            } else {
                self.updateBlogData()
            }
        }
    }

    func isInternetAvailable() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
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
        guard let moc = self.managedObjectContext else {
            fatalError("MOC not initialized")
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
        guard let frc = fRC else {
            fatalError("Failed to resolve FetchedResultsController")
        }
        let obj = frc.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell", for: indexPath) as! BlogTableViewCell
        cell.configureCell(post: obj, context: managedObjectContext!)
        return cell
    }


    func setUpTableView() {
        if #available(iOS 10.0, *) {
            blogTableView.refreshControl = refreshControl
        } else {
            blogTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(updateBlogData), for: .valueChanged)
        let attributes = [NSFontAttributeName:UIFont(name: "Georgia", size: 16.0)!]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching blog posts ...", attributes: attributes)
//        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshTimeout), userInfo: nil, repeats: false)
    }

        public func endTableRefresh(_ notification: Notification) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
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
                fatalError("How?")
            }
            blogTableView.insertRows(at: [nip], with: .fade)
        case .delete:
            guard let ip = indexPath else {
                fatalError("How?")
            }
            blogTableView.deleteRows(at: [ip], with: .fade)
        case .move:
            guard  let ip = indexPath else {
                fatalError("How")
            }
            guard let nip = newIndexPath else {
                fatalError("How?")
            }
            blogTableView.deleteRows(at: [ip], with: .fade)
            blogTableView.insertRows(at: [nip], with: .fade)
        case .update:
            guard let ip = indexPath else {
                fatalError("How?")
            }
            blogTableView.reloadRows(at: [ip], with: .fade)
        }
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blogTableView.endUpdates()
    }


// MARK: WordPress Methods

    func updateBlogData() {
        guard let moc = managedObjectContext else {
            fatalError("MOC not initialized")
        }
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshTimeout), userInfo: nil, repeats: false)
        let parameters = setUpParameters()
        getWordpressData(action: wordpressAction.tags, parameters: parameters, context: moc)
        getWordpressData(action: wordpressAction.media, parameters: parameters, context: moc)
        getWordpressData(action: wordpressAction.posts, parameters: parameters, context: moc)
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
        guard let moc = self.managedObjectContext else {
            fatalError("MOC not initialized")
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
            filteredTags = sourceViewController.filterByTags
            let all = sourceViewController.allSelected
            if !all {
                let fetch: NSFetchRequest<PostsForTag> = PostsForTag.createFetchRequest()
                fetch.sortDescriptors = [NSSortDescriptor(key: "tagId", ascending: false)]
                fetch.predicate = NSPredicate(format: "tagId IN %@", filteredTags)
                guard let moc = self.managedObjectContext else {
                    fatalError("MOC not initialized")
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
                fetchPredicate = NSPredicate(value: true)
                fetchPosts(sortBy: sortDescriptor, filterBy: fetchPredicate)
            }
            let tableViewTop = IndexPath(row: 0, section: 0)
            self.blogTableView.scrollToRow(at: tableViewTop, at: UITableViewScrollPosition.top, animated: true)
            self.tabBarController?.selectedIndex = 1
        }
    }


// MARK: Sort Methods

    @IBAction func showSortOptions(_ sender: Any) {
        let ac = UIAlertController(title: "Sort Posts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "By Date", style: .default) { _ in
            self.sortMode = sort.date
            let sortBy = self.sortSelectedPosts(sortBy: sort.date)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
            })
        ac.addAction(UIAlertAction(title: "By Title", style: .default) { _ in
            self.sortMode = sort.title
            let sortBy = self.sortSelectedPosts(sortBy: sort.title)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "By Author", style: .default) { _ in
            self.sortMode = sort.author
            let sortBy = self.sortSelectedPosts(sortBy: sort.author)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "Default", style: .default) { _ in
            self.sortMode = sort.id
            let sortBy = self.sortSelectedPosts(sortBy: sort.id)
            self.fetchPosts(sortBy: sortBy, filterBy: self.fetchPredicate)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func sortSelectedPosts(sortBy: sort) -> [NSSortDescriptor] {
        var sorter = [NSSortDescriptor]()
        switch sortBy {
            case sort.author:
                sorter.append(NSSortDescriptor(key: "author", ascending: true))
            case sort.date:
                sorter.append(NSSortDescriptor(key: "date", ascending: true))
            case sort.id:
                sorter.append(NSSortDescriptor(key: "id", ascending: false))
            case sort.title:
                sorter.append(NSSortDescriptor(key: "title", ascending: true))
        }
        return sorter
    }
}










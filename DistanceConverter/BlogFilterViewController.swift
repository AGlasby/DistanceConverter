//
//  BlogFilterViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit

class BlogFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var filterByTags = [Int32]()
    var tagDetails: [BlogTags]!
    var allSelected = false

    @IBOutlet weak var blogFilterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blogFilterTableView.delegate = self
        blogFilterTableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! BlogFilterTableViewCell
        if filterByTags.contains(tagDetails[indexPath.row].tagId) {
            cell.configureCell(tag: tagDetails[indexPath.row], accessoryType: .checkmark)
        } else {
            cell.configureCell(tag: tagDetails[indexPath.row], accessoryType: .none)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BlogFilterTableViewCell
        let t = tagDetails[indexPath.row].tagId
        if let index = filterByTags.index(of: t) {
            filterByTags.remove(at: index)
            cell.accessoryType = .none
        } else {
            filterByTags.append(t)
            cell.accessoryType = .checkmark
        }
        allSelected = false
    }
    
    @IBAction func selectSetAll(_ sender: Any) {

        if let totalRows = blogFilterTableView.indexPathsForVisibleRows{
            for r in totalRows {
                blogFilterTableView.selectRow(at: IndexPath(row: r.row, section: 0), animated: true, scrollPosition: .none)
                let cell = blogFilterTableView.cellForRow(at: IndexPath(row: r.row, section: 0)) as! BlogFilterTableViewCell
                cell.accessoryType = .checkmark
            }
        }
        for td in 0..<tagDetails.count {
            let tagId = tagDetails[td].tagId
            filterByTags.append(tagId)
        }
        allSelected = true
    }

    @IBAction func selectClearAll(_ sender: Any) {
        if let totalRows = blogFilterTableView.indexPathsForVisibleRows {
            for r in totalRows {
                blogFilterTableView.selectRow(at: IndexPath(row: r.row, section: 0), animated: true, scrollPosition: .none)
                let cell = blogFilterTableView.cellForRow(at: IndexPath(row: r.row, section: 0)) as! BlogFilterTableViewCell
                cell.accessoryType = .none
            }
        }
        filterByTags.removeAll()
        allSelected = false
    }
}










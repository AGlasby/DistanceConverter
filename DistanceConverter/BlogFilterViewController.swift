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
    var newSelected = false

    @IBOutlet weak var blogFilterTableView: UITableView!
    @IBOutlet weak var newButtonSelected: UIBarButtonItem!
    
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

    @IBAction func newSelected(_ sender: Any) {
        if !newSelected {
            newSelected = true
            newButtonSelected.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            newSelected = false
            newButtonSelected.tintColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        }
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










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
        return tags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! BlogFilterTableViewCell
        cell.configureCell(tag: tags[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BlogFilterTableViewCell
        let t = tags[indexPath.row].tagId
        if let index = filterByTags.index(of: t) {
            filterByTags.remove(at: index)
            cell.accessoryType = .none
        } else {
            filterByTags.append(t)
            cell.accessoryType = .checkmark
        }
    }
    
    @IBAction func selectSetAll(_ sender: Any) {
        for t in 0..<tags.count {
            filterByTags.append(tags[t].tagId)
        }
        let totalRows = blogFilterTableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            blogFilterTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
            let cell = blogFilterTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! BlogFilterTableViewCell
            cell.accessoryType = .checkmark
        }
    }

    @IBAction func selectClearAll(_ sender: Any) {
        filterByTags.removeAll()
        let totalRows = blogFilterTableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            blogFilterTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
        let cell = blogFilterTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! BlogFilterTableViewCell
            cell.accessoryType = .none
        }
    }
}










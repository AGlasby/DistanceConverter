//
//  BlogFilterViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit

class BlogFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! BlogFilterTableViewCell
//        cell.configureCell(post: blogPosts[indexPath.row])
        return cell
    }


}

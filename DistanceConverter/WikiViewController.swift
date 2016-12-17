//
//  WikiViewController.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 10/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit
import WebKit

class WikiViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var wikiWebView: UIWebView!

    var url:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wikiUrl = NSURL(string: url)
        let wikiLoadRequest = NSURLRequest(url: wikiUrl! as URL)
        wikiWebView.loadRequest(wikiLoadRequest as URLRequest)

        // Do any additional setup after loading the view.
    }

    
}

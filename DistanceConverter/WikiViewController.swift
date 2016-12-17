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
    @IBOutlet weak var spinnerActivityIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var wikiWebView: UIWebView!

    var url:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wikiWebView.delegate = self

        spinnerActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinnerActivityIndicatorView.center = view.center
        self.view.addSubview(spinnerActivityIndicatorView)
        spinnerActivityIndicatorView.hidesWhenStopped = true

        let wikiUrl = NSURL(string: url)
        let wikiLoadRequest = NSURLRequest(url: wikiUrl! as URL)
        wikiWebView.loadRequest(wikiLoadRequest as URLRequest)
    }


    func webViewDidStartLoad(_ webView: UIWebView) {
        spinnerActivityIndicatorView.startAnimating()
    }


    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinnerActivityIndicatorView.stopAnimating()
    }


    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinnerActivityIndicatorView.stopAnimating()
    }
}

//
//  blogDetailViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import WebKit

class blogDetailViewController: UIViewController, UIWebViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    @IBOutlet weak var blogDetailWebView: UIWebView!
    @IBOutlet weak var spinnerActivityIndicatorView: UIActivityIndicatorView!
    var postLink: String!
    var postTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogDetailWebView.delegate = self

        spinnerActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinnerActivityIndicatorView.center = view.center
        self.view.addSubview(spinnerActivityIndicatorView)
        spinnerActivityIndicatorView.hidesWhenStopped = true

// create the request
        let requestUrl = URL(string: postLink)
        let urlRequest = URLRequest(url: requestUrl!)
 let urlConnection = NSURLConnection(request: urlRequest as URLRequest, delegate: self)
        blogDetailWebView.loadRequest(urlRequest)
        self.title = postTitle
    }

    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        let defaultCredentials: URLCredential = URLCredential(user: "alan", password: "admin", persistence:URLCredential.Persistence.forSession)
        challenge.sender!.use(defaultCredentials, for: challenge)
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



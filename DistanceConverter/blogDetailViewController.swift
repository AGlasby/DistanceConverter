//
//  blogDetailViewController.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import UIKit
import WebKit

class blogDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var postSpaceView: UIView!

    var spinnerActivityIndicator: UIActivityIndicatorView!
    var blogDetailWebView: WKWebView!
    var postLink: String!
    var postTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        detailTitle.title = postTitle
        blogDetailWebView = WKWebView()
        blogDetailWebView.navigationDelegate = self
        blogDetailWebView.uiDelegate = self
        blogDetailWebView.translatesAutoresizingMaskIntoConstraints = false
        postSpaceView.addSubview(blogDetailWebView)
        let views: [String: UIView] = ["postSpaceView" : postSpaceView , "blogDetailWebView" : blogDetailWebView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[blogDetailWebView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[blogDetailWebView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))

        // create the request
        let requestUrl = URL(string: postLink)!
        blogDetailWebView.load(URLRequest(url: requestUrl))

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        spinnerActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        spinnerActivityIndicator.center = blogDetailWebView.center
        spinnerActivityIndicator.becomeFirstResponder()
        blogDetailWebView.addSubview(spinnerActivityIndicator)
        spinnerActivityIndicator.startAnimating()
        spinnerActivityIndicator.hidesWhenStopped = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinnerActivityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinnerActivityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url {
            let urlString = url.absoluteString
            var safeUrl = false
            for dom in ALLOWEDDOMAINS {
                if urlString.contains(dom) {
                    safeUrl = true
                    break
                }
            }
            if url == URL(string: postLink)! || safeUrl {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}



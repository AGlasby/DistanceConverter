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
    private let fadeInAnimator = AFGFadeInAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        wikiWebView.delegate = self

        spinnerActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        spinnerActivityIndicatorView.center = view.center
        self.view.addSubview(spinnerActivityIndicatorView)
        spinnerActivityIndicatorView.hidesWhenStopped = true

        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let wikiUrl = URL(string: encodedUrl) {
            let wikiLoadRequest = URLRequest(url: wikiUrl)
            wikiWebView.loadRequest(wikiLoadRequest as URLRequest)
        } else {
            showAlert(title: "Failed to correctly set web page address", message: "Unfortunately there was an error when setting the address of the web page. Please notify developer through developer's website - https://thisnow.software/contact/ ")
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            fatalError("Unidentified segue")
        }
        switch identifier {
            case "returnFromWiki":
                prepareForReturnFromWikiSegue(segue)
        default:
                fatalError("Unidentified segue \(identifier)")
        }
    }

    func prepareForReturnFromWikiSegue(_ segue: UIStoryboardSegue) {
        let destinationVC = segue.destination as? ViewController
        destinationVC?.transitioningDelegate = self
    }
}

extension WikiViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AFGFadeInAnimator()
    }
}

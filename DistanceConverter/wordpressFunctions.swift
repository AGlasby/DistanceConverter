//
//  wordpressFunctions.swift
//  12parsecs
//
//  Created by Alan Glasby on 02/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import  CoreData
import Alamofire
import AlamofireImage

struct ActionDownloadsStatus {
    private var _postsPagesTotal:Int
    private var _postsPagesProcessed:Int
    private var _tagsPagesTotal:Int
    private var _tagsPagesProcessed:Int
    private var _mediaPagesTotal:Int
    private var _mediaPagesProcessed:Int

    init() {
        _postsPagesTotal = 100
        _postsPagesProcessed = 0
        _tagsPagesTotal = 100
        _tagsPagesProcessed = 0
        _mediaPagesTotal = 100
        _mediaPagesProcessed = 0
    }

    mutating func actionComplete(action: wordpressAction) {
        switch action {
        case .tags:
            _tagsPagesProcessed += 1
        case .media:
            _mediaPagesProcessed += 1
        case .posts:
            _postsPagesProcessed += 1
        }
    }

    mutating func setPagesTotal(action: wordpressAction, totalPages: Int) {
        switch action {
        case .tags:
            _tagsPagesTotal = totalPages
        case .media:
            _mediaPagesTotal = totalPages
        case .posts:
            _postsPagesTotal = totalPages
        }
    }

    mutating func resetDownloadStatus() {
        _postsPagesProcessed = 0
        _tagsPagesProcessed = 0
        _mediaPagesProcessed = 0
    }
    func checkStatus() -> Bool {
        if _postsPagesProcessed == _postsPagesTotal && _mediaPagesProcessed == _mediaPagesTotal && _tagsPagesProcessed == _tagsPagesTotal {
            return true
        } else {
            return false
        }
    }
    func status() {
        print("posts = \(_postsPagesProcessed)")
        print("tags = \(_tagsPagesProcessed)")
        print("media = \(_mediaPagesProcessed)")
    }
}

func setUpParameters() -> [String:Any] {
    let parameters = [
        "context" : "view",
        "per_page" : WORDPRESSPAGESIZE] as [String : Any]
    return parameters
}

func getWordpressData(action: wordpressAction, parameters: [String : Any]) {

    let serverUrl = URL(string: "\(WORDPRESSADDRESS)\(action)")
    var urlRequest = URLRequest(url: serverUrl!)
    urlRequest.httpMethod = HTTPMethod.get.rawValue

    Alamofire.request(serverUrl!, method: .get, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON {response in
        guard response.result.isSuccess else {
            let notificationName = Notification.Name(REFRESHCOMPLETE)
            NotificationCenter.default.post(name: notificationName, object: nil)

            handleErrorRetrievingJSON(action: action)
            return
        }
        guard let result = response.result.value else {
            handleErrorRetrievingJSON(action: action)
            return
        }
        guard let json = result as? [Dictionary<String, Any>] else {
            handleErrorRetrievingJSON(action: action)
            return
        }
        extractAndSave(action: action, json: json)
        var parametersNew = parameters
        if let httpResponse = response.response?.allHeaderFields {
            if let xWpTotal = httpResponse["x-wp-total"] as? String {
                guard Int(xWpTotal) != nil else {
                    handleErrorRetrievingJSON(action: action)
                    return
                }
                if let xWpTotalPages = httpResponse["x-wp-totalpages"] as? String {
                    guard let totalPagesInWP = Int(xWpTotalPages) else {
                        handleErrorRetrievingJSON(action: action)
                        return
                    }
                    downloadTracker.setPagesTotal(action: action, totalPages: totalPagesInWP)
                    if totalPagesInWP == 1 {
                        downloadTracker.actionComplete(action: action)
                    } else {
                        for page in 2...totalPagesInWP {
                            parametersNew["page"] = page
                            Alamofire.request(serverUrl!, method: .get, parameters: parametersNew, encoding: JSONEncoding.default)
                                .responseJSON {response in
                            guard response.result.isSuccess else {
                                handleErrorRetrievingJSON(action: action)
                                return
                            }
                            guard let result = response.result.value else {
                                handleErrorRetrievingJSON(action: action)
                                return
                            }
                            guard let json = result as? [Dictionary<String, Any>] else {
                                handleErrorRetrievingJSON(action: action)
                                return
                            }
                                print("About to extract \(action) page \(page)")
                                extractAndSave(action: action, json: json)
                            }
                        }
                    }
                }
            }
        }
    }

    func checkIfDownloadsCompleted() {
        downloadTracker.status()
        if downloadTracker.checkStatus() {
            print("All downloads completed")
            let notificationName = Notification.Name(REFRESHCOMPLETE)
            NotificationCenter.default.post(name: notificationName, object: nil)
            downloadTracker.resetDownloadStatus()

        }
    }

    func extractAndSave(action: wordpressAction, json: [Dictionary<String, Any>]) {
        print("extracting \(action)")
        guard let moc = dataController?.writerContext else {
            fatalError("Unable to get main context")
        }
        moc.performAndWait {
            for j in 0..<json.count {
                let data = json[j]
                switch action {
                case wordpressAction.posts:
                    if let id = data["id"] as? Int32 {
                        let fetch: NSFetchRequest<BlogPosts> = BlogPosts.createFetchRequest()
                        fetch.predicate = NSPredicate(format: "id == %d", id)
                        var blogPostsResults: [BlogPosts]? = nil
                        do {
                            blogPostsResults = try moc.fetch(fetch)
                        } catch {
                            fatalError("Failed to retrieve blogPosts from core data \(error)")
                        }
                        if blogPostsResults?.count == 0 {
                            let post = BlogPosts(context: moc)
                            guard BlogPosts.extractPost(json: data, blogPost: post, context: moc)! else {
                                handleErrorDeserialisingJSON(action: action)
                                break
                            }
                        }
                    break
                    }
                    break
                case wordpressAction.media:
                    if let id = data["id"] as? Int32 {
                        let fetch: NSFetchRequest<MediaDetails> = MediaDetails.createFetchRequest()
                        fetch.predicate = NSPredicate(format: "mediaId == %d", id)
                        var mediaDetailsResults: [MediaDetails]? = nil
                        do {
                            mediaDetailsResults = try moc.fetch(fetch)
                        } catch {
                            fatalError("Failed to retrieve mediaDetails from core data \(error)")
                        }
                        if mediaDetailsResults?.count == 0 {
                            let media = MediaDetails(context: moc)
                            guard MediaDetails.extractMedia(json: data, media: media)! else {
                                handleErrorDeserialisingJSON(action: action)
                                break
                            }
                        }
                        break
                    }
                    break
                case wordpressAction.tags:
                    if let id = data["id"] as? Int32 {
                        let fetch: NSFetchRequest<BlogTags> = BlogTags.createFetchRequest()
                        fetch.predicate = NSPredicate(format: "tagId == %d", id)
                        var blogTagsResults: [BlogTags]? = nil
                        do {
                            blogTagsResults = try moc.fetch(fetch)
                        } catch {
                            fatalError("Failed to retrieve blogTags from core data \(error)")
                        }
                        if blogTagsResults?.count == 0 {
                            let tag = BlogTags(context: moc)
                            guard BlogTags.extractTag(json: data, tag: tag, context: moc)! else {
                                handleErrorDeserialisingJSON(action: action)
                                break
                            }
                        }
                        break
                    }
                    break
                }
            }
        }
        moc.performAndWait {
            do {
            try moc.save()
             dataController?.saveContext()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
        downloadTracker.actionComplete(action: action)
        print("\(action) completed")
        checkIfDownloadsCompleted()
    }

    func handleErrorRetrievingJSON(action: wordpressAction) {
        showAlert(title: "Error retrieving data from blog site", message: "There was an error retrieving the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.")
    }

    func handleErrorDeserialisingJSON(action: wordpressAction) {
        showAlert(title: "Error handling data from blog site", message: "There was an error handling the \(action) data from the blog site. Please try again. If the problem persists please contact the developer at: www.thisnow.software/contact/.")
    }
}


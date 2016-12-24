//
//  localeStruct.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 24/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation

struct wikiPageUrlsForLanguage {
    var parsecUrl: String
    var kilometreUrl: String
    var astronomicalUnitUrl: String
    var lightYearsUrl: String
}

struct LanguageStruct {

    struct wikiPages {
        var parsecName: String
        var kilometreName: String
        var astronomicalUnitName: String
        var lightYearsName: String
    }

    var languageDict: Dictionary = Dictionary<String, wikiPages>()

    init() {
        let en: wikiPages = wikiPages(parsecName: PARSECen, kilometreName: KILOMETREen, astronomicalUnitName: ASTRONOMICALUNITen, lightYearsName: LIGHTYEARen)
        let de: wikiPages = wikiPages(parsecName: PARSECde, kilometreName: KILOMETREde, astronomicalUnitName: ASTRONOMICALUNITde, lightYearsName: LIGHTYEARde)
        languageDict["en"] = en
        languageDict["de"] = de
    }


    func getLanguage() -> String? {
        let country = Locale.current
        return country.languageCode
    }


    func addLanguage(wikiPagesForLanguage: wikiPages, languageISOCode: String) {
 // Not yet implemented
    }


    func checkForLanguage(languageISOCode: String) -> Bool {
        let keyExists = languageDict[languageISOCode] != nil
        return keyExists
    }


    func getPagesForLanguage(languageISOCode: String) -> wikiPages? {
        if checkForLanguage(languageISOCode: languageISOCode) {
            let languageWikiPages = languageDict[languageISOCode]
            return languageWikiPages
        } else {
            return nil
        }
    }

    func buildUrlForLanguage(languageISOCode: String) -> wikiPageUrlsForLanguage {
        let BASEURL = PROTOCOL + languageISOCode + WIKIURL
        var urls = wikiPageUrlsForLanguage(parsecUrl: "", kilometreUrl: "", astronomicalUnitUrl: "", lightYearsUrl: "")
        if let urlsForLanguage = getPagesForLanguage(languageISOCode: languageISOCode) {
            urls.parsecUrl = BASEURL + urlsForLanguage.parsecName
            urls.kilometreUrl = BASEURL + urlsForLanguage.kilometreName
            urls.astronomicalUnitUrl = BASEURL + urlsForLanguage.astronomicalUnitName
            urls.lightYearsUrl = BASEURL + urlsForLanguage.lightYearsName
        }
        return urls
    }
}

//
//  localeStruct.swift
//  DistanceConverter
//
//  Created by Alan Glasby on 24/12/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import Foundation

struct LocaleStruct {

    struct wikiPages {
        var parsecName: String
        var kilometreName: String
        var astronomicalUnitName: String
        var lightYearsName: String
    }

    var localeDict: Dictionary = Dictionary<String, wikiPages>()

    func addLocale(wikiPagesForLocale: wikiPages, languageISOCode: String) {
        
    }

    

}

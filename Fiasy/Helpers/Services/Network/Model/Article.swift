//
//  Article.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import ObjectMapper

class Article: NSObject, Mappable {
    
    var id: Int?
    var titleRU: String?
    var titleENG: String?
    var titleDE: String?
    var titlePT: String?
    var titleES: String?
    var bodyRU: String?
    var bodyENG: String?
    var bodyDE: String?
    var bodyPT: String?
    var bodyES: String?
    var image: String?
    var premium: Bool = true
    var date: String?
    var dayInSeries: Int?
    var category: ArticleCategory?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        titleRU <- map["title_ru"]
        titleENG <- map["title_en"]
        titleDE <- map["title_de"]
        titlePT <- map["title_pt"]
        titleES <- map["title_es"]
        bodyRU <- map["body_ru"]
        bodyENG <- map["body_en"]
        bodyDE <- map["body_de"]
        bodyPT <- map["body_pt"]
        bodyES <- map["body_es"]
        image <- map["image"]
        premium <- map["premium"]
        date <- map["date"]
        dayInSeries <- map["day_in_series"]
        category <- map["category"]
    }
}

class PaginationArticle: NSObject, Mappable {
    
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Article] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        next <- map["next"]
        previous <- map["previous"]
        results <- map["results"]
    }
}

class ArticleCategory: NSObject, Mappable {
    
    var id: Int?
    var name: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

extension String {
    
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}


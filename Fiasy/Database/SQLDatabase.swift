//
//  SQLDatabase.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/2/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SQLite

class SQLDatabase {
    
    static let shared = SQLDatabase()
    public var connection: Connection?
    
    private init() {
        do {
            let dbPath = Bundle.main.path(forResource: "FoodDB", ofType: "db")!
            connection = try Connection(dbPath)
        } catch {
            connection = nil
            let nserror = error as NSError
            print ("Cannot connect to Database. Error is: \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchProducts() {
        var allProducts: [Product] = []
        if let food = try? self.connection?.prepare(Table("C_FOOD")) {
            guard let foods = food else { return }
            for item in foods {
                allProducts.append(Product(row: item))
            }
        }
        UserInfo.sharedInstance.allProducts = allProducts
    }
}

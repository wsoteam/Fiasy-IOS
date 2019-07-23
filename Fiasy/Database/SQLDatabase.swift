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
                guard allProducts.count < 1000 else { break }
                allProducts.append(Product(row: item))
            }
        }
        UserInfo.sharedInstance.allProducts = allProducts.sorted(by: { $0.name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").lowercased() < $1.name.replacingOccurrences(of: "\"", with: "").lowercased() })
        
        DispatchQueue.global(qos: .background).async {
            var products: [Product] = []
            if let second = try? self.connection?.prepare(Table("C_FOOD")) {
                guard let de = second else { return }
                for item in de {
                    products.append(Product(row: item))
                }
            }

            let sorted = products.sorted(by: { $0.name.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").lowercased() < $1.name.replacingOccurrences(of: "\"", with: "").lowercased() })
            DispatchQueue.main.async {
                UserInfo.sharedInstance.allProducts = sorted
            }
        }
    }
    
    func filter(text: String) -> [Product] {
        do {
            var allProducts: [Product] = []
            
            let fullNameArr = text.split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                let fiterCondition = Expression<String>("NAME").lowercaseString.like("%\(item.lowercased().capitalizeFirst)%")
                if let foods = try connection?.prepare(Table("C_FOOD").filter(fiterCondition)) {
                    for item in foods {
                        allProducts.append(Product(row: item))
                    }
                }
            }
            
            if fullNameArr.count > 1 {
                for (index,item) in allProducts.enumerated() where item.name.lowercased().contains(fullNameArr[0].lowercased()) && item.name.lowercased().contains(fullNameArr[1].lowercased()) {
                    allProducts.remove(at: index)
                    allProducts.insert(item, at: 0)
                }
                return allProducts
            }
            return allProducts
        } catch {
            let nserror = error as NSError
            print ("Cannot list / query objects in Table C_FOOD. Error is: \(nserror), \(nserror.userInfo)")
            return []
        }
    }
    
    func getEditProduct(by mealTime: Mealtime) -> Product? {
        do {
            let fiterCondition = Expression<String>("NAME").lowercaseString.like("%\(mealTime.name ?? "")%")
            if let foods = try connection?.prepare(Table("C_FOOD").filter(fiterCondition)) {
                for item in foods {
                    return Product(row: item)
                }
            }
            
        } catch {
            let nserror = error as NSError
            print ("Cannot list / query objects in Table C_FOOD. Error is: \(nserror), \(nserror.userInfo)")
            return nil
        }
        return nil
    }
}

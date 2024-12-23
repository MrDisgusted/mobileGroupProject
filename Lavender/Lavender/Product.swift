//
//  Product.swift
//  Lavender
//
//  Created by BP-36-201-05 on 10/12/2024.
//

import Foundation
import UIKit

//func saveProducts(products: [Product]) {
//    let encoder = JSONEncoder()
//    if let encoded = try? encoder.encode(products) {
//        UserDefaults.standard.set(encoded, forKey: "SavedProducts")
//    }
//}

//func loadProducts() -> [Product]? {
//    if let savedData = UserDefaults.standard.data(forKey: "SavedProducts") {
//        let decoder = JSONDecoder()
//        if let loadedProducts = try? decoder.decode([Product].self, from: savedData) {
//            return loadedProducts
//        }
//    }
//    return nil
//}

enum Category {
    case bodycare
    case cleaning
    case stationary
    case gardening
    case supplements
    case accessories
    case food
    case hygiene
}

struct Ecobar {
    let emission: Double
    let impact: Double
    let sustainability: Double
    let recyclability: Double
    let longjevity: Double
    
    // salem add the equation here so that it calculates the lavender rating
    let lavenderRating = 0
}

struct Product {
    let ID : Int
    let name : String
    let image : Data
    let category : Category
    let description : String
    let price : Double
    let quantity : Int
    let lavender : Ecobar
    let isAvailable : Bool
    let arrivalDay : Int
}



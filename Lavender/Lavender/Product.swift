//
//  Product.swift
//  Lavender
//
//  Created by BP-36-201-05 on 10/12/2024.
//

import Foundation
import UIKit

enum Category {
    case bodycare
    case cleaning
    case stationary
    case gardening
    case supplements
    case accessories
    case food
    case hygiene
    case electronics
    
    var toString: String {
        switch self {
        case .bodycare: return "Bodycare"
        case .cleaning: return "Cleaning"
        case .stationary: return "Stationary"
        case .gardening: return "Gardening"
        case .supplements: return "Supplements"
        case .accessories: return "Accessories"
        case .food: return "Food"
        case .hygiene: return "Hygiene"
        case .electronics: return "Electronics"
        }
    }
}

struct Ecobar {
    let emission: Double
    let impact: Double
    let sustainability: Double
    let recyclability: Double
    let longjevity: Double
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


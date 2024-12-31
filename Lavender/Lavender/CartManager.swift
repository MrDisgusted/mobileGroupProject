import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    var cartItems: [Product] = []
    var quantities: [Int: Int] = [:]

    private func categoryFromString(_ string: String) -> Category {
        switch string.lowercased() {
        case "bodycare": return .bodycare
        case "cleaning": return .cleaning
        case "stationary": return .stationary
        case "gardening": return .gardening
        case "supplements": return .supplements
        case "accessories": return .accessories
        case "food": return .food
        case "hygiene": return .hygiene
        case "electronics": return .electronics
        default: return .bodycare
        }
    }

    private func getCartFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("cart.json")
    }

    func saveCart() {
        let filePath = getCartFilePath()
        let cartData: [String: Any] = [
            "cartItems": cartItems.map { product in
                [
                    "ID": product.ID,
                    "name": product.name,
                    "image": product.image.base64EncodedString(),
                    "category": product.category.toString,
                    "description": product.description,
                    "price": product.price,
                    "quantity": quantities[product.ID, default: 0]
                ]
            }
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: cartData, options: .prettyPrinted)
            try jsonData.write(to: filePath)
            print("Cart saved successfully!")
        } catch {
            print("Error saving cart: \(error)")
        }
    }

    func loadCart() {
        let filePath = getCartFilePath()

        do {
            let jsonData = try Data(contentsOf: filePath)
            if let cartData = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let items = cartData["cartItems"] as? [[String: Any]] {
                cartItems = items.compactMap { itemData in
                    guard
                        let id = itemData["ID"] as? Int,
                        let name = itemData["name"] as? String,
                        let imageBase64 = itemData["image"] as? String,
                        let imageData = Data(base64Encoded: imageBase64),
                        let categoryString = itemData["category"] as? String,
                        let description = itemData["description"] as? String,
                        let price = itemData["price"] as? Double,
                        let quantity = itemData["quantity"] as? Int
                    else {
                        print("Invalid product data: \(itemData)")
                        return nil
                    }

                    quantities[id] = quantity
                    return Product(
                        ID: id,
                        name: name,
                        image: imageData,
                        category: categoryFromString(categoryString),
                        description: description,
                        price: price,
                        quantity: quantity,
                        lavender: Ecobar(emission: 0, impact: 0, sustainability: 0, recyclability: 0, longjevity: 0),
                        isAvailable: true,
                        arrivalDay: 0
                    )
                }
                print("Cart loaded successfully.")
            }
        } catch {
            print("Error loading cart: \(error)")
        }
    }

    func addItem(_ product: Product) {
        if cartItems.firstIndex(where: { $0.ID == product.ID }) != nil {
            quantities[product.ID, default: 0] += 1
        } else {
            cartItems.append(product)
            quantities[product.ID] = 1
        }
        saveCart()
    }

    func removeItem(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.ID == product.ID }) {
            cartItems.remove(at: index)
            quantities[product.ID] = nil
        }
        saveCart()
    }

    func updateQuantity(for product: Product, quantity: Int) {
        if quantity > 0 {
            quantities[product.ID] = quantity
        } else {
            removeItem(product)
        }
        saveCart()
    }

    func calculateTotalPrice() -> Double {
        return cartItems.reduce(0) { total, product in
            let quantity = quantities[product.ID, default: 0]
            return total + (product.price * Double(quantity))
        }
    }
}


import Foundation

enum ClothingType {
    case shirt
    case pants
}

struct ClothingItem: Hashable {
    let type: ClothingType
    let color: String
    
    // Helper method to sort items
    var isShirt: Bool {
        return type == .shirt
    }
    
    var isPants: Bool {
        return type == .pants
    }
    /*
    var isShoes: Bool {
        return type == .shoes
    }
    */
}

// Create items using the struct
let items: Set<ClothingItem> = [
    ClothingItem(type: .shirt, color: "Blue"),
    ClothingItem(type: .shirt, color: "Grey"),
    ClothingItem(type: .pants, color: "White"),
    ClothingItem(type: .pants, color: "Black")
]

// Create filtered sets using filter
let shirts = Set(items.filter { $0.isShirt })
let pants = Set(items.filter { $0.isPants })
/*
// Print methods
print("All Items:")
items.forEach { item in
    print("Type: \(item.type), Color: \(item.color)")
}

print("\nShirts:")
shirts.forEach { shirt in
    print("Color: \(shirt.color)")
}

print("\nPants:")
pants.forEach { pant in
    print("Color: \(pant.color)")
}

*/


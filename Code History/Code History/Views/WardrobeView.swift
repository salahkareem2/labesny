import SwiftUI

struct ClothingItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let icon: String
    let color: String
}

struct WardrobeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingOptions = false
    @State private var showingCamera = false
    @State private var showingManualEntry = false
    @State private var selectedItem: ClothingItem?
    @State private var showingItemDetail = false
    
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
    @State public var mockItems = [
        ClothingItem(name: "Black T-Shirt", type: "Top", icon: "tshirt", color: "Black"),
        ClothingItem(name: "Blue Jeans", type: "Bottom", icon: "rectangle.fill", color: "Blue"),
        ClothingItem(name: "Running Shoes", type: "Footwear", icon: "boot.fill", color: "White"),
        ClothingItem(name: "Winter Jacket", type: "Outerwear", icon: "rectangle.fill", color: "Black"),
        ClothingItem(name: "White Sneakers", type: "Footwear", icon: "boot.fill", color: "White"),
        ClothingItem(name: "Dress Shirt", type: "Top", icon: "tshirt", color: "White")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                
                VStack {
                    // Top navigation bar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Text("WARDROBE")
                            .font(.custom("Helvetica", size: 20))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            showingOptions = true
                        }) {
                            Image(systemName: "plus.circle")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                        }
                        .confirmationDialog("Add Item", isPresented: $showingOptions) {
                            Button("Take Photo") {
                                showingCamera = true
                            }
                            Button("Add Manually") {
                                showingManualEntry = true
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                       
                
                        .sheet(isPresented: $showingManualEntry) {
                            ManualEntryView(mockItems: $mockItems)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Grid of clothing items
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(mockItems) { item in
                                VStack {
                                    Image(systemName: item.icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                        .frame(width: 80, height: 80)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    
                                    Text(item.name)
                                        .font(.custom("Helvetica", size: 14))
                                        .foregroundColor(.white)
                                    
                                    Text(item.type)
                                        .font(.custom("Helvetica", size: 12))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .onTapGesture {
                                    selectedItem = item
                                    showingItemDetail = true
                                }
                            }
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showingItemDetail) {
                    if let item = selectedItem {
                        ClothingItemDetailView(item: item)
                    }
                }
            }
        }
    }
}

struct ClothingItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let item: ClothingItem
    @State private var itemName: String
    @State private var itemType: String
    @State private var itemColor: String
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    let types = ["Top", "Bottom", "Footwear", "Outerwear", "Accessory"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
    init(item: ClothingItem) {
        self.item = item
        _itemName = State(initialValue: item.name)
        _itemType = State(initialValue: item.type)
        _itemColor = State(initialValue: item.color)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Image section
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: item.icon)
                                    .font(.system(size: 100))
                                    .foregroundColor(.white)
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                        }
                        
                        // Details section
                        VStack(spacing: 16) {
                            TextField("", text: $itemName)
                                .placeholder(when: itemName.isEmpty) {
                                    Text("Item Name")
                                        .foregroundColor(.white)
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .tint(.white)
                            
                            Picker("Type", selection: $itemType) {
                                ForEach(types, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .tint(.white)
                            
                            TextField("", text: $itemColor)
                                .placeholder(when: itemColor.isEmpty) {
                                    Text("Color")
                                        .foregroundColor(.white)
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                                .tint(.white)
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .navigationTitle("Item Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Here you would save the changes
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var mockItems: [ClothingItem]
    
    @State private var itemName = ""
    @State private var itemType = "Top"
    @State private var itemColor = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    let types = ["Top", "Bottom", "Footwear", "Outerwear", "Accessory"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Image selection button
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                    }
                    
                    VStack(spacing: 16) {
                        TextField("", text: $itemName)
                            .placeholder(when: itemName.isEmpty) {
                                Text("Item Name")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .tint(.white)
                        
                        Picker("Type", selection: $itemType) {
                            ForEach(types, id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .tint(.white)
                        
                        TextField("", text: $itemColor)
                            .placeholder(when: itemColor.isEmpty) {
                                Text("Color")
                                    .foregroundColor(.white)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                            .tint(.white)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newItem = ClothingItem(
                            name: itemName,
                            type: itemType,
                            icon: getIconForType(itemType),
                            color: itemColor
                        )
                        mockItems.append(newItem)
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .disabled(itemName.isEmpty || itemColor.isEmpty)
                }
            }
        }
    }
    
    private func getIconForType(_ type: String) -> String {
        switch type {
        case "Top": return "tshirt"
        case "Bottom": return "rectangle.fill"
        case "Footwear": return "boot.fill"
        case "Outerwear": return "rectangle.fill"
        case "Accessory": return "circle.fill"
        default: return "square.fill"
        }
    }
}

// Update ImagePicker to handle both camera and photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Add this extension for the placeholder modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
} 

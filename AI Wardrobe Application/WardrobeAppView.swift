//
//  WardrobeAppView.swift
//  AI Wardrobe Application
//
//  Created by macbook on 02/10/26.
//

import SwiftUI
import PhotosUI

// 1. Garment Data Model
struct GarmentItem: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let image: UIImage?
}

struct WardrobeAppView: View {
    // Feature 2: Digital Wardrobe State
    @State private var wardrobeList: [GarmentItem] = [
        GarmentItem(name: "Classic White Shirt", category: "Top", image: UIImage(systemName: "tshirt.fill")),
        GarmentItem(name: "Denim Jeans", category: "Bottom", image: UIImage(systemName: "square.fill"))
    ]
    
    // Feature 1: Camera Capture State
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var newGarmentName: String = ""
    @State private var selectedCategory: String = "Top"
    let categories = ["Top", "Bottom", "Footwear", "Jacket"]
    
    // Feature 3: AI De-clutter State
    @State private var aiSuggestions: [String] = []
    @State private var isAnalyzing = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // --- FEATURE 1: AI DE-CLUTTER RECOMMENDATIONS ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🤖 AI Wardrobe Assistant")
                            .font(.headline)
                        
                        Button(action: runAIDeclutter) {
                            HStack {
                                Image(systemName: "sparkles")
                                Text(isAnalyzing ? "Analyzing Wardrobe..." : "Get De-clutter Suggestions")
                            }
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(isAnalyzing)
                        
                        if !aiSuggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(aiSuggestions, id: \.self) { tip in
                                    HStack(alignment: .top) {
                                        Text("💡")
                                        Text(tip)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // --- FEATURE 2: LIVE CAMERA / GARMENT CAPTURE ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📸 Add New Garment")
                            .font(.headline)
                        
                        TextField("Garment Name (e.g. Black Jacket)", text: $newGarmentName)
                            .textFieldStyle(.roundedBorder)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Label("Select / Capture Photo", systemImage: "camera.fill")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // --- FEATURE 3: REALISTIC DIGITAL WARDROBE ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("👔 My Closet Shelves")
                            .font(.headline)
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(wardrobeList) { item in
                                VStack {
                                    if let img = item.image {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 90)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text(item.name)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    
                                    Text(item.category)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("AI Wardrobe")
            .onChange(of: selectedPhoto) { newItem in
                saveCapturedGarment(item: newItem)
            }
        }
    }
    
    // Logic 1: Image Save Karne Ka Logic
    func saveCapturedGarment(item: PhotosPickerItem?) {
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let name = newGarmentName.isEmpty ? "New Garment" : newGarmentName
                let newGarment = GarmentItem(name: name, category: selectedCategory, image: image)
                
                DispatchQueue.main.async {
                    self.wardrobeList.append(newGarment)
                    self.newGarmentName = ""
                    self.selectedPhoto = nil
                }
            }
        }
    }
    
    // Logic 2: Mock AI Logic (Explain karne ke liye super easy)
    func runAIDeclutter() {
        isAnalyzing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.aiSuggestions = [
                "Suggested for removal: Unused seasonal duplicates found.",
                "Top to Bottom ratio looks balanced (\(self.wardrobeList.count) items total).",
                "Tip: Try pairing your 'Classic White Shirt' with 'Denim Jeans'."
            ]
            self.isAnalyzing = false
        }
    }
}

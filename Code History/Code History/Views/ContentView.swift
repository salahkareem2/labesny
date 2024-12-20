//
//  ContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 10.12.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var weatherService = WeatherService.shared
    @State private var temperature: Double = -20
    @State private var generatedShirt: ClothingItem?
    
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
    func generateShirt(from items: [ClothingItem]) -> ClothingItem? {
        let shirts = items.filter { item in
            item.type == "Top"
        }
        return shirts.randomElement()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                
                // Add vertical temperature slider on right side
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text("\(Int(temperature))°")
                            .font(.custom("Helvetica", size: 14))
                            .foregroundColor(.white)
                            .frame(height: 40)
                        
                        Slider(value: $temperature, in: -20...40, step: 1)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 200)
                            .padding(.vertical, 100)
                            .tint(.white)
                        
                        Spacer()
                    }
                    .padding(.trailing, -70)
                }
                
                VStack {
                    // Top navigation bar with plane and bag buttons
                    HStack {
                        NavigationLink(destination: TripView()) {
                            Image(systemName: "airplane.departure")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        NavigationLink(destination: WardrobeView()) {
                            Image(systemName: "bag.fill.badge.plus")
                                .font(Font.custom("Helvetica", size: 20).weight(.semibold))
                                .padding()
                                .frame(maxWidth: 100)
                                .foregroundColor(.white)
                                .symbolRenderingMode(.multicolor)
                        }
                    }
                    .padding(.horizontal)
                    
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("LABESNY")
                        .padding()
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    
                    // Display outfit
                    VStack(spacing: 30) {
                        if let shirt = generatedShirt {
                            Image(systemName: shirt.icon)
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "tshirt")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                        Image(systemName: "boot.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    // Generate button
                    Button(action: {
                        withAnimation {
                            generatedShirt = generateShirt(from: WardrobeView().mockItems)
                        }
                    }) {
                        Text("Generate")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    Task {
                        await weatherService.getWeather(latitude: 51.5074, longitude: -0.1278)
                        if let weatherTemp = weatherService.temperature {
                            temperature = weatherTemp
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
    @State private var isSidebarOpen = false
    
    let itemName = ["tshirt", "tshirt", "tshirt"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)
    
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
                
                // Sidebar
                HStack {
                    if isSidebarOpen {
                        VStack(alignment: .leading, spacing: 30) {
                            NavigationLink(destination: TripView()) {
                                HStack {
                                    Image(systemName: "airplane.departure")
                                        .foregroundColor(.white)
                                    Text("My Trips")
                                        .foregroundColor(.white)
                                }
                            }
                            
                            NavigationLink(destination: WardrobeView()) {
                                HStack {
                                    Image(systemName: "bag.fill")
                                        .foregroundColor(.white)
                                    Text("My Wardrobe")
                                        .foregroundColor(.white)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 100)
                        .padding(.horizontal)
                        .frame(width: 200)
                        .background(Color.black.opacity(0.5))
                        .transition(.move(edge: .leading))
                    }
                    
                    Spacer()
                }
                .zIndex(1)
                
                // Sidebar toggle button
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isSidebarOpen.toggle()
                            }
                        }) {
                            Image(systemName: isSidebarOpen ? "chevron.left" : "chevron.right")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(8)
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    .padding(.top, 60)
                    Spacer()
                }
                .zIndex(2)
                
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
                    
                    Spacer()
                    
                    // Display three t-shirts with navigation
                    VStack(spacing: 30) {
                        ForEach(0..<itemName.count, id: \.self) { index in
                            NavigationLink(
                                destination: ItemView(itemName: itemName[index], imageName: itemName[index]),
                                label: {
                                    Image(systemName: itemName[index])
                                        .font(.system(size: 80))
                                        .foregroundColor(.white)
                                }
                            )
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Generate button
                    Button(action: {
                        // Generate action will be added later
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
                
                // Logo and title positioned at the top
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("LABESNY")
                        .padding(.top, 4)
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top, 60)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

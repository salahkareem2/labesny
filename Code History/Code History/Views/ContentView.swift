//
//  ContentView.swift
//  Code History
//
//  Created by Omar Aboulazm on 10.12.24.
//

import SwiftUI

struct ContentView: View {

    let itemName = ["tshirt", "tshirt", "tshirt"]
       // "globe", , "tshirt.circle.fill", "cirlcle.square"]
    let mainColor = Color(red: 0/255, green: 0/255, blue: 0/255)

    var body: some View {
        NavigationStack {
            ZStack {
                mainColor.ignoresSafeArea()
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("XXXXXXXX")
                        .padding()
                        .font(.custom("Helvetica", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                VStack {
                    ForEach(0..<itemName.count, id: \.self) { index in
                        NavigationLink(
                            destination: ItemView(itemName: itemName[index], imageName: itemName[index]),
                            label: {
                                Image(systemName: itemName[index])
                                    .padding()
                                    .font(.custom("Helvetica", size: 80))
                                    .foregroundColor(.white)
                            }
                        )
                    }
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

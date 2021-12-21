//
//  ContentView.swift
//  IDAGIO WatchKit Extension
//
//  Created by Francesco Iaccarino on 09/12/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var tapped: Bool = false
    
    var body: some View {
        
        //        NavigationView {
        List{
            NavigationLink(destination: Player(), isActive: $tapped) {
                Button(action :{
                    
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    self.tapped = true
                    
                }) {
                    HStack{
                        Image( uiImage: UIImage(named: "noun-signals")!)
                            .interpolation(.high)
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 21, height: 21, alignment: .trailing)
                        
                        Text("Discover")
                    }
                }.buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Discover")
            }
            
            NavigationLink(destination: Player(), isActive: $tapped) {
                Button(action :{
                   
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    self.tapped = true
                    
                }) {
                    HStack{
                        Image( uiImage: UIImage(named: "noun-moon")!)
                            .interpolation(.high)
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 21, height: 21, alignment: .trailing)
                        
                        Text("Moods")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Moods")
            }
            
            
            NavigationLink(destination: Player(), isActive: $tapped) {
                Button(action :{
                    print("hello")
                    WKInterfaceDevice.current().play(WKHapticType.click)
                    self.tapped = true
                    
                }) {
                    HStack{
                        Image( uiImage: UIImage(named: "noun-vinyl")!)
                        
                            .interpolation(.high)
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 21, height: 21, alignment: .trailing)
                        
                        Text("Curated")
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Curated")
            }
            
            
        }
        .navigationBarTitle(Text("Playlist"))
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//
//    static var previews: some View {
//        ContentView()
//    }
//}

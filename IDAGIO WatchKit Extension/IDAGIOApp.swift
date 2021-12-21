//
//  IDAGIOApp.swift
//  IDAGIO WatchKit Extension
//
//  Created by Francesco Iaccarino on 09/12/21.
//

import SwiftUI

@main
struct IDAGIOApp: App {
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

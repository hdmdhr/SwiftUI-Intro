//
//  SwiftUI_IntroApp.swift
//  SwiftUI Intro
//
//  Created by 胡洞明 on 2021-10-11.
//

import SwiftUI

@main
struct SwiftUI_IntroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

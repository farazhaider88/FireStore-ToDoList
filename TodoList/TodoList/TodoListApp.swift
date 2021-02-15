//
//  TodoListApp.swift
//  TodoList
//
//  Created by Faraz Haider on 10/02/2021.
//

import SwiftUI
import Firebase

@main
struct TodoListApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
    }
}

//
//  UpsyDeskyMenuApp.swift
//  UpsyDeskyMenu
//
//  Created by Vlad Zaharia on 1/4/23.
//

import SwiftUI

@main
struct UpsyDeskyMenuApp: App {
    let manager: UpsyDeskyManager = UpsyDeskyManager()
    @State var currentImage = "chair"
    @State var currentState = "sitting"
    @State var currentHeight = 0.0

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        MenuBarExtra("Currently \(currentState) indefinitely", systemImage: "\(currentImage).fill") {
            Text("Currently \(currentState) indefinitely")

            Text("Desk height: \(String(format: "%.2f", currentHeight))\"")

            Divider()
            
            Button("Sit") {
                manager.setState(state: DeskState.Sitting) {
                    updateState()
                }
            }.keyboardShortcut("d")
                        
            Button("Stand") {
                manager.setState(state: DeskState.Standing) {                    updateState()
                }
            }.keyboardShortcut("u")

            Menu("Stand for...") {
                Button("30 minutes") {
                }

                Button("1 hour") {
                }

                Button("2 hours") {
                }
            }
            
            Divider()
            
            Menu("Preset") {
                Button("One") {
                    manager.runPreset(preset: 1) {}
                }.keyboardShortcut("1")
                
                Button("Two") {
                    manager.runPreset(preset: 2) {}
                }.keyboardShortcut("2")
                
                Button("Three") {
                    manager.runPreset(preset: 3) {}
                }.keyboardShortcut("3")
                
                Button("Four") {
                    manager.runPreset(preset: 4) {}
                }.keyboardShortcut("4")
            }
            
            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
    
    func updateState() {
        currentImage = manager.getStateImage(state: nil)
        currentState = manager.getStateString(state: nil)
        
        manager.fetchHeight(completionHandler: { height in
            currentHeight = height
        })
    }
}

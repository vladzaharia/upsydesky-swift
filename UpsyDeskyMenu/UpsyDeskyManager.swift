//
//  UpsyDeskyManager.swift
//  UpsyDeskyMenu
//
//  Created by Vlad Zaharia on 1/4/23.
//

import Foundation

class UpsyDeskyManager {
    private var currentState = DeskState.Sitting
    let urlBase: String = "http://10.15.10.218"
    
    init() {
        updateState() {}
    }
    
    func updateState(completionHandler: @escaping () -> Void) {
        fetchHeight { ret in
            if ret > 32 {
                self.currentState = DeskState.Standing
            } else {
                self.currentState = DeskState.Sitting
            }
        }
    }
    
    func getStateString(state: DeskState?) -> String {
        var finalState = state
        
        if (state == nil) {
            finalState = self.currentState
        }
        
        if finalState == DeskState.Sitting {
            return "sitting"
        } else {
            return "standing"
        }
    }

    func getStateImage(state: DeskState?) -> String {
        var finalState = state
        
        if (state == nil) {
            finalState = self.currentState
        }
        
        if finalState == DeskState.Sitting {
            return "chair"
        } else {
            return "table.furniture"
        }
    }
    
    func getState() -> DeskState {
        return self.currentState
    }

    func fetchHeight(completionHandler: @escaping (Double) -> Void) {
        let url = URL(string: urlBase + "/sensor/desk_height")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching height: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
             let result = try? JSONDecoder().decode(DeskHeightResponse.self, from: data) {
              completionHandler(result.value)
          }
        })
        
        task.resume()
    }
    
    func setState(state: DeskState, completionHandler: @escaping () -> Void) {
        var preset = 0
        
        if (state == DeskState.Sitting) {
            preset = 1
        } else if (state == DeskState.Standing) {
            preset = 2
        }
        
        self.runPreset(preset: preset) {
            self.currentState = state
            completionHandler()
        }
    }

    func runPreset(preset: Int, completionHandler: @escaping () -> Void) {
        let url = URL(string: urlBase + "/button/desk_preset_\(preset)/press")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with setting preset: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

            completionHandler()
        })
        
        task.resume()
    }
}

struct DeskHeightResponse: Codable {
    var id: String
    var value: Double
    var state: String
}

enum DeskState {
    case Sitting
    case Standing
}



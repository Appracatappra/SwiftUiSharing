//
//  File.swift
//  
//
//  Created by Kevin Mullins on 6/12/24.
//

import Foundation
import UIKit

class SwiftUISharing {
    
    @MainActor static var keyWindow: UIWindow? {
      let allScenes = UIApplication.shared.connectedScenes
      for scene in allScenes {
        guard let windowScene = scene as? UIWindowScene else { continue }
        for window in windowScene.windows where window.isKeyWindow {
           return window
         }
       }
        return nil
    }
}

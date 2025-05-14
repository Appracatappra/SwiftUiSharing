//
//  File.swift
//  
//
//  Created by Kevin Mullins on 6/12/24.
//

import Foundation

#if !os(macOS)
import UIKit
#endif

class SwiftUISharing {
    
    #if os(macOS)
    #else
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
    #endif
}

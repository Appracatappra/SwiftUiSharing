//
//  SharingSheetItem.swift
//  Stuff To Buy (iOS)
//
//  Created by Kevin Mullins on 5/5/21.
//

#if os(iOS)
import Foundation
import SwiftUI
import UIKit

/**
 Holds information about a piece of data to be shared via a `SharingSheet`.
 */
class SharingSheetItem {
    
    // MARK: - Properties
    /// Holds the optional title for the item being shared.
    var title:String = ""
    
    /// Holds an optional, simple, placeholder for the object being shared. This should only be used for items that are very complex.
    var placeholder:Any? = nil
    
    /// The actual data that is being shared by the user.
    var data:Any
    
    // MARK: - Initializers
    /**
     Initializes a new instance of the object.
     
     - Parameter data: The data that is being shared.
     - Parameter title: An optional title for the item being shared.
     - Parameter placeholder: An optional placeholder item that should be used for very complex items.
     */
    init(data:Any, title:String = "", placeholder:Any? = nil) {
        // Initialize
        self.data = data
        self.title = title
        self.placeholder = placeholder
    }
}
#endif

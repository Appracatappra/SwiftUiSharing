//
//  SharingSheetContentProdider.swift
//  Stuff To Buy (iOS)
//
//  Created by Kevin Mullins on 5/5/21.
//

#if os(iOS)
import Foundation
import SwiftUI
import UIKit

/**
 Provides data to be shared via a series of callbacks for `data`, `title` and `placeholder` to support different data for different types of sharing activites (`UIActivity.ActivityType`).
 */
class SharingSheetContentProvider {
    /// The type of a title content provider
    typealias titleContent = (UIActivity.ActivityType?) -> String
    
    /// The type of a data/placeholder provider.
    typealias itemContent = (UIActivity.ActivityType?) -> Any
    
    // MARK: - Properties
    /// Holds the optional title for the item being shared.
    var title:titleContent?
    
    /// Holds an optional, simple, placeholder for the object being shared. This should only be used for items that are very complex.
    var placeholder:itemContent?
    
    /// The actual data that is being shared by the user.
    var data:itemContent
    
    // MARK: - Initializers
    /**
     Initializes a new instance of the object.
     
     - Parameter data: The data that is being shared.
     - Parameter title: An optional title for the item being shared.
     - Parameter placeholder: An optional placeholder item that should be used for very complex items.
     */
    init(data:@escaping itemContent, title:titleContent? = nil, placeholder:titleContent? = nil) {
        // Initialize
        self.data = data
        self.title = title
        self.placeholder = placeholder
    }
}
#endif

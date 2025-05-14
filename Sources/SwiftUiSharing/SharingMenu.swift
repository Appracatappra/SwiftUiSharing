//
//  SharingMenu.swift
//  Stuff To Buy (macOS)
//
//  Created by Kevin Mullins on 5/5/21.
//

#if os(macOS)
import Foundation
import SwiftUI
import AppKit

/**
 Extends `NSSharingService` to provide a **Sharing Menu** on macOS in a SwiftUI multiplatform App. You provide an item to share and the name for the menu item to share or a completion that get's called when the user selects a menu item to provide the data to share, on-the-fly.
 
 ## Example:
 ```swift
 CommandGroup(replacing: .newItem){
     NSSharingService.sharingMenu(title: "Share Shopping List") {
         return MasterDataStore.SharedDataStore.allShoppingLists()
     }
     
     Divider()
     
     ...
 }
 ```
 */
public extension NSSharingService {
    
    /// Creates a **Sharing** submenu with the given title to share the given text using the available options provided on the machine that the user is running the app on.
    ///  ## Example:
    ///  ```swift
    ///  CommandGroup(replacing: .newItem){
    ///     NSSharingService.sharingMenu(itemToShare: "https://appracatappra.com", "Share URL")
    ///  }
    ///  ```
    ///
    /// - Parameters:
    ///   - text: The text value to share with.
    ///   - title: The Title of the sub menu to build.
    ///   - icon: An optional icon to display on the sub menu.
    /// - Returns: The SwiftUI content of the menu.
    public static func sharingMenu(itemToShare text:String, title:String = "Share", icon:Image? = nil) -> some View {
        return Menu(
            content: {
                ForEach(NSSharingService.sharingServices(forItems: [""]), id: \.title) { item in
                    nonisolated(unsafe) let item = item
                    Button(action: { item.perform(withItems: [text]) }) {
                        Image(nsImage: item.image)
                        Text(item.title)
                    }
                }
            },
            label: {
                Text(title)
                if let image = icon {
                    image
                }
            }
        )
    }
    
    
    /// Creates a **Sharing** submenu with the given title to share the given text using the available options provided on the machine that the user is running the app on. The text is generated on-the-fly via a closure when the user selects a menu item.
    ///
    ///  ## Example:
    ///  ```swift
    ///  CommandGroup(replacing: .newItem){
    ///     NSSharingService.sharingMenu(title: "Share Shopping List") {
    ///         return MasterDataStore.SharedDataStore.allShoppingLists()
    ///     }
    ///  }
    ///  ```
    ///
    /// - Parameters:
    ///   - title: The title for the menu.
    ///   - icon: An optional icon to display by the sharing menu.
    ///   - contents: The closure to generate data to share on-the-fly when the user selects an item.
    /// - Returns: The SwiftUI content of the menu.
    public static func sharingMenu(title:String = "Share", icon:Image? = nil, contents:@escaping ()-> String) -> some View {
        return Menu(
            content: {
                ForEach(NSSharingService.sharingServices(forItems: [""]), id: \.title) { item in
                    nonisolated(unsafe) let item = item
                    let text = contents()
                    Button(action: {
                        item.perform(withItems: [text])
                    }) {
                        Image(nsImage: item.image)
                        Text(item.title)
                    }
                }
            },
            label: {
                Text(title)
                if let image = icon {
                    image
                }
            }
        )
    }
}
#endif

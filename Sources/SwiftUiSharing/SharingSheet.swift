//
//  SharingSheet.swift
//  Stuff To Buy (iOS)
//
//  Created by Kevin Mullins on 5/5/21.
//  Based on: https://www.hackingwithswift.com/articles/118/uiactivityviewcontroller-by-example
//  Based on: https://www.hackingwithswift.com/example-code/uikit/how-to-print-using-uiactivityviewcontroller
//

#if os(iOS)
import Foundation
import SwiftUI
import UIKit
import SwiftletUtilities
import Down

/**
 Presents a standard `UIKit` Share Sheet from within a SwiftUI View on iOS or iPad OS. Automatically handles placing the sheet into a Popover on iPadOS.
 
 ## Example:
 ```swift
 Button(action: {
     SharingSheet.openMarkdownPrintSheet(markdown: dataStore.allShoppingLists(asMarkdown:true), simpleText: dataStore.allShoppingLists(), fromX: 245.0, fromY: 32.0)
 }) {
     Image(systemName: "square.and.arrow.up")
         .resizable()
         .foregroundColor(Color("AccentColor"))
 }
 .frame(width: 24.0, height: 24.0)
 .help("Share your Shopping Lists")
 ```
 
 */
public class SharingSheet:NSObject, UIActivityItemSource {
    
    // MARK: - Static Properties
    /// The common, shared SharingSheet controller.
    public static var shared:SharingSheet = SharingSheet()
    
    // MARK: - Static Functions
    /**
     Opens a Share Sheet for the provided list of items.
     
     ## Example:
     ```swift
     Button(action: {
         SharingSheet.openSheet(markdown: dataStore.allShoppingLists(asMarkdown:true), simpleText: dataStore.allShoppingLists(), fromX: 245.0, fromY: 32.0)
     }) {
         Image(systemName: "square.and.arrow.up")
             .resizable()
             .foregroundColor(Color("AccentColor"))
     }
     .frame(width: 24.0, height: 24.0)
     .help("Share your Shopping Lists")
     ```
     
     - Parameter itemsToShare: An array of the items to be shared.
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public static func openSheet(itemsToShare:[Any], activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: activities)
        SwiftUISharing.keyWindow?.rootViewController?.present(activityVC, animated: animated, completion: nil)
        
        if HardwareInformation.isPad {
            let x = (fromX == nil) ? UIScreen.main.bounds.width / 2.1 : CGFloat(fromX!)
            let y = (fromY == nil) ? UIScreen.main.bounds.height / 2.3 : CGFloat(fromY!)
            activityVC.popoverPresentationController?.sourceView = SwiftUISharing.keyWindow
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: 32, height: 32)
        }
    }
    
    /**
     Opens a Share Sheet for the provided text with the option to print the text using a simple style (`UISimpleTextPrintFormatter`).
     
     ## Example:
     ```swift
     Button(action: {
         SharingSheet.openMarkdownPrintSheet(markdown: dataStore.allShoppingLists(asMarkdown:true), simpleText: dataStore.allShoppingLists(), fromX: 245.0, fromY: 32.0)
     }) {
         Image(systemName: "square.and.arrow.up")
             .resizable()
             .foregroundColor(Color("AccentColor"))
     }
     .frame(width: 24.0, height: 24.0)
     .help("Share your Shopping Lists")
     ```
     
     - Parameter textToShare: The text value to be shared.
     - Parameter font: The optional font to use when formatting the text for printing. The default font is a `System Font` sized `18`.
     - Parameter color: The optional foreground color to use when formatting the text for printing. The default color is `Black`.
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public static func openPrintSheet(textToShare:String, font:UIFont = UIFont.systemFont(ofSize: 18), color:UIColor = UIColor.black, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        let str = NSAttributedString(string: textToShare, attributes: attrs)
        let printText = UISimpleTextPrintFormatter(attributedText: str)
        
        openSheet(itemsToShare: [textToShare, printText], activities: activities, animated: animated, fromX: fromX, fromY: fromY)
    }
    
    /**
     Opens a Share Sheet for the provided text with the option to print the text (which has been formatted in Markdown) using a simple style (`UISimpleTextPrintFormatter`).
     
     ## Example:
     ```swift
     Button(action: {
         SharingSheet.openMarkdownPrintSheet(markdown: dataStore.allShoppingLists(asMarkdown:true), simpleText: dataStore.allShoppingLists(), fromX: 245.0, fromY: 32.0)
     }) {
         Image(systemName: "square.and.arrow.up")
             .resizable()
             .foregroundColor(Color("AccentColor"))
     }
     .frame(width: 24.0, height: 24.0)
     .help("Share your Shopping Lists")
     ```
     
     - Parameter markdown: The text (formatted in Markdown) value to be shared.
     - Parameter activities: The optional list of `UIActivity` to pass to the **Sharing Sheet**.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public static func openMarkdownPrintSheet(markdown:String, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        
        do {
            let parser = Down(markdownString: markdown)
            let str = try parser.toAttributedString()
            let printText = UISimpleTextPrintFormatter(attributedText: str)
            
            openSheet(itemsToShare: [str, printText], activities: activities, animated: animated, fromX: fromX, fromY: fromY)
        } catch {
            print("Error formatting text for printing: \(error)")
        }
    }
    
    /**
     Opens a Share Sheet for the provided text with the option to print the text (which has been formatted in Markdown) using a simple style (`UISimpleTextPrintFormatter`).
     
     ## Example:
     ```swift
     Button(action: {
         SharingSheet.openMarkdownPrintSheet(markdown: dataStore.allShoppingLists(asMarkdown:true), simpleText: dataStore.allShoppingLists(), fromX: 245.0, fromY: 32.0)
     }) {
         Image(systemName: "square.and.arrow.up")
             .resizable()
             .foregroundColor(Color("AccentColor"))
     }
     .frame(width: 24.0, height: 24.0)
     .help("Share your Shopping Lists")
     ```
     
     - Parameter markdown: The text (formatted in Markdown) value to be shared.
     - Parameter simpleText: A simply non-formatted text string to provide more sharing options to the user.
     - Parameter activities: The optional list of `UIActivity` to pass to the **Sharing Sheet**.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public static func openMarkdownPrintSheet(markdown:String, simpleText:String, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        
        do {
            let parser = Down(markdownString: markdown)
            let str = try parser.toAttributedString()
            let printText = UISimpleTextPrintFormatter(attributedText: str)
            
            openSheet(itemsToShare: [simpleText, printText], activities: activities, animated: animated, fromX: fromX, fromY: fromY)
        } catch {
            print("Error formatting text for printing: \(error)")
        }
    }
    
    // MARK: - Properties
    /// Holds the data to be shared.
    private var data:Any?
    
    // MARK: - Functions
    /**
     Returns the placehold for the item being shared.
     
     - Parameter activityViewController: The UIActivityViewController being presented.
     - Returns: An object to use as the placeholder.
     */
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        
        if let item = data as? SharingSheetItem {
            // Return placeholder
            return item.placeholder ?? item.data
        } else if let item = data as? SharingSheetContentProvider {
            if let placeholder = item.placeholder {
                return placeholder(.none)
            }
        } else if let placeholder = data {
            return placeholder
        }
        
        // Return default value
        return ""
    }
    
    /**
     Returns the data for the item being shared.
     
     - Parameter activityViewController: The UIActivityViewController being presented.
     - Parameter itemForActivityType: The type of activity to return data for.
     - Returns: An object to use as the data.
     */
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if let item = data as? SharingSheetItem {
            // Return placeholder
            return item.data
        } else if let item = data as? SharingSheetContentProvider {
            return item.data(activityType)
        } else if let data = data {
            return data
        }
        
        // Return default value
        return ""
    }
    
    /**
     Returns the subject for the item being shared.
     
     - Parameter activityViewController: The UIActivityViewController being presented.
     - Parameter itemForActivityType: The type of activity to return the subject for.
     - Returns: An `String` to use as the subject.
     */
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        
        if let item = data as? SharingSheetItem {
            // Return placeholder
            return item.title
        } else if let item = data as? SharingSheetContentProvider {
            if let title = item.title {
                return title(activityType)
            }
        }
        
        // Return default value
        return ""
    }
    
    /**
     Opens a Share Sheet for the item stored inside this instance of the SharingSheet controller.
     
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    private func openSheet(activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: activities)
        SwiftUISharing.keyWindow?.rootViewController?.present(activityVC, animated: animated, completion: nil)
        
        if HardwareInformation.isPad {
            let x = (fromX == nil) ? UIScreen.main.bounds.width / 2.1 : CGFloat(fromX!)
            let y = (fromY == nil) ? UIScreen.main.bounds.height / 2.3 : CGFloat(fromY!)
            activityVC.popoverPresentationController?.sourceView = SwiftUISharing.keyWindow
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: x, y: y, width: 32, height: 32)
        }
    }
    
    /**
     Opens a Share Sheet for the given item.
     
     - Parameter itemToShare: The `SharingSheetItem` item to share.
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public func openSheet(itemToShare:SharingSheetItem, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        data = itemToShare
        
        openSheet(activities: activities, animated: animated, fromX: fromX, fromY: fromY)
    }
    
    /**
     Opens a Share Sheet for the given item.
     
     - Parameter itemToShare: The `SharingSheetContentProvider` item to share.
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public func openSheet(itemToShare:SharingSheetContentProvider, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        data = itemToShare
        
        openSheet(activities: activities, animated: animated, fromX: fromX, fromY: fromY)
    }
    
    /**
     Opens a Share Sheet for the given item, title and placeholder.
     
     - Parameter itemToShare: The item to share.
     - Parameter title: The optional title for the item to share.
     - Parameter placeholder: The optional placeholder for the item to share. You should provide a simple placeholder if the item being shared is complex.
     - Parameter activites: An optional list of app defined activitied to present to the user.
     - Parameter animated: If `true` animate the sheet being displayed
     - Parameter fromX: Optional, if supplied on iPadOS, this will be the `x` location of the popover.
     - Parameter fromY: Optional, if supplied on iPadOS, this will be the `y` location of the popover.
     
     - Remark: If running on iPadOS and either the `fromX` or `fromY` properties are not provided, the popover will be presented from the center of the screen.
     */
    public func openSheet(itemToShare:Any, title:String = "", placeholder:Any? = nil, activities:[UIActivity]? = nil, animated:Bool = true, fromX:Double? = nil, fromY:Double? = nil) {
        data = SharingSheetItem(data: itemToShare, title: title, placeholder: placeholder)
        
        openSheet(activities: activities, animated: animated, fromX: fromX, fromY: fromY)
    }
}
#endif

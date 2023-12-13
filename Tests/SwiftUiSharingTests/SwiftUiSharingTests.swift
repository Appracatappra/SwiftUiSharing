//
//  SwiftUiSharingTests.swift
//  
//
//  Created by Kevin Mullins on 5/14/21.
//

import XCTest
import SwiftUI
@testable import SwiftUiSharing

final class SwiftUiSharingTests: XCTestCase {
    
    func testSwiftUiSharing() {
        #if os(iOS)
        let text = "Hello World"
        let item:SharingSheetItem? = SharingSheetItem(data: text)
        XCTAssert(item != nil)
        #else
        XCTAssert(true)
        #endif
    }
}

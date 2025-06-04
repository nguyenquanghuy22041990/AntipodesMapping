//
//  String.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import Foundation

enum Strings {
    enum Map {
        static let selectLocation = NSLocalizedString("select_location", value: "Select a location", comment: "Default text for primary location label")
        static let errorTitle = NSLocalizedString("error", value: "Error", comment: "Error alert title")
        static let okButton = NSLocalizedString("ok", value: "OK", comment: "OK button title")
    }
    
    enum Error {
        static let noResultFound = NSLocalizedString("no_result_found", value: "No result found", comment: "Error message when no result is found")
    }
} 

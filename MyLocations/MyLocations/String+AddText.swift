//
//  String+AddText.swift
//  MyLocations
//
//  Created by Norman Lopez on 5/22/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text }
    }
}

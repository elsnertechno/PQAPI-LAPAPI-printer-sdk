//
//  Ext.swift
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 6/10/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import UIKit

extension String {
    func length() -> Int {
        return self.count
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func substring(_ location:Int, length:Int) -> String! {
        return (self as NSString).substring(with: NSMakeRange(location, length))
    }
    
    subscript(index: Int) -> String! {
        get {
            return self.substring(index, length: 1)
        }
    }
    
    func location(_ other: String) -> Int {
        return (self as NSString).range(of: other).location
    }
    
    func contains(_ other: String) -> Bool {
        return (self as NSString).contains(other)
    }
    
    // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
    func isNumeric() -> Bool {
        return (self as NSString).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location == NSNotFound
    }
    
    
    var lengthh: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, lengthh) ..< lengthh]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(lengthh, r.lowerBound)),
                                            upper: min(lengthh, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

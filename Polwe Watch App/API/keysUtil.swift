//
//  keysUtil.swift
//  Polwe Watch App
//
//  Created by R on 2023/08/13.
//

import Foundation

//  The ? indicates that the function may return nil if the requested variable isn't found.
func getVariable(name: String) -> String? {
    print("GEtTING KEY")
    if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
        return dict[name] as? String
    }
    return nil
}


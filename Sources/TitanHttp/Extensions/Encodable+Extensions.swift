//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var jsonData: Data? {
        guard let dictionary = dictionary else { return nil }
        return try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }
}

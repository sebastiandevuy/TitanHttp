//
//  File.swift
//  
//
//  Created by Pablo Gonzalez on 25/7/21.
//

import Foundation

// Single case now until further matching to AFError codes
public enum TitanError: Error {
    case afError(description: String)
}

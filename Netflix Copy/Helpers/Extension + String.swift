//
//  Extension + String.swift
//  Netflix Copy
//
//  Created by Mark Goncharov on 23.01.2023.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

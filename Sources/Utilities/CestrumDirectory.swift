//
//  CestrumDirectory.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation

extension URL {
    /// The URL path to Cestrum's directory.
    static var cestrumDirectory: URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("The documents directory could not be found in user domain mask. This should not happen.")
        }
        let directory = path.appendingPathComponent(".cestrum", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            return directory
        } catch {
            fatalError("Failed to create Cestrum's directory. Reason: \(error)")
        }
    }
}

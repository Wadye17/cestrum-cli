//
//  ReadConfigurationFile.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser

extension Data {
    init(configurationPath: URL) throws {
        guard let data = try? Data(contentsOf: configurationPath) else {
            print(Message.error("Failed to read the file because it is malformed or corrupted"))
            throw ExitCode.failure
        }
        self = data
    }
}

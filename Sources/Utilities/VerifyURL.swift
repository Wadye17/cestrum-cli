//
//  VerifyURL.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser

func verifyURL(_ path: String) throws {
    guard let _ = URL(string: path) else {
        print(Message.error("The given file path is malformed"))
        throw ExitCode.failure
    }
}

func formURLfromString(_ pathString: String, havingExtension ext: String) throws -> URL {
    try verifyURL(pathString)
    let fileURL = URL(fileURLWithPath: pathString)
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
        print(Message.error("File '\(fileURL.lastPathComponent)' does not exist"))
        throw ExitCode.failure
    }
    guard !fileURL.pathExtension.isEmpty else {
        print(Message.error("Cannot read the given file because it has no extension"))
        throw ExitCode.failure
    }
    guard fileURL.pathExtension == ext else {
        print(Message.error("Cannot read the given file because it has an unsupported extension '.\(fileURL.pathExtension)'; file must end with '.\(ext)'"))
        throw ExitCode.failure
    }
    return fileURL
}

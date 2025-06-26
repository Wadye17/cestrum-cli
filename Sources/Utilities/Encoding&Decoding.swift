//
//  Encoding&Decoding.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

func encode(configuration: DependencyGraph) throws -> Data {
    guard let encodedData = try? JSONEncoder().encode(configuration) else {
        print(Message.error("Failed to encode the configuration"))
        throw ExitCode.failure
    }
    return encodedData
}

func decode(from path: URL, fileKind: CESCFileKind) throws -> DependencyGraph {
    let data = try Data(configurationPath: path)
    let configuration = try decode(from: data, fileKind: fileKind)
    return configuration
}

func decode(from data: Data, fileKind: CESCFileKind) throws -> DependencyGraph {
    if fileKind == .instance {
        guard let configuration = try? JSONDecoder().decode(DependencyGraph.self, from: data) else {
            print(Message.error("Failed to decode the configuration data"))
            throw ExitCode.failure
        }
        return configuration
    } else {
        guard let description = try? JSONDecoder().decode(GraphDescription.self, from: data) else {
            print(Message.error("Failed to decode the configuration description data"))
            throw ExitCode.failure
        }
        let configuration = try DependencyGraph(description: description)
        return configuration
    }
}

enum CESCFileKind {
    case instance
    case description
}

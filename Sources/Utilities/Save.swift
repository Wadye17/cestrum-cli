//
//  Save.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

func save(_ configuration: DependencyGraph) throws {
    let encodedGraph = try encode(configuration: configuration)
    let configurationName = configuration.namespace
    let configurationFileName = "\(configurationName).cesc"
    try encodedGraph.write(to: .cestrumDirectory.appendingPathComponent(configurationFileName))
}

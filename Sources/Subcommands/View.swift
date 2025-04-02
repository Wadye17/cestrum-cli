//
//  View.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore

struct View: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "view",
        abstract: "Displays (textually — for now) the given configuration."
    )
    
    @Argument(help: "The name of the configuration to view.")
    var configurationName: String
    
    func run() throws {
        let graph = try DependencyGraph.hook(name: configurationName)
        print(Message.graph(graph))
    }
}

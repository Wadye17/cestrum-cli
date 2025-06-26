//
//  Plan.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore
import Prism

struct Plan: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "plan",
        abstract: "Generates and prints a reconfigration process from a reconfiguration formula written in CESR.",
        subcommands: [SyncPlan.self, AsyncPlan.self],
        defaultSubcommand: SyncPlan.self
    )
    
    static func generateConcretePlan(filePath: String) throws -> (graph: DependencyGraph, abstractPlan: AbstractFormula, concretePlan: ConcretePlan)? {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesr")
        let code = try String(contentsOf: fileURL, encoding: .utf8)
        let (graphName, abstractPlan) = try interpret(code)
        let graph = try DependencyGraph.hook(name: graphName)
        let concretePlan: ConcretePlan?
        do {
            concretePlan = try graph.generateConcretePlan(from: abstractPlan)
        } catch {
            print(Message.fullError(error.description))
            return nil
        }
        guard let concretePlan else {
            print(Message.unexpected("The concrete plan was not generated, yet the process is somehow still running, which is unexpected; please contact the developer"))
            return nil
        }
        return (graph, abstractPlan, concretePlan)
    }
}

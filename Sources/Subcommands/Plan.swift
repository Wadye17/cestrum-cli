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
        abstract: "Generates and prints a reconfigration plan from a reconfiguration formula written in CESR."
    )
    
    @Argument(help: "The file name (or path) of the reconfiguration formula.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Shows the reconfiguration formula itself (without the hook expression).")
    var abstract: Bool = false
    
    @Flag(name: [.short, .customLong("k8s")], help: "Shows the sequence of kubernetes commands equivalent to the concrete reconfiguration plan generated from the given reconfiguration formula.")
    var kubernetes: Bool = false
    
    func run() throws {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesr")
        let code = try String(contentsOf: fileURL, encoding: .utf8)
        let (graphName, plan) = CESPInterpreter.interpret(code: code)
        
        let graph = try DependencyGraph.hook(name: graphName)
        
        let concretePlan = graph.generatePlan(from: plan)
        
        if abstract {
            print(Message.plan(header: "Abstract Reconfiguration Formula", body: plan.description))
        }
        
        print(Message.plan(header: "Atomic Plan", body: concretePlan.description))
        
        if kubernetes {
            print(Message.plan(header: "Kubernetes Equivalent", body: concretePlan.kubernetesEquivalent.joined(separator: "\n")))
        }
    }
}

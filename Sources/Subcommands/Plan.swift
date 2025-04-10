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
        let (graphName, plan) = try interpret(code)
        let graph = try DependencyGraph.hook(name: graphName)
        let concretePlan = graph.generatePlan(from: plan)
        if abstract {
            if !plan.isEmpty {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: plan.description))
            } else {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: " - Nothing", isEmpty: true))
            }
        }
        
        if !plan.isTransparent && !plan.isEmpty {
            print(Message.plan(header: "Concrete Plan", body: concretePlan.description))
        } else {
            print(Message.warning("The abstract reconfiguration formula appears to either be empty, or only have dependency management operations (i.e., 'bind' and/or 'release'), which are considered transparent, as they do not have concrete equivalents; the concrete plan will therefore be empty"))
            print(Message.plan(header: "Concrete Plan", body: " - No concrete actions to perform", isEmpty: plan.isTransparent))
        }
        
        let kubernetesEquivalent = concretePlan.kubernetesEquivalent
        
        if kubernetes {
            if !kubernetesEquivalent.isEmpty {
                print(Message.plan(header: "Kubernetes Equivalent", body: kubernetesEquivalent.joined(separator: "\n")))
            } else {
                print(Message.plan(header: "Kubernetes Equivalent", body: " - No kubectl commands to run", isEmpty: true))
            }
        }
    }
}

//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 09/05/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct SyncPlan: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sync",
        abstract: "Generates and prints a reconfigration plan from a reconfiguration formula written in CESR."
    )
    
    @Argument(help: "The file name of (or path to) the reconfiguration formula.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Shows the reconfiguration formula itself (without the hook expression).")
    var abstract: Bool = false
    
    @Flag(name: [.short, .customLong("k8s")], help: "Shows the sequence of kubernetes commands equivalent to the concrete reconfiguration plan generated from the given reconfiguration formula.")
    var kubernetes: Bool = false
    
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
    
    func run() throws {
        guard let (_, abstractPlan, concretePlan) = try? Self.generateConcretePlan(filePath: filePath) else {
            return
        }
        if abstract {
            if !abstractPlan.isEmpty {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: abstractPlan.description))
            } else {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: " - Nothing", isEmpty: true))
            }
        }
        
        if !abstractPlan.isTransparent && !abstractPlan.isEmpty {
            print(Message.plan(header: "Concrete Plan", body: concretePlan.description))
        } else {
            print(Message.warning("The abstract reconfiguration formula appears to either be empty, or only have dependency management operations (i.e., 'bind' and/or 'release'), which are considered transparent, as they do not have concrete equivalents; the concrete plan will therefore be empty"))
            print(Message.plan(header: "Concrete Plan", body: " - No concrete actions to perform", isEmpty: abstractPlan.isTransparent))
        }
        
        if kubernetes {
            let kubernetesEquivalent = concretePlan.kubernetesEquivalent
            if !kubernetesEquivalent.isEmpty {
                print(Message.plan(header: "Kubernetes Equivalent", body: kubernetesEquivalent.joined(separator: "\n")))
            } else {
                print(Message.plan(header: "Kubernetes Equivalent", body: " - No kubectl commands to run", isEmpty: true))
            }
        }
    }
}

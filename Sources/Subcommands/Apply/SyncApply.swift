//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 09/05/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct SyncApply: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sync",
        abstract: "Generates a concrete plan from the given reconfiguration formula written in CESR, and runs it synchronously (sequentially)."
    )
    
    @Argument(help: "The file name of (or path to) the CESR formula to apply.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Ask for the user's confirmation before proceeding. If enabled, the abstract formula will be displayed beforehand.")
    var askConfirmation: Bool = false
    
    @Flag(name: .customLong("no-k8s"), help: "Skips the application of the plan on Kubernetes. Enable only for testing purposes.")
    var withoutKubernetes: Bool = false
    
    func run() throws {
        guard let (graph, plan, concretePlan) = try? Plan.generateConcretePlan(filePath: filePath) else {
            return
        }
        
        if askConfirmation {
            print(Message.info("Here is what will be executed. Please read carefully...", kind: .notice))
            if !plan.isTransparent && !plan.isEmpty {
                print(Message.plan(header: "Concrete Plan", body: concretePlan.description))
            } else {
                print(Message.warning("The abstract reconfiguration formula appears to either be empty, or only have dependency management operations (i.e., 'bind' and/or 'release'), which are considered transparent, as they do not have concrete equivalents; the concrete plan will therefore be empty"))
                print(Message.plan(header: "Concrete Plan", body: " - No concrete actions to perform", isEmpty: plan.isTransparent))
            }
            print("Would you like to proceed? (Y/*)")
            let line = readLine()
            guard line == "Y" else {
                print(Message.info("Reconfiguration cancelled by the user"))
                return
            }
        }
        
        concretePlan.apply(on: graph, onKubernetes: !withoutKubernetes, stdout: nil, stderr: .standardError)
        
        print(Message.success("Applied the plan on configuration '\(graph.namespace)'"))
        
        try save(graph)
        
        print(Message.success("Saved the changes of configuration '\(graph.namespace)'"))
    }
}

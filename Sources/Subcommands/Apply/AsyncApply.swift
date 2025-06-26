//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 09/05/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct AsyncApply: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "async",
        abstract: "Generates a concrete workflow from the given reconfiguration formula written in CESR, and runs it asynchronously (where safe)."
    )
    
    @Argument(help: "The file name of (or path to) the CESR formula to apply.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Ask for the user's confirmation before proceeding. If enabled, the abstract formula will be displayed beforehand.")
    var askConfirmation: Bool = false
    
    @Flag(name: .customLong("no-k8s"), help: "Skips the application of the plan on Kubernetes. Enable only for testing purposes.")
    var withoutKubernetes: Bool = false
    
    func run() async throws {
        guard let (graph, formula, workflow) = try? AsyncPlan.generateConcreteWorkflow(filePath: filePath) else {
            return
        }
        
        if askConfirmation {
            print(Message.info("Here is what will be executed. Please read carefully...", kind: .notice))
            if !formula.isTransparent && !formula.isEmpty {
                print(workflow.dotTranslation)
            } else {
                print(Message.warning("The abstract reconfiguration formula appears to either be empty, or only have dependency management operations (i.e., 'bind' and/or 'release'), which are considered transparent, as they do not have concrete equivalents; the concrete plan will therefore be empty"))
                print(Message.plan(header: "Concrete Workflow", body: " - No concrete actions to perform", isEmpty: formula.isTransparent))
            }
            print("Would you like to proceed? (Y/*)")
            let line = readLine()
            guard line == "Y" else {
                print(Message.info("Reconfiguration cancelled by the user"))
                return
            }
        }
        
        if #available(macOS 13.0, *) {
            try await workflow.apply(on: graph, forTesting: withoutKubernetes, stdout: nil, stderr: nil)
            print(Message.success("Applied the workflow on configuration '\(graph.namespace)'"))
            try save(graph)
            print(Message.success("Saved the changes of configuration '\(graph.namespace)'"))
        } else {
            print(Message.unavailable("The asynchronous execution of reconfigurations is not available on this platform; it requires macOS 13 or later"))
            throw ExitCode.failure
        }
    }
}

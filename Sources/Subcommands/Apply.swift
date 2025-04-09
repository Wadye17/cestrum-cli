//
//  Apply.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore
import Prism

struct Apply: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "apply",
        abstract: "Applies the given CESR reconfiguration formula."
    )
    
    @Argument(help: "The file name (or path) of the CESR formula to apply.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Ask for the user's confirmation before proceeding. If enabled, the abstract plan will be displayed beforehand.")
    var askConfirmation: Bool = false
    
    @Flag(name: .customLong("without-k8s"), help: "Skips the application of this plan on Kubernetes. Enable only for testing purposes.")
    var withoutKubernetes: Bool = false
    
    func run() throws {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesr")
        let code = try String(contentsOf: fileURL, encoding: .utf8)
        let (graphName, plan) = try interpret(code)
        let graph = try DependencyGraph.hook(name: graphName)
        let concretePlan = graph.generatePlan(from: plan)
        
        if askConfirmation {
            print(Message.notice("Here is what will be executed. Please read carefully."))
            print(Message.plan(header: "Concrete Plan", body: concretePlan.description))
            print("Would you like to proceed? (Y/*)")

            let line = readLine()
            guard line == "Y" else {
                print(Message.notice("Reconfiguration cancelled by the user."))
                return
            }
        }
        
        concretePlan.apply(on: graph, onKubernetes: !withoutKubernetes, stdout: nil, stderr: nil, timeInterval: 2)
        
        print(Message.success("Applied the plan on configuration '\(graph.namespace)' !"))
        
        try save(graph)
        
        print(Message.success("Saved the changes of configuration '\(graph.namespace)' !"))
    }
}

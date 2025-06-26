//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 09/05/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct AsyncPlan: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "async",
        abstract: "Generates and displays a reconfigration workflow that can be run in parallel, from a reconfiguration formula written in CESR."
    )
    
    @Argument(help: "The file name of (or path to) the reconfiguration formula.")
    var filePath: String
    
    @Flag(name: .shortAndLong, help: "Shows the reconfiguration formula itself (without the hook expression).")
    var abstract: Bool = false
    
    static func generateConcreteWorkflow(filePath: String) throws -> (graph: DependencyGraph, formula: AbstractFormula, workflow: ConcreteWorkflow)? {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesr")
        let code = try String(contentsOf: fileURL, encoding: .utf8)
        let (graphName, formula) = try interpret(code)
        let graph = try DependencyGraph.hook(name: graphName)
        let workflow: ConcreteWorkflow?
        do {
            workflow = try graph.generateConcreteWorkflow(from: formula)
        } catch {
            print(Message.fullError(error.description))
            return nil
        }
        guard let workflow else {
            print(Message.unexpected("The concrete plan was not generated, yet the process is somehow still running, which is unexpected; please contact the developer"))
            return nil
        }
        return (graph, formula, workflow)
    }
    
    func run() throws {
        guard let (_, formula, workflow) = try? Self.generateConcreteWorkflow(filePath: filePath) else {
            return
        }
        if abstract {
            if !formula.isEmpty {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: formula.description))
            } else {
                print(Message.plan(header: "Abstract Reconfiguration Formula", body: " - Nothing", isEmpty: true))
            }
        }
        
        if !formula.isTransparent && !formula.isEmpty {
            // graphviz generation and display
            render(from: workflow.dotTranslation)
            print(Message.success("Workflow generated and rendered"))
        } else {
            print(Message.warning("The abstract reconfiguration formula appears to either be empty, or only have dependency management operations (i.e., 'bind' and/or 'release'), which are considered transparent, as they do not have concrete equivalents; the concrete plan will therefore be empty"))
            print(Message.plan(header: "Concrete Workflow", body: " - No concrete actions to perform", isEmpty: formula.isTransparent))
        }
    }
}

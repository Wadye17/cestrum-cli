//
//  Interpret.swift
//  cestrum-cli
//
//  Created by Wadÿe on 08/04/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

func interpret(_ code: String) throws -> (graphName: String, plan: AbstractPlan) {
    let interpretationResult = CESRInterpreter.interpret(code: code)
    guard let (graphName, plan) = try? interpretationResult.get() else {
        guard case .failure(let errors) = interpretationResult else {
            print(Message.unexpected("The interpretation did not succeed, but the error(s) could not be retrieved; please contact the developer"))
            throw ExitCode.failure
        }
        print(Message.fullError("Interpretation unsuccessful. \(errors.count) error(s) found:"))
        for error in errors {
            print(Message.interpretationError(error))
        }
        throw ExitCode.failure
    }
    return (graphName, plan)
}

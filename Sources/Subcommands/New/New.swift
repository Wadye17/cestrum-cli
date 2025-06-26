//
//  New.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore

struct New: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "new",
        abstract: "Registers a new configuration.",
        subcommands: [Empty.self, Register.self],
        defaultSubcommand: Register.self
    )
}

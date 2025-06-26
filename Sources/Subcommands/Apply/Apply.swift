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
        abstract: "Applies the given CESR reconfiguration formula.",
        subcommands: [SyncApply.self, AsyncApply.self],
        defaultSubcommand: SyncApply.self
    )
}

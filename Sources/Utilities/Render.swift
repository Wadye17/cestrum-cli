//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 09/05/2025.
//

import Foundation
import AppKit

func render(from dotCode: String) {
    let fileManager = FileManager.default
    let tempDir = fileManager.temporaryDirectory
    let dotURL = tempDir.appendingPathComponent("graph.dot")
    let pngURL = tempDir.appendingPathComponent("graph.png")

    do {
        try dotCode.write(to: dotURL, atomically: true, encoding: .utf8)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["dot", "-Tpng", dotURL.path, "-o", pngURL.path]

        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            print(Message.error("Rendering failed"))
            return
        }

        // Open the resulting image
        NSWorkspace.shared.open(pngURL)
    } catch {
        print(Message.error("\(error)"))
    }
}

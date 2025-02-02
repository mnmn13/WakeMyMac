// Copyright 2025 Nikita Moshyn
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import ArgumentParser


struct WakeMyMac: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Prevent your macOS device from sleeping with advanced scheduling and configuration options.",
                                                    subcommands: [Start.self, Stop.self, Status.self, WakeDaemon.self, AlwaysActiveCommand.self, AlwaysActiveDaemon.self],
                                                    defaultSubcommand: nil)
    @Flag(name: .shortAndLong, help: "Show the current Wake version.")
    var version: Bool = false
    
    func run() throws {
        printVersion()
    }
    
    private func printVersion() {
        if version {
            cprint("WakeMyMac version: \(appVersion)", .white)
        }
    }
}

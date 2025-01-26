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

struct AlwaysActiveStatus: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "status", abstract: "Check the status of the Always Active session")
    
    @Flag(name: .shortAndLong, help: "Enable debug mode for additional details")
    var debug: Bool = false
    
    func run() throws {
        if let status = DmnService.alwaysActiveDaemonStatus() {
            cprint("Always Active Session started at: \(status.startDate.formatted())")
            
            if status.remainingTime != nil {
                cprint(status.getTimeRemainingFormatted(), .green)
            } else {
                cprint("Session is running indefinitely", .green)
            }
            
            if debug, let pid = StorService.loadAlwaysActiveSession()?.daemonID {
                dprint("Daemon id: \(pid)", debug)
            }
        } else {
            cprint("No active daemon found", .yellow)
        }
    }
}

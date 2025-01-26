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

struct AlwaysActiveStart: ParsableCommand {
    
    static var configuration = CommandConfiguration(commandName: "start", abstract: "Start an always active session.")
    
    @Flag(name: .shortAndLong, help: "Force start if another session is active.")
    var force: Bool = false
    
    func run() throws {
        if !A11yService.isAccessibilityEnabled() {
            cprint("AlwaysActive requires accessibility access", .warning)
            if askForConfirmation("Do you want to open settings?") {
                A11yService.openAccessibilitySettings()
            }
        } else {
            startAlwaysActiveDeamon()
        }
    }
    
    private func startAlwaysActiveDeamon() {
        setupSignalHandler()
        
        let daemon = DmnService.createBackgroundDaemon()
        
        daemon.arguments = ["alwaysActive-wake-daemon", "--start"]
        let pipe = Pipe()
        daemon.standardOutput = pipe
        
        do {
            try daemon.run()
            
        #if DEBUG
            cprint("Always active daemon successfully started with PID: \(daemon.processIdentifier)", .success)
        #endif
            let session = AlwaysActiveSession(daemonID: daemon.processIdentifier)
            StorService.saveAlwaysActiveSession(session)
            
            RunLoop.main.run()
        } catch {
            cprint("Failed to start always active session: \(error.localizedDescription)", .error)
        }
    }
    
    private func setupSignalHandler() {
        SigService.setupSignalHandler {
            cprint("Always active session started successfully!", .success)
            killSelf()
        } _: {
            cprint("Failed to start always active session.", .error)
            dprint("Killing deamon")
            StorService.deleteAlwaysActiveSession()
            killSelf()
        }
    }
}

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
import IOKit.pwr_mgt

final class WakeDaemon: WakeSessionManager, ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "wake-daemon",
                                                    abstract: "Daemon process to manage macOS sleep prevention session.")
    
    @Flag(help: "Start the wake session.")
    var start: Bool = false
    
    @Option(name: .shortAndLong, help: "Duration in seconds.")
    var duration: TimeInterval?
    
    private var assertionID: IOPMAssertionID = 0
    
    func run() throws {
        guard savedSessionExists() else {
            send(.failure)
            return
        }
        
        if start {
            dprint("Demon starting")
            startWakeSession(duration: duration)
        }
    }
    
    private func startWakeSession(duration: TimeInterval?) {
        
        let reason = Constants.assertionName.value as CFString
        let result = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                 IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                 reason,
                                                 &assertionID)
        
        guard result == kIOReturnSuccess else {
            print("Failed to create assertion: \(result)")
            send(.failure)
            return
        }
        
        guard saveAssertion(id: assertionID) else { send(.failure); return }

        // Set termination duration if persist
        if let duration = duration {
            DispatchQueue.global().asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.stopWakeSession()
            }
        }
        
        // Send signal to parent process that Wake Deamon started successfuly
        send(.success)
        
        
        // Hold the process
        RunLoop.main.run()
    }
    
    func stopWakeSession() {
        releaseSession()
        killSelf()
    }
}

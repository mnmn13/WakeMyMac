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

struct AlwaysActiveStop: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "stop", abstract: "")
    
    @Flag(name: .shortAndLong, help: "")
    var force: Bool = false
    
    func run() throws {
        guard let session = StorService.loadAlwaysActiveSession() else {
            cprint("No active session to stop", .warning)
            return
        }
        printDebugDaemonStatus(session)
        
//        if force {
//            send(.kill, session.daemonID)
//        } else {
            send(.terminate, session.daemonID)
//        }
        StorService.deleteAlwaysActiveSession()
        guard !daemonIsActive(session: session) else {
            cprint("Error, could not stop daemon. Try stop -f", .error)
            return
        }
        cprint("Daemon stopped successfully", .success)
    }
    
    private func printDebugDaemonStatus(_ session: AlwaysActiveSession) {
        let daemonIsActive = daemonIsActive(session: session)
        
        if daemonIsActive {
            dprint("Found active daemon with id: \(session.daemonID)")
        } else {
            dprint("No active daemon found")
        }
    }
    
    private func daemonIsActive(session: AlwaysActiveSession) -> Bool {
        kill(session.daemonID, 0) == 0
    }
}

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

struct Status: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Check the status of the current wake session.")
    
    func run() throws {
        if let status = WakeManager.current.status() {
            print("Session started at: \(status.startTime.formatted())")
            
            if let remaining = status.remainingTime {
                print("Time remaining: \(formatDuration(remaining))")
            } else {
                print("Session is running indefinitely.")
            }
        } else {
            print("No active wake session.")
        }
    }
    
    func formatDuration(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

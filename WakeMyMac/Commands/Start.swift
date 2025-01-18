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

struct Start: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Start a wake session.")
    
    @Argument(help: "Duration of the session (e.g., '1h', '120min'). Leave empty for indefinite.")
    var duration: String?
    
    @Flag(name: .shortAndLong, help: "Force start even if another session is active.")
    var force: Bool = false
    
    func run() throws {
        guard let duration else {
            WakeManager.current.start(force: force)
            return
        }
        
        guard let interval = parseDuration(duration) else { throw ValidationError("Invalid duration format. Use '1h', '120min', or similar.") }
        WakeManager.current.start(duration: interval, force: force)
        let prompt = "Wake session started for \(duration)."
        print(prompt)
        logger.info("\(prompt)")
    }
    
    private func parseDuration(_ input: String) -> TimeInterval? {
        let regex = try! NSRegularExpression(pattern: #"(?:(\d+)h)?(?:(\d+)m)?"#)
        guard let match = regex.firstMatch(in: input, range: NSRange(input.startIndex..., in: input)) else {
            return nil
        }

        let hours = Range(match.range(at: 1), in: input).flatMap { Int(input[$0]) } ?? 0
        let minutes = Range(match.range(at: 2), in: input).flatMap { Int(input[$0]) } ?? 0

        return TimeInterval(hours * 3600 + minutes * 60)
    }
}

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

struct AlwaysActiveCommand: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "alwaysActive",
                                                    abstract: "Manages an always-active session that simulates key presses to prevent system inactivity.",
                                                    discussion: """
                                                    The `alwaysActive` command initiates a session that ensures your system remains active. \
                                                    If no user activity is detected for 4 minutes, the session will automatically simulate a key press \
                                                    to prevent the system from sleeping or locking the screen.
                                                    """,
                                                    subcommands: [AlwaysActiveStart.self,
                                                                  AlwaysActiveStop.self,
                                                                  AlwaysActiveStatus.self],
                                                    aliases: ["aa"])
    
    func run() throws {}
    
}

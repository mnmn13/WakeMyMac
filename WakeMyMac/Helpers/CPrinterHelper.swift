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

enum ConsoleColor: String {
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case orange = "\u{001B}[38;5;214m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"
    case reset = "\u{001B}[0m"
}

enum OutputState {
    case success
    case warning
    case error
    
    case debug
    
    var prefix: String {
        switch self {
        case .success: ""
        case .warning: "Warning"
        case .error: "Error"
        case .debug: "Debug"
        }
    }
    
    var color: ConsoleColor {
        switch self {
        case .success: .green
        case .warning: .yellow
        case .error: .red
        case .debug: .orange
        }
    }
}

// Color print
func cprint(_ message: String, _ color: ConsoleColor = .reset) {
    print("\(color.rawValue)\(message)\(ConsoleColor.reset.rawValue)")
}

func cprint(_ message: String, _ state: OutputState) {
    var prefix = state.prefix
    
    // If == success, we don't want to add (:)
    if state != .success {
        prefix += ": "
    }
    
    cprint("\(prefix)\(message)", state.color)
}

// Debug print
func dprint(_ message: String,_ debugFlag: Bool = false) {
    if debugFlag {
        cprint(message, .debug)
        return
    }
#if DEBUG
    cprint(message, .debug)
#endif
}

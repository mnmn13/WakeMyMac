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

// MARK: - Main Functionality
/// Prompts the user for a yes/no confirmation.
///
/// This function ensures:
/// - The `message` is non-empty and reasonable in length.
/// - The user's input is valid (`y`, `yes`, `n`, `no`).
///
/// Logs are generated at each step, including invalid inputs and confirmation outcomes.
///
/// - Parameter message: The message to display to the user.
/// - Returns: `true` if the user confirms, `false` otherwise.
func askForConfirmation(_ message: String) -> Bool {
    // Ensure the message is not empty; otherwise, log and return false
    guard !message.isEmpty else {
        logger.critical("Failed to ask for confirmation. Message is empty")
        return false
    }
    
    // Ensure the message length is reasonable for console readability
    guard message.count < 100 else {
        logger.critical("Message is too long and might not be readable. Preview: \(message.prefix(100))...")
        return false
    }
    
    // Prompt the user
    print("\(message) (y/n): ", terminator: "")
    
    while true {
        // Ensure user input is trimmed and formatted properly
        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !input.isEmpty else {
            logger.warning("Empty input detected. Prompting user again.")
            invalidInputPrint()
            continue
        }
        
        // Validate input and return appropriate result
        switch input {
        case "y", "yes":
            logger.info("User confirmed action with input \(input).")
            return true
        case "n", "no":
            logger.info("User declined action with input \(input).")
            return false
        default:
            logger.warning("Invalid input detected: \(input). Prompting user again.")
            invalidInputPrint()
        }
    }
}

// MARK: - Helper Function
/// Prints a standard message for invalid input.
///
/// This function is used whenever the user enters something other than `y`, `yes`, `n`, or `no`.
fileprivate func invalidInputPrint() {
    print("Invalid input. Please enter 'y' or 'n'.")
}

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
import Cocoa

let KEService = KeyboardEventService.shared

final class KeyboardEventService {
    
    static let shared = KeyboardEventService()
    
    private var activityTimer: Timer?
    
    private init() {}
    
    // MARK: - Public Methods
    /// Starts the keyboard event activity by scheduling a timer.
    func startActivity() {
        // Prevent multiple timers from being scheduled
        guard activityTimer == nil else { dprint("Activity timer is already running."); return }
        
        // Schedule the timer
        activityTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            self.generateKeyboardEvent()
        })
        
        // Immediately trigger the event
        generateKeyboardEvent()
        
        // Ensure the timer is added to the common run loop mode
        if let activityTimer {
            RunLoop.current.add(activityTimer, forMode: .common)
        }
        
        dprint("Activity timer started.")
    }
    
    /// Stops the keyboard event activity by invalidating the timer.
    func stopActivity() {
        guard let activityTimer else { dprint("No active timer to stop."); return }
        activityTimer.invalidate()
        self.activityTimer = nil
        dprint("Activity timer stopped.")
    }
    
    // MARK: - Private Methods
    /// Generates a keyboard event for the F13 key.
    private func generateKeyboardEvent() {
        let f13KeyCode: CGKeyCode = 105
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: f13KeyCode, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: f13KeyCode, keyDown: false)
        guard let keyUp, let keyDown else { return
        }
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
        dprint("F13 triggered.")
    }
}

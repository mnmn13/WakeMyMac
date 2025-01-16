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

final class WakeManager: WakeSessionManager {
    
    static let current = WakeManager()
    
    private override init() {
        super.init()
    }
    
    /// Start function will override any existing
    func start(duration: TimeInterval? = nil, force: Bool = false) {
        // Stop any active sestion
        if sessionIsActive(), !force {
            logger.info("Attempting to start a new session while another session is active.")
            if askForConfirmation("Do you want to overwrite the current session?") {
                stop()
                logger.info("User chose to overwrite the active session.")
            } else {
                logger.info("User chose not to overwrite the active session.")
                return
            }
        }
        
        
        let reason = "Prevent Sleep" as CFString
        var newAssertionID: IOPMAssertionID = 0
        
        let result = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                 IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                 reason,
                                                 &newAssertionID)
        
        if result == kIOReturnSuccess {
            logger.info("Successfully created an assertion with ID: \(newAssertionID)")
            let newSession = WakeSession(assertionID: newAssertionID, duration: duration)
            saveSession(newSession)
        } else {
            logger.error("Failed to create assertion: \(result)")
            releaseSession()
        }
        
    }
    
    func stop() {
        guard let session = getCurrentSession() else {
            logger.info("No active session to stop.")
            return
        }

        let result = IOPMAssertionRelease(session.assertionID)
        if result == kIOReturnSuccess {
            logger.info("Successfully released assertion with ID: \(session.assertionID)")
            releaseSession()
        } else {
            logger.error("Failed to release assertion: \(result)")
        }
    }
    
    func status() -> (startTime: Date, remainingTime: TimeInterval?)? {
        guard let sessionData = getCurrentSession() else { return nil }
        if let duration = sessionData.duration {
            let elapsed = Date().timeIntervalSince(sessionData.startTime)
            return (sessionData.startTime, max(duration - elapsed, 0))
        }
        return (sessionData.startTime, nil)
    }
}

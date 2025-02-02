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
import OSLog

class WakeSessionManager {
    
    private lazy var sessionFilePath = getSessionFilePath()
    private var session: WakeSession?
    
    init() {
        guard savedSessionExists() else {
            logger.info("Saved session is not detected.")
            
            dprint("Saved session is not detected")
            return
        }
        session = retrieveSavedSession()
    }
    
    
    private func getSessionFilePath() -> URL {
        if #available(macOS 13.8, *) {
            return FileManager.default.homeDirectoryForCurrentUser.appending(path: Constants.wakeSession.value)
        } else {
            return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(Constants.wakeSession.value)
        }
    }
    
    func getCurrentSession() -> WakeSession? {
        session
    }
    
    func refreshSession() {
        self.session = retrieveSavedSession()
    }
    
    private func retrieveSavedSession() -> WakeSession? {
        do {
            let data = try Data(contentsOf: sessionFilePath)
            let decoder = JSONDecoder()
            let session = try decoder.decode(WakeSession.self, from: data)
            return session
        } catch {
            logger.error("Failed to load session: \(error.localizedDescription)")
        }
        return nil
    }
    
    func sessionIsActive() -> Bool {
        let status = session != nil
        logger.info("Session status: \(status)")
        guard let daemonID = session?.deamonID else { return false }
        guard send(.isActive, daemonID) == .success else { return false }
        return status
    }
    
    func savedSessionExists() -> Bool {
        let status = FileManager.default.fileExists(atPath: getSessionFilePath().path)
        logger.info("Saved session exist: \(status)")
        return status
    }
    
    func saveSession(_ session: WakeSession) throws {
        logger.info("Attempting to save new session")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(session)
            deleteFileIfExists()
            try data.write(to: sessionFilePath)
        } catch {
            logger.error("Failed to save session: \(error.localizedDescription)")
            throw(error)
        }
        
        self.session = session
    }
    
    func saveSession(_ daemonID: Int32, duration: TimeInterval?) {
        let session = WakeSession(deamonID: daemonID, duration: duration)
        try? saveSession(session)
    }
    
    private func deleteFileIfExists() {
        guard savedSessionExists() else {
            logger.info("Saved session is not exist.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: sessionFilePath)
            logger.info("Session file was successfyly removed")
        } catch {
            logger.error("Failed to delete session file: \(error.localizedDescription)")
        }
    }
    
    func releaseSession() {
        deleteFileIfExists()
        session = nil
    }
    
    /// Saves IOPMAssertionID to existing saved session
    /// Returns result as a bool
    @discardableResult
    func saveAssertion(id: IOPMAssertionID) -> Bool {
        guard var session else { return false }
        
        do {
            session.assertionID = id
            releaseSession()
            try saveSession(session)
            return true
        } catch {
            return false
        }
    }
}

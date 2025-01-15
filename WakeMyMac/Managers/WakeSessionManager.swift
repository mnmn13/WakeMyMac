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
        guard FileManager.default.fileExists(atPath: getSessionFilePath().path) else {
            logger.info("Saved session is not detected.")
            return
        }
        
        do {
            let data = try Data(contentsOf: sessionFilePath)
            let decoder = JSONDecoder()
            session = try decoder.decode(WakeSession.self, from: data)
        } catch {
            logger.error("Failed to load session: \(error.localizedDescription)")
        }
    }
    
    private func getSessionFilePath() -> URL {
        FileManager.default.homeDirectoryForCurrentUser.appending(path: Constants.wakeSession.value)
    }
    
    func getCurrentSession() -> WakeSession? {
        session
    }
    
    func sessionIsActive() -> Bool {
        let status = session != nil
        logger.info("Session status: \(status)")
        return status
    }
    
    func savedSessionExists() -> Bool {
        let status = FileManager.default.fileExists(atPath: getSessionFilePath().path)
        logger.info("Saved session exist: \(status)")
        return status
    }
    
    func saveSession(_ session: WakeSession) {
        logger.info("Attempting to save new session")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(session)
            try data.write(to: sessionFilePath)
        } catch {
            logger.error("Failed to save session: \(error.localizedDescription)")
            
        }
        
        self.session = session
    }
    
    func deleteFileIfExists() {
        logger.info("")
    }
    
    func releaseSession() {
        deleteFileIfExists()
        session = nil
    }
}

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

let StorService = StorageService.shared

final class StorageService {
    
    static let shared = StorageService()
    
    private let folderName = ".wake"
    
    private var hiddenFolderURL: URL {
        let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
        return homeDirectory.appendingPathComponent(folderName)
    }
    
    private let queue = DispatchQueue(label: "com.wakeCLI.fileServiceQueue", attributes: .concurrent)
    
    private let fileManager: FileManager
    
    private init() {
        self.fileManager = .default
    }
    
    // MARK: - Core
    private func saveFile<T: Encodable>(fileType: FileType, content: T) throws {
        try queue.sync(flags: .barrier) {
            try ensureHiddenFolderExists()
            let fileURL = hiddenFolderURL.appendingPathComponent(fileType.fileName)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(content)
            try data.write(to: fileURL, options: .atomic)
        }
    }
    
    private func loadFile<T: Decodable>(fileType: FileType, as type: T.Type) throws -> T {
        return try queue.sync {
            let fileURL = hiddenFolderURL.appendingPathComponent(fileType.fileName)
            
            guard fileManager.fileExists(atPath: fileURL.path) else {
                throw StorageServiceError.fileNotFound(fileType.fileName)
            }
            
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
    }
    
    private func deleteFile(fileType: FileType) throws {
        try queue.sync(flags: .barrier) {
            let fileURL = hiddenFolderURL.appendingPathComponent(fileType.fileName)
            
            guard fileManager.fileExists(atPath: fileURL.path) else {
                // If the file doesn't exist, do nothing
                return
            }
            
            try fileManager.removeItem(at: fileURL)
            try cleanupHiddenFolderIfEmpty()
        }
    }
    
    private func ensureHiddenFolderExists() throws {
        if !fileManager.fileExists(atPath: hiddenFolderURL.path) {
            try fileManager.createDirectory(at: hiddenFolderURL, withIntermediateDirectories: true, attributes: [
                .posixPermissions: 0o700 // Только владелец может читать, писать и выполнять
            ])
        }
    }
    
    private func cleanupHiddenFolderIfEmpty() throws {
        let files = try fileManager.contentsOfDirectory(atPath: hiddenFolderURL.path)
        if files.isEmpty {
            try fileManager.removeItem(at: hiddenFolderURL)
        }
    }
    
    // MARK: - Public
    
    func wakeSessionIsActive() -> Bool {
        return queue.sync {
            let fileURL = hiddenFolderURL.appendingPathComponent(FileType.wakeSession.fileName)
            return fileManager.fileExists(atPath: fileURL.path)
        }
    }
    
    func alwaysActiveSessionIsActive() -> Bool {
        return queue.sync {
            let fileURL = hiddenFolderURL.appendingPathComponent(FileType.alwaysActiveSession.fileName)
            return fileManager.fileExists(atPath: fileURL.path)
        }
    }
    
    func hasAnyFiles() -> Bool {
        return queue.sync {
            guard fileManager.fileExists(atPath: hiddenFolderURL.path) else { return false }
            let files = try? fileManager.contentsOfDirectory(atPath: hiddenFolderURL.path)
            return (files?.count ?? 0) > 0
        }
    }
    
    // MARK: - Main interface
    
    // MARK: - Save
    @discardableResult
    func saveWakeSession(_ session: WakeSession) -> Bool {
        (try? saveFile(fileType: .wakeSession, content: session)) != nil
    }
    
    @discardableResult
    func saveWakeSessionAssertionID(id: IOPMAssertionID) -> Bool {
        guard var session = loadWakeSession() else { return false }
        
        session.assertionID = id
        deleteWakeSession()
        return saveWakeSession(session)
    }
    
    @discardableResult
    func saveAlwaysActiveSession(_ session: AlwaysActiveSession) -> Bool {
        (try? saveFile(fileType: .alwaysActiveSession, content: session)) != nil
    }
    
    // TODO: - Save User Settings
    @available(*, unavailable, message: "Not Implemented")
    func saveUserSettings() -> Bool { false }

    
    // MARK: - Load
    func loadWakeSession() -> WakeSession? {
        try? loadFile(fileType: .wakeSession, as: WakeSession.self)
    }
    
    func loadAlwaysActiveSession() -> AlwaysActiveSession? {
        try? loadFile(fileType: .alwaysActiveSession, as: AlwaysActiveSession.self)
    }
    
    // TODO: - Load User Settings
    @available(*, unavailable, message: "Not Implemented")
    func loadUserSettings() {}
    
    
    // MARK: - Delete
    @discardableResult
    func deleteWakeSession() -> Bool {
        (try? deleteFile(fileType: .wakeSession)) != nil
    }
    
    @discardableResult
    func deleteAlwaysActiveSession() -> Bool {
        (try? deleteFile(fileType: .alwaysActiveSession)) != nil
    }
    
    // TODO: - Load User Settings
    @available(*, unavailable, message: "Not Implemented")
    @discardableResult
    func deleteUserSettings() -> Bool {
        (try? deleteFile(fileType: .config)) != nil
    }
}

enum FileType {
    case wakeSession
    case alwaysActiveSession
    
    // Settings
    case config
    
    fileprivate var fileName: String {
        return switch self {
        case .wakeSession: Constants.wakeSession.rawValue
        case .alwaysActiveSession: Constants.alwaysActiveSession.rawValue
        case .config: ""
        }
    }
}

enum StorageServiceError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidContentType
    case failedToCreateFolder
    case failedToDeleteFolder
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let fileName):
            return "File '\(fileName)' not found."
        case .invalidContentType:
            return "Invalid content type for saving."
        case .failedToCreateFolder:
            return "Failed to create the hidden folder."
        case .failedToDeleteFolder:
            return "Failed to delete the hidden folder."
        }
    }
}

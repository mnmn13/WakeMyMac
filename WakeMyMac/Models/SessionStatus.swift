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

struct SessionStatus {
    let startDate: Date
    let remainingTime: TimeInterval?
    
    init(startDate: Date, remainingTime: TimeInterval?) {
        self.startDate = startDate
        self.remainingTime = remainingTime
    }

    init?(session: Session?) {
        guard let session else { return nil }
        self.startDate = session.startTime
        if let duration = session.duration {
            let elapsed = Date().timeIntervalSince(session.startTime)
            self.remainingTime = max(duration - elapsed, 0)
        } else {
            self.remainingTime = nil
        }
    }
    
    /// Will return an empty string if remaining time is nil
    func getTimeRemainingFormatted() -> String {
        guard let interval = remainingTime else { return "" }
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

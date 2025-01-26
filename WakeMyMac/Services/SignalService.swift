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

let SigService = SignalService.shared

final class SignalService {
    
    static let shared = SignalService()
    
    private init() {}
    
    func setupSignalHandler(_ success: (() -> Void)? = nil, _ failure: (() -> Void)? = nil) {
        // Create signals
        let successSignal = DispatchSource.makeSignalSource(signal: Signal.success.rawValue, queue: .main)
        let failureSignal = DispatchSource.makeSignalSource(signal: Signal.failure.rawValue, queue: .main)
        
        // Ignore detault system behaviuor for signals
        signal(Signal.success.rawValue, SIG_IGN)
        signal(Signal.failure.rawValue, SIG_IGN)
        
        successSignal.setEventHandler {
            success?()
            successSignal.cancel()
        }
        
        failureSignal.setEventHandler {
            failure?()
            failureSignal.cancel()
            
        }

        successSignal.resume()
        failureSignal.resume()
    }
}

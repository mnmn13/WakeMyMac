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

enum Signal: Int32 {
    case success = 30 // SIGUSR1
    case failure = 31 // SIGUSR2
    
    // Soft termination
    case terminate = 15 // SIGTERM
    
    // Force termination
    case kill = 0 // SIGKILL
}

func send(_ signal: Signal, _ processID: pid_t = getppid()) {
    kill(processID, signal.rawValue)
}

func killSelf() {
    exit(0)
}

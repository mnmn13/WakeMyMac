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

enum Constants: String {
    case wakeSession
    case alwaysActiveSession
    case wakeConfig
    
    case assertionName = "WakeMyMac"
    
    case accessibilitySettingsURL = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    
    // Logger
    case loggerSubsystem = "com.NikitaMoshyn.WakeMyMac"
    case loggerCategory = "main"
    
    var value: String { rawValue }
}

//
//  BifcodeStoreConfiguration.swift
//
//  Created on 22.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import DeveloperSupportStore
import Foundation

/// Store configuration for Bifcode app.
/// Product IDs are loaded automatically from Products.plist by StoreHelper.
public struct BifcodeStoreConfiguration: StoreConfigurationProtocol {
    public var privacyPolicyURL: URL {
        URL(string: "https://igrsoft.com/info/app/bifcode/policy.html")!
    }

    public var termsOfUseURL: URL {
        URL(string: "https://igrsoft.com/info/app/bifcode/terms.html")!
    }

    public init() {}
}

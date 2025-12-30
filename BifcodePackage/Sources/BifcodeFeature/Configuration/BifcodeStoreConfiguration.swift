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

    public var colors: StoreColors {
        StoreColors(
            primaryText: Color("storePrimaryText", bundle: .module),
            secondaryText: Color("storeSecondaryText", bundle: .module),
            secondaryBackground: Color("storeSecondaryBackground", bundle: .module),
            selectedView: Color("storeSelectedView", bundle: .module),
            buttonBackground: Color("storeButtonBackground", bundle: .module),
            buttonHovered: Color("storeButtonHovered", bundle: .module)
        )
    }
    
    public init() {}
}

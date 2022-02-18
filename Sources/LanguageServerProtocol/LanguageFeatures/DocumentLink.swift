//
//  File.swift
//  
//
//  Created by Matthew Massicotte on 2022-02-18.
//

import Foundation

public struct DocumentLinkClientCapabilities: Codable, Hashable {
    public var dynamicRegistration: Bool?
    public var tooltipSupport: Bool?

    public init(dynamicRegistration: Bool, tooltipSupport: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.tooltipSupport = tooltipSupport
    }
}

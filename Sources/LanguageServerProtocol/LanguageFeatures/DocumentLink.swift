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

public struct DocumentLinkOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public struct DocumentLinkRegistrationOptions: Codable, Hashable {
    public var workDoneProgress: Bool?
    public var documentSelector: DocumentSelector?
    public var resolveProvider: Bool?

    public init(workDoneProgress: Bool? = nil, documentSelector: DocumentSelector? = nil, resolveProvider: Bool? = nil) {
        self.workDoneProgress = workDoneProgress
        self.documentSelector = documentSelector
        self.resolveProvider = resolveProvider
    }
}

public struct DocumentLinkParams: Codable, Hashable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
}

public struct DocumentLink: Codable, Hashable {
    public var range: LSPRange
    public var target: DocumentUri?
    public var tooltip: String?
    public var data: LSPAny
}

public typealias DocumentLinkResponse = [DocumentLink]?

//
//  File.swift
//  
//
//  Created by Matthew Massicotte on 2022-02-18.
//

import Foundation

public struct DocumentLinkClientCapabilities: Codable, Hashable, Sendable {
    public var dynamicRegistration: Bool?
    public var tooltipSupport: Bool?

    public init(dynamicRegistration: Bool, tooltipSupport: Bool? = nil) {
        self.dynamicRegistration = dynamicRegistration
        self.tooltipSupport = tooltipSupport
    }
}

public struct DocumentLinkOptions: Codable, Hashable, Sendable {
    public var workDoneProgress: Bool?
    public var resolveProvider: Bool?
}

public struct DocumentLinkRegistrationOptions: Codable, Hashable, Sendable {
    public var workDoneProgress: Bool?
    public var documentSelector: DocumentSelector?
    public var resolveProvider: Bool?

    public init(workDoneProgress: Bool? = nil, documentSelector: DocumentSelector? = nil, resolveProvider: Bool? = nil) {
        self.workDoneProgress = workDoneProgress
        self.documentSelector = documentSelector
        self.resolveProvider = resolveProvider
    }
}

public struct DocumentLinkParams: Codable, Hashable, Sendable {
    public var workDoneToken: ProgressToken?
    public var partialResultToken: ProgressToken?
}

public struct DocumentLink: Codable, Hashable, Sendable {
    public var range: LSPRange
    public var target: DocumentUri?
    public var tooltip: String?
    public var data: LSPAny?

	public init(range: LSPRange, target: DocumentUri?, tooltip: String?, data: LSPAny?) {
		self.range = range
		self.target = target
		self.tooltip = tooltip
		self.data = data
	}
}

public typealias DocumentLinkResponse = [DocumentLink]?

//
//  AnalyticsRepositoryProtocol.swift
//  Domain
//
//  Created by jumy on 3/20/26.
//

public protocol AnalyticsRepositoryProtocol {
    func track(_ event: AnalyticsEvent)
    func setUserId(_ userId: String?)
    func setAnalyticsEnabled(_ enabled: Bool)
}

//
//  FirebaseService.swift
//  Data
//
//  Created by jumy on 3/20/26.
//

import FirebaseRemoteConfig
import Domain
import Util

public final class FirebaseService {
    private let remoteConfig: RemoteConfig
    
    public init(remoteConfig: RemoteConfig = .remoteConfig()) {
        self.remoteConfig = remoteConfig
    }
    
    public func setupRemoteConfig() async {
        configureRemoteConfig()
        
        do {
            try await fetchAndActivate()
            OLogger.network.log("🔥 Firebase RemoteConfig setup succeeded")
        } catch {
            OLogger.error.log("🔥 Firebase RemoteConfig setup failed: \(error.localizedDescription)")
        }
    }
    
    public func getValue(forKey key: String, type: RemoteConfigValueType) -> RemoteConfigResultData {
        let value = getValue(from: remoteConfig.configValue(forKey: key), type: type)
        OLogger.network.log("🔥 Firebase RemoteConfig value - key: \(key), value: \(value)")
        return value
    }
}

private extension FirebaseService {
    func configureRemoteConfig() {
        let settings = RemoteConfigSettings()
        
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 3600
        #endif
        
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults([
            RemoteConfigKeys.forceUpdate.rawValue: false as NSObject
        ])
        
        OLogger.network.log("🔥 Firebase RemoteConfig configured")
    }
    
    func fetchAndActivate() async throws {
        try await remoteConfig.fetchAndActivate()
    }
    
    func getValue(from value: FirebaseRemoteConfig.RemoteConfigValue, type: RemoteConfigValueType) -> RemoteConfigResultData {
        switch type {
        case .bool:
            return .bool(value.boolValue)
        case .string:
            return .string(value.stringValue)
        case .int:
            return .int(value.numberValue.intValue)
        case .double:
            return .double(value.numberValue.doubleValue)
        case .data:
            return .data(value.dataValue)
        }
    }
}

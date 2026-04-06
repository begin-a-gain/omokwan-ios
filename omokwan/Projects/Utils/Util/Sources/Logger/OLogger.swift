//
//  OLogger.swift
//  Util
//
//  Created by 김동준 on 7/20/25
//

import OSLog

public enum OLogLevel: String {
    case DEBUG
    case NETWORK
    case ERROR
    
    var prefix: String {
        switch self {
        case .DEBUG:
            return "🟡 [Debug]"
        case .NETWORK:
            return "🟠 [Network]"
        case .ERROR:
            return "🔴 [Error]"
        }
    }
}

public struct OLogger {
    private let logger: Logger
    private let level: OLogLevel
    
    private init(level: OLogLevel) {
        let subSystem = Bundle.main.bundleIdentifier ?? "com.begin-a-gain.omokwang"
        self.logger = Logger(subsystem: subSystem, category: level.rawValue)
        self.level = level
    }
    
    public static let debug = OLogger(level: .DEBUG)
    public static let network = OLogger(level: .NETWORK)
    public static let error = OLogger(level: .ERROR)
    
    public func log(
        _ message: String,
        _ args: CVarArg...,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let formattedString = String(format: message, arguments: args)
        let fileName = (file as NSString).lastPathComponent
        let metadata = "[\(function) => \(fileName):\(line)]"
        let fullMessage = "\(level.prefix)\n\(formattedString)"
        let messageWithMetaData = """
        \(level.prefix)
        \(metadata)
        \(formattedString)
        """

        switch level {
        case .DEBUG:
            logger.debug("\(messageWithMetaData, privacy: .private)")
        case .NETWORK:
            logger.notice("\(fullMessage)")
        case .ERROR:
            logger.error("\(fullMessage)")
        }
    }
}

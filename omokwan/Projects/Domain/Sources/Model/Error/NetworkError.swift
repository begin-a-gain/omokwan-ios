//
//  NetworkError.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

public enum NetworkError: Error {
    case internalServerError
    case unAuthorizationError
    case unKnownError
    case timeout
    case clientError // 400대 에러
}

public extension NetworkError {
    var toTitle: String {
        switch self {
        case .internalServerError:
            "서버 오류"
        case .unAuthorizationError:
            "인증 오류"
        case .unKnownError:
            "알 수 없는 오류"
        case .timeout:
            "요청 시간 초과"
        case .clientError:
            "요청 오류"
        }
    }
    
    var toContents: String {
        switch self {
        case .internalServerError:
            "서버에서 문제가 발생했어요. 잠시 후 다시 시도해주세요."
        case .unAuthorizationError:
            "로그인 정보가 만료되었거나 권한이 없어요. 다시 로그인해주세요."
        case .unKnownError:
            "예기치 못한 문제가 발생했어요. 다시 시도해보거나 고객센터에 문의해주세요."
        case .timeout:
            "서버 응답이 지연되고 있어요. 네트워크 상태를 확인한 후 다시 시도해주세요."
        case .clientError:
            "잘못된 요청이에요. 다시 시도해보거나 앱을 최신 버전으로 업데이트해주세요."
        }
    }
}

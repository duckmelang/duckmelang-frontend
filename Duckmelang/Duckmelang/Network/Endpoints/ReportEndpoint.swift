//
//  ReportEndpoint.swift
//  Duckmelang
//
//  Created by nau on 7/15/25.
//

import Foundation
import Moya

public enum ReportEndpoint {
    case postReport(request: ReportRequest)
}

extension ReportEndpoint: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        default:
            guard let url = URL(string: API.reportURL) else {
                fatalError("baseURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 post을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .postReport:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postReport(let request):
            return .requestJSONEncodable(request)
        }
    }
        
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}


//
//  SignupEndpoint.swift
//  Duckmelang
//
//  Created by 주민영 on 3/28/25.
//

import UIKit
import Moya

// 1 명세서 당 1 API enum 정의하기
// case 이름은 반드시 method로 시작하기 !!
// 예) .post~, .patch~, .get~, .delete~
// 매개변수를 사용하지 않는 곳이라면 생략하고 case 이름만 작성해도 됨
// 예) .postReviews(let memberId) : X / .postReviews : O

public enum SignupEndpoint {
    case getCheckNickname(loginId: String) // 아이디 중복 확인
    case postSignUp(signUp: SignupRequest) // 회원가입
    case postPhoneNum(phoneNum: String) // 전화번호 등록
    case patchMemberProfile(memberId: Int, profile: PatchMemberProfileRequest) // 닉네임, 생년월일, 성별 설정
    case postMemberProfileImage(memberId: Int, profileImage: [MultipartFormData]) // 프로필 사진 설정
    case getMemberNicknameCheck(nickname: String) // 닉네임 중복 확인
    case postMemberInterestCeleb(memberId: Int, idolNums: SelectFavoriteIdolRequest) // 덕질하는 아이돌 설정
    case postMemberInterestEvent(memberId: Int, eventNums: SelectFavoriteEventRequest) // 관심있는 행사 종류 선택
    case postLandMines(memberId: Int, landmineString: SetLandmineKeywordRequest) // 지뢰 설정
    case patchMemberIntroduction(memberId: Int, introduction: SetIntroductionRequest) // 자기소개 문구 설정
    
    case getAllIdols
    case getSearchIdol(keyword: String) // 아이돌 검색
    case getAllEvents
}

extension SignupEndpoint: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case .getSearchIdol:
            guard let url = URL(string: API.mySettingURL) else {
                fatalError("mySettingURL 오류")
            }
            return url
        case .getCheckNickname, .postPhoneNum:
            guard let url = URL(string: API.authURL) else {
                fatalError("authURL 오류")
            }
            return url
        case .getAllIdols, .getAllEvents:
            guard let url = URL(string: API.baseURL) else {
                fatalError("baseURL 오류")
            }
            return url
        default:
            guard let url = URL(string: API.memberURL) else {
                fatalError("memberURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .getCheckNickname:
            return "/nickname"
        case .postSignUp:
            return "/signup"
        case .postPhoneNum:
            return "/phone"
        case .patchMemberProfile(let memberId, _):
            return "/\(memberId)/profile"
        case .postMemberProfileImage(let memberId, _):
            return "/\(memberId)/profile/image"
        case .getMemberNicknameCheck:
            return "/check/nickname"
        case .postMemberInterestCeleb(let memberId, _):
            return "/\(memberId)/idols"
        case .postMemberInterestEvent(let memberId, _):
            return "/\(memberId)/events"
        case .postLandMines(let memberId, _):
            return "/\(memberId)/landmines"
        case .patchMemberIntroduction(let memberId, _):
            return "/\(memberId)/introduction"
        case .getAllIdols:
            return "/idols"
        case .getSearchIdol:
            return "/idols/search"
        case .getAllEvents:
            return "/events"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 post을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .getCheckNickname, .getMemberNicknameCheck, .getAllIdols, .getSearchIdol, .getAllEvents:
            return .get
        case .patchMemberProfile, .patchMemberIntroduction:
            return .patch
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getCheckNickname(let loginId):
            return .requestParameters(parameters: ["loginId": loginId], encoding: URLEncoding.queryString)
        case .postSignUp(let signUp):
            return .requestJSONEncodable(signUp)
        case .postPhoneNum(let phoneNum):
            return .requestParameters(parameters: ["phoneNum": phoneNum], encoding: URLEncoding.queryString)
        case .postMemberProfileImage(_, let profileImage):
            return .uploadMultipart(profileImage)
        case .patchMemberProfile(_, let PatchMemberProfileRequest):
            return .requestJSONEncodable(PatchMemberProfileRequest)
        case .getMemberNicknameCheck(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .postMemberInterestCeleb(_, let SelectFavoriteIdolRequest):
            return .requestJSONEncodable(SelectFavoriteIdolRequest)
        case .postMemberInterestEvent(_, let SelectFavoriteEventRequest):
            return .requestJSONEncodable(SelectFavoriteEventRequest)
        case .postLandMines(_, let SetLandmineKeywordRequest):
            return .requestJSONEncodable(SetLandmineKeywordRequest)
        case .patchMemberIntroduction(_, let SetIntroductionRequest):
            return .requestJSONEncodable(SetIntroductionRequest)
        case .getAllIdols, .getAllEvents:
            return .requestPlain
        case .getSearchIdol(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}

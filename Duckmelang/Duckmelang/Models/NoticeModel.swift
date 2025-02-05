//
//  NoticeModel.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit

struct NoticeModel {
    var profile: UIImage //FIXME: - url로 바꿔야함
    var noticeTitle: String
    var noticeTime: String
}

extension NoticeModel {
    static func dummyScrapped() -> [NoticeModel] {
        return [
            NoticeModel(profile: UIImage(), noticeTitle: "내 동행글이 스크랩되었어요.", noticeTime: "몇분 전")
        ]
    }

    static func dummyAccompanyAccept() -> [NoticeModel] {
        let users = UserNameModel.dummyName() // 유저 리스트 가져오기

        return users.map { user in
            NoticeModel(profile: UIImage(), noticeTitle: "\(user.username)님이 동행 확정 요청을 수락했어요.", noticeTime: "몇분 전")
        }
    }
    
    static func dummyAccompanyRequest() -> [NoticeModel] {
        let users = UserNameModel.dummyName() // 유저 리스트 가져오기

        return users.map { user in
            NoticeModel(profile: UIImage(), noticeTitle: "\(user.username)님이 동행을 요청했어요.", noticeTime: "몇분 전")
        }
    }
}

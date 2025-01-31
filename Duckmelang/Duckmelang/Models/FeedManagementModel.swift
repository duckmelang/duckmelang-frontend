//
//  FeedManagementModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/25/25.
//

import UIKit

struct FeedManagementModel {
    let postImage: UIImage // url: string으로 변경예정
    let postTitle: String
    let EventType: String
    let EventDate: String
    let userImage: UIImage // url: string으로 변경예정
    let userName: String
    let isSelected: Bool
}

extension FeedManagementModel {
    static func dummy() -> [FeedManagementModel] {
        return [
            FeedManagementModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "유저네임", isSelected: false),
            FeedManagementModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "유저네임", isSelected: false),
        ]
    }
}

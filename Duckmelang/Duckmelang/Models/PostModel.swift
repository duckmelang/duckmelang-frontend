//
//  PostModel.swift
//  Duckmelang
//
//  Created by 고현낭 on 1/19/25.
//
import UIKit

struct PostModel {
    let postImage: UIImage // url: string으로 변경예정
    let postTitle: String
    let EventType: String
    let EventDate: String
    let userImage: UIImage // url: string으로 변경예정
    let userName: String
    let postTime: String
}

extension PostModel {
    static func dummy1() -> [PostModel] {
        return [
            PostModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "유저네임", postTime: "몇분 전"),
            PostModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "유저네임", postTime: "몇분 전"),
        ]
    }
    static func dummy2() -> [PostModel] {
        return [
            PostModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "내 닉네임", postTime: "몇분 전"),
            PostModel(postImage: UIImage(), postTitle: "게시글 제목", EventType: "행사 종류", EventDate: "행사 날짜", userImage: UIImage(), userName: "내 닉네임", postTime: "몇분 전"),
        ]
    }
}

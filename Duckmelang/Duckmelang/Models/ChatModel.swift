//
//  ChatModel.swift
//  Duckmelang
//
//  Created by 주민영 on 1/16/25.
//

import UIKit

//기획 확정되면 추가/삭제 예정
//enum RequestType {
//    case awaiting
//    case sent
//    case received
//}

enum Status {
    case ongoing
    case done
}

struct ChatModel {
    let userImage: UIImage // url: string으로 변경예정
    let userName: String
    let postImage: UIImage // url: string으로 변경예정
    let sentTime: String
    let recentMessage: String
    let status: Status
}

extension ChatModel {
    static func dummy() -> [ChatModel] {
        return [
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .ongoing),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .ongoing),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .ongoing),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~안녕하세요! 팬콘 동행 요청드려요~안녕하세요! 팬콘 동행 요청드려요~", status: .ongoing),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
            ChatModel(userImage: UIImage(), userName: "유저네임", postImage: UIImage(), sentTime: "오전 10 : 29", recentMessage: "안녕하세요! 팬콘 동행 요청드려요~", status: .done),
        ]
    }
}

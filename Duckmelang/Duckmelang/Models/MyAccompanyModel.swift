//
//  Model.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit

enum RequestType {
    case awaiting
    case sent
    case received
}

enum Status {
    case accepted
    case rejected
    case awaiting
}

struct MyAccompanyModel {
    let requestType: RequestType
    let userImage: UIImage // url: string으로 변경예정
    let userName: String
    let postImage: UIImage // url: string으로 변경예정
    let postTitle: String
    let sentTime: String
    let status: Status
}

extension MyAccompanyModel {
    static func dummy() -> [MyAccompanyModel] {
        return [
            MyAccompanyModel(requestType: .awaiting, userImage: UIImage(), userName: "minyoy", postImage: UIImage(), postTitle: "콘서트 가실 분 구해요~콘서트 가실 분 구해요~콘서트 가실 분 구해요~콘서트 가실 분 구해요~콘서트 가실 분 구해요~", sentTime: "오전 10 : 29", status: .accepted),
            MyAccompanyModel(requestType: .sent, userImage: UIImage(), userName: "nau", postImage: UIImage(), postTitle: "콘서트 가실 분 구해요~", sentTime: "오전 10 : 29", status: .awaiting),
            MyAccompanyModel(requestType: .sent, userImage: UIImage(), userName: "nau", postImage: UIImage(), postTitle: "콘서트 가실 분 구해요~", sentTime: "오전 10 : 29", status: .rejected),
            MyAccompanyModel(requestType: .received, userImage: UIImage(), userName: "yeon", postImage: UIImage(), postTitle: "콘서트 가실 분 구해요~", sentTime: "오전 10 : 29", status: .accepted),
            MyAccompanyModel(requestType: .received, userImage: UIImage(), userName: "minyoy", postImage: UIImage(), postTitle: "콘서트 가실 분 구해요~", sentTime: "오전 10 : 29", status: .rejected)
        ]
    }
}

//
//  MessageModel.swift
//  Duckmelang
//
//  Created by 주민영 on 1/22/25.
//

import UIKit

enum ChatType: CaseIterable {
    case receive
    case send
}

struct MessageModel {
    let text: String
    let chatType: ChatType
    let date: Date
}

extension MessageModel {
    static func dummy() -> [MessageModel] {
        return [
            MessageModel(text: "안녕하세요~ 동행 구하신다는 글보고 연락드려요", chatType: .receive, date: Date().addingTimeInterval(-86400)),
            MessageModel(text: "안녕하세요 ~~", chatType: .send, date: Date().addingTimeInterval(-86400)),
            MessageModel(text: "혹시 어느쪽에서 오시나요?", chatType: .send, date: Date().addingTimeInterval(-86400)),
            MessageModel(text: "점심 같이 드셔도 괜찮으시면 고척 근처에 맛집 아는데 가게에서 만날까요?", chatType: .send, date: Date().addingTimeInterval(-86400)),
            MessageModel(text: "저는 연남쪽에서 가요!", chatType: .receive, date: Date()),
            MessageModel(text: "00 가게 어떠신가요?? 거기서 같이 밥먹고 출발하면 좋을 것 같아요!", chatType: .send, date: Date()),
            MessageModel(text: "저는 지방에서 올라가서ㅠㅠ 가게에서 만나는게 좋을 것 같아요!", chatType: .send, date: Date()),
            MessageModel(text: "12시 어떠신가용?", chatType: .send, date: Date()),
            MessageModel(text: "00 가게 저도 가보고 싶었어요!!", chatType: .receive, date: Date()),
            MessageModel(text: "좋습니다~~", chatType: .receive, date: Date()),
            MessageModel(text: "12시에 가게에서 봬요~!", chatType: .receive, date: Date()),
        ]
    }
}

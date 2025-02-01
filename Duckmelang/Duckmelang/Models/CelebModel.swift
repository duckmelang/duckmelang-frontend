//
//  IdolModel.swift
//  Duckmelang
//
//  Created by 김연우 on 1/18/25.
//

import Foundation

struct Celeb {
    let name: String
    let imageName: String // 아이돌 로고
}

//MARK: - 더미데이터
extension Celeb {
    static func dummy1() -> [Celeb] {
        return [
            Celeb(name: "블랙핑크", imageName: "logo_yellow"),
            Celeb(name: "라이즈", imageName: "logo_yellow"),
            Celeb(name: "뉴진스", imageName: "logo_yellow"),
            Celeb(name: "엔시티 127", imageName: "logo_yellow"),
            Celeb(name: "세븐틴", imageName: "logo_yellow"),
            Celeb(name: "르세라핌", imageName: "logo_yellow")
        ]
    }
}

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
    
    //FIXME: - 개발 완료 후 삭제 예정
    static let sampleCelebs: [Celeb] = [
            Celeb(name: "블랙핑크", imageName: "logo_yellow"),
            Celeb(name: "라이즈", imageName: "logo_yellow"),
            Celeb(name: "엔시티 127", imageName: "logo_yellow"),
            Celeb(name: "세븐틴", imageName: "logo_yellow"),
            Celeb(name: "뉴진스", imageName: "logo_yellow"),
            Celeb(name: "르세라핌", imageName: "logo_yellow")
        ]
}

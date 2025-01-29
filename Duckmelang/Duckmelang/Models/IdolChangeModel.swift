//
//  IdolChangeModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

struct IdolChangeModel {
    let idolName: String
    let idolImage: UIImage
}

extension IdolChangeModel {
    static func dummy() -> [IdolChangeModel] {
        var idols =  [
            IdolChangeModel(idolName: "레드벨벳", idolImage: .star),
            IdolChangeModel(idolName: "아이즈원", idolImage: .star),
            IdolChangeModel(idolName: "에스파", idolImage: .star),
        ]
        idols.append(IdolChangeModel(idolName: "추가하기", idolImage: .idolAdd))
        return idols
    }
}

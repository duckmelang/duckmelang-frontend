//
//  HomeResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

public struct idolDTO: Codable {
    let idolId: Int
    let idolName: String
    let idolImage: String
}

public struct idolResponse: Codable {
    let idolList: [idolDTO]
}

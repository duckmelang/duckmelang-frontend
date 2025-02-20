//
//  HomeRequest.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

public struct ImageInfo: Codable {
    let orderNumber: Int
    let description: String
}

public struct PostRequest: Codable {
    let title: String
    let content: String
    let idolIds: [Int]
    let categoryId: Int
    let date: String
    let imageInfos: [ImageInfo]
}

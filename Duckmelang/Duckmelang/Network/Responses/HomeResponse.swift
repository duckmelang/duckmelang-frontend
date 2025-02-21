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

struct BookmarkResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BookmarkResult?
}

struct BookmarkResult: Codable {
    let bookmarkId: Int
    let memberId: Int
    let postId: Int
}

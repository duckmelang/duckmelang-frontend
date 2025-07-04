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

public struct EventDTO: Codable {
    let eventId: Int
    let eventName: String
    let eventKind: String
}

public struct EventResponse: Codable {
    let eventCategoryList: [EventDTO]
}

public struct BookmarkResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BookmarkResult?
}

public struct BookmarkResult: Codable {
    let bookmarkId: Int
    let memberId: Int
    let postId: Int
}

public struct FilterResponse: Codable {
    let gender: String?
    let minAge: Int?
    let maxAge: Int?
}

public struct WrtieResponse: Codable {
    let id: Int
    let title: String
}

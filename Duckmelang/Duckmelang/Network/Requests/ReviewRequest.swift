//
//  ReviewRequest.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

// 후기 작성에 필요한 구조체
public struct ReviewRequest: Codable {
    public let score: Double
    public let content: String
    public let receiverId: Int
    public let applicationId: Int
}

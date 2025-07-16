//
//  PostRequest.swift
//  Duckmelang
//
//  Created by nau on 7/15/25.
//
import Foundation

public struct ReportRequest: Codable {
    let id: Int
    let reason: String
    let dtype: String
}

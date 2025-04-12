//
//  Endpoint.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

final class Endpoint<R: Decodable>: Requestable {
    typealias Response = R

    let baseURL: String
    let httpMethod: HttpMethod
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?

    init(
        baseURL: String = APIConstant.baseURL,
        httpMethod: HttpMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.httpMethod = httpMethod
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}

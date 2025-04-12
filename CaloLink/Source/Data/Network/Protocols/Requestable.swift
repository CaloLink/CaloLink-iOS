//
//  Requestable.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

protocol Requestable {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var httpMethod: HttpMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    func makeURLRequest() -> URLRequest?
}

// MARK: - makeURL, makeURLRequest 메서드 Default 구현
extension Requestable {
    func makeURL() -> URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }

    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        return request
    }

    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    var body: Data? { nil }
}

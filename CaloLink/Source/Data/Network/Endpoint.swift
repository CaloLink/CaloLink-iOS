//
//  Endpoint.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - Endpoint (API 명세서의 설계도)
// 모든 API Endpoint가 따라야 하는 규칙의 정의하는 프로토콜
protocol Endpoint {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var task: NetworkTask { get }

    func toURLRequest() -> URLRequest?
}

// MARK: - 기본 구현을 통해 중복 코드를 줄임
extension Endpoint {
    var baseURL: String {
        // TODO: - 실제 서버 Base URL로 교체하기
        return "실제 서버 Base URL로 교체"
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    func toURLRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path += path

        if case .requestWithPatameters(let parameters) = task {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if case .requestWithEncodable(let encodable) = task {
            request.httpBody = try? JSONEncoder().encode(encodable)
        }

        return request
    }
}

// MARK: - HttpMethod
// HTTP 메서드를 정의하는 열거형
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - 요청에 필요한 파라미터나 Body를 정의하는 열거형
enum NetworkTask {
    case requestPlain                           // 파라미터나 Body가 없는 요청
    case requestWithPatameters([String: Any])   // URL Query 파라미터가 있는 요청
    case requestWithEncodable(Encodable)        // Body에 Encodable 객체를 담는 요청
}

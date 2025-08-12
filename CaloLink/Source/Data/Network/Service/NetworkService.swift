//
//  NetworkService.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - NetworkServiceProtocol
// 네트워크 통신 엔진
protocol NetworkServiceProtocol {
    @discardableResult
    func request<E: Endpoint>(
        endpoint: E,
        completion: @escaping (Result<E.Response, NetworkError>) -> Void
    ) -> URLSessionTask?
}

final class DefaultNetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    @discardableResult
    func request<E: Endpoint>(
        endpoint: E,
        completion: @escaping (Result<E.Response, NetworkError>) -> Void
    ) -> URLSessionTask? {
        guard let request = endpoint.toURLRequest() else {
            completion(.failure(.invalidURL))
            return nil
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                let serverError = ServerError(rawValue: httpResponse.statusCode) ?? .internalServerError
                completion(.failure(.serverError(serverError)))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(E.Response.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
        return task
    }
}

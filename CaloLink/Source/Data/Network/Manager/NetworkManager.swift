//
//  NetworkManager.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func request<Request: Requestable>(
        endpoint: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void
    ) -> Cancellable? {
        guard let request = endpoint.makeURLRequest() else {
            completion(.failure(NetworkError.invalidURL))
            return nil
        }

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error {
                completion(.failure(NetworkError.requestFailed(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.responseError))
                return
            }

            guard (200..<400).contains(httpResponse.statusCode) else {
                let serverError = ServerError(rawValue: httpResponse.statusCode) ?? .unknown
                completion(.failure(NetworkError.serverError(serverError)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            if Request.Response.self == String.self,
               let string = String(data: data, encoding: .utf8) as? Request.Response {
                completion(.success(string))
                return
            }

            do {
                let decoded = try decoder.decode(Request.Response.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }

        task.resume()
        return task
    }
}

//
//  NetworkManagerProtocol.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

protocol NetworkManagerProtocol {
    @discardableResult
    func request<Request: Requestable>(
        endpoint: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void
    ) -> Cancellable?
}

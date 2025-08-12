//
//  NetworkError.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - NetworkError 에러 정의
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case requestFailed(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL 입니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError(let error):
            return "데이터 디코딩에 실패했습니다: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "서버 에러가 발생했습니다. (코드: \(statusCode))"
        case .requestFailed(let error):
            return "요청에 실패했습니다: \(error.localizedDescription)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}

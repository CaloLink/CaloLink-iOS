//
//  NetworkError.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

import Foundation

// MARK: - ServerError 에러 정의
// TODO: - API 명세서 정해야함
enum ServerError: Int {
    case badRequest = 400               // 잘못된 요청
    case unauthorized = 401             // 인증 실패
    case forbidden = 403                // 접근 권한 없음
    case notFound = 404                 // 요청한 리소스를 찾을 수 없음
    case internalServerError = 500      // 서버 내부 에러
}

// MARK: - NetworkError 에러 정의
// 서버와 상관없이, 앱 내부에서 발생하는 문제
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case serverError(ServerError)
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
        case .serverError(let serverError):
            return "서버 에러가 발생했습니다. (코드: \(serverError.rawValue))"
        case .requestFailed(let error):
            return "요청에 실패했습니다: \(error.localizedDescription)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}

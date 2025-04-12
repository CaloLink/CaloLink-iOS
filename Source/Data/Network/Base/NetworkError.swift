//
//  NetworkError.swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL                       // 유효하지 않은 URL
    case responseError                    // 유효하지 않은 응답값일 경우
    case decodingError(Error)             // 데이터 파싱 실패
    case emptyData                        // 응답 데이터가 비어있는 경우
    case serverError(ServerError)         // 서버 에러
    case requestFailed(String)            // 서버 요청 실패한 경우
    case unknown                          // 알 수 없는 오류

    var description: String {
        switch self {
        case .invalidURL:
            "URL이 올바르지 않습니다."
        case .responseError:
            "응답값이 유효하지 않습니다."
        case .decodingError(let error):
            "디코딩 에러: \(error.localizedDescription)"
        case .emptyData:
            "데이터가 없습니다."
        case .serverError(let error):
            "서버 에러 \(error.rawValue): \(error)"
        case .requestFailed(let message):
            "서버 요청 실패 \(message)"
        case .unknown:
            "알 수 없는 에러"
        }
    }
}

//
//  ServerError..swift
//  CaloLink
//
//  Created by 김성훈 on 4/12/25.
//

import Foundation

enum ServerError: Int {
    case unknown = -1           // 알 수 없는 오류
    case badRequest = 400       // 잘못된 요청
    case unauthorized = 401     // 인증 실패
    case forbidden = 403        // 접근 권한 없음
    case notFound = 404         // 요청한 리소스를 찾을 수 없음
}

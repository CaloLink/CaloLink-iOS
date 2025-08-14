//
//  DefaultProductRepository.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import Foundation

// MARK: - DefaultProductRepository
// 실제 네트워크 통신을 통해 상품 데이터를 가져오는 Repository 구현체
final class DefaultProductRepository: ProductRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    // 의존성 주입(DI)을 통해 네트워크 통신 엔진을 받음
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: - 상품 목록 가져오기
    func fetchProducts(
        query: SearchQuery,
        completion: @escaping (Result<[Product], Error>) -> Void
    ) {
        // "상품 검색" API 명세서(Endpoint)를 만듦
        let endpoint = ProductAPI.Search(query: query)

        // 네트워크 엔진에 API 요청을 보냄
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let productListDTO):
                // 성공시 DTO를 Domain Entity로 변환하여 전달
                let products = productListDTO.products.map { $0.toDomain() }
                completion(.success(products))
                
            case .failure(let error):
                // 실패시 받은 에러를 그대로 전달
                completion(.failure(error))
            }
        }
    }

    // MARK: - 상품 상세 정보 가져오기
    func fetchProductDetail(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    ) {
        // "상품 상세 정보" API 명세서를 만들어 요청
        let endpoint = ProductAPI.Detail(productId: productId)

        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let productDetailDTO):
                completion(.success(productDetailDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  GetProductDetailUseCase.swift
//  CaloLink
//
//  Created by 김성훈 on 8/12/25.
//

// MARK: - GetProductDetailUseCaseProtocol
// 상품 상세 정보 조회 비즈니스 로직을 정의하는 프로토콜
protocol GetProductDetailUseCaseProtocol {
    func execute(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    )
}

// MARK: - GetProductDetailUseCase
final class GetProductDetailUseCase: GetProductDetailUseCaseProtocol {
    // 작업을 전달할 레포지토리 선언
    private let productRepository: ProductRepositoryProtocol

    // 의존성 주입(DI)을 통해 Repository를 받음
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }

    // UseCase의 핵심 로직을 수행하는 메서드
    func execute(
        productId: String,
        completion: @escaping (Result<ProductDetail, Error>) -> Void
    ) {
        // Repository에 작업을 그대로 전달
        productRepository.fetchProductDetail(productId: productId, completion: completion)
    }
}

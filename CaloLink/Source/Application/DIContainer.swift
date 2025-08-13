//
//  DIContainer.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - DIContainer
// 앱의 모든 의존성을 생성하고 관리하는 중앙 컨테이너
final class DIContainer {
    // MARK: - 부품 창고 (Singleton Instances)

    // Services: 네트워크 통신 엔진은 앱 전체에서 하나만 존재
    lazy var networkService: NetworkServiceProtocol = DefaultNetworkService()

    // Repositories: 데이터 저장소도 하나만 존재
    lazy var productRepository: ProductRepositoryProtocol = MockProductRepository()
//    lazy var productRepository: ProductRepositoryProtocol = DefaultProductRepository(networkService: networkService)

    // Use Cases: UseCase는 상태를 가지지 않으므로 하나만 만들어 재사용
    lazy var searchProductsUseCase: SearchProductsUseCaseProtocol = SearchProductsUseCase(productRepository: productRepository)
    lazy var getProductDetailUseCase: GetProductDetailUseCaseProtocol = GetProductDetailUseCase(productRepository: productRepository)

    // MARK: - 조립 라인 (Factory Methods)

    // MARK: - 검색 Scene
    // SearchViewModel을 생성하는 팩토리 메서드
    func makeSearchViewModel() -> SearchViewModel {
        // 지금은 UseCase 의존성이 없으므로 그냥 생성만
        return SearchViewModel()
    }

    // SearchViewController를 생성하는 팩토리 메서드
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(
            viewModel: makeSearchViewModel(),
            diContainer: self
        )
    }

    // MARK: - 검색 결과 목록 Scene
    // ListViewModel을 생성하는 팩토리 메서드
    func makeListViewModel() -> ListViewModel {
        // 부품 창고에서 "searchProductsUseCase"를 가져와 주입
        return ListViewModel(searchProductsUseCase: searchProductsUseCase)
    }

    // ListViewController를 생성하는 팩토리 메서드
    func makeListViewController() -> ListViewController {
        // "makeListViewModel"을 호출하여 ViewModel을 만들고,
        // diContainer 자기 자신(self)도 함께 주입
        return ListViewController(
            viewModel: makeListViewModel(),
            diContainer: self
        )
    }

    // MARK: - 상품 상세 Scene
    // DetailViewModel을 생성하는 팩토리 메서드
    func makeDetailViewModel(productId: String) -> DetailViewModel {
        return DetailViewModel(
            productId: productId,
            getProductDetailUseCase: getProductDetailUseCase
        )
    }

    // DetailViewController를 생성하는 팩토리 메서드
    func makeDetailViewController(productId: String) -> DetailViewController {
        return DetailViewController(
            viewModel: makeDetailViewModel(productId: productId)
        )
    }
}

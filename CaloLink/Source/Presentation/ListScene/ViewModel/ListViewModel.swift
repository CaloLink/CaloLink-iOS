//
//  ListViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - ListViewModel
final class ListViewModel {
    // View가 알아야 할 모든 상태를 명확하게 정의하는 enum
    enum State {
        case loading
        case success([Product])
        case empty
        case error(Error)
    }

    // MARK: - 프로퍼티
    private let searchProductsUseCase: SearchProductsUseCaseProtocol

    private(set) var state: State = .loading {
        didSet { self.onUpdate?() }
    }

    // ViewModel의 상태가 변경될 때마다 호출될 클로저
    var onUpdate: (() -> Void)?

    // 현재 화면에 표시 중인 데이터의 검색 쿼리
    private(set) var currentQuery: SearchQuery?
 
    // MARK: - Initializer
    init(searchProductsUseCase: SearchProductsUseCaseProtocol) {
        self.searchProductsUseCase = searchProductsUseCase
    }

    // MARK: - 메서드
    // 검색 쿼리로 상품 목록을 가져옴
    func fetchProducts(with query: SearchQuery) {
        self.currentQuery = query
        self.state = .loading

        searchProductsUseCase.execute(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    if products.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .success(products)
                    }
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        }
    }

    // 새로운 정렬 옵션을 적용하고 데이터를 다시 불러옴
    func applySortOption(_ newSortOption: SortOption) {
        // 현재 기억하고 있는 쿼리가 없으면 아무것도 하지 않음
        guard var query = self.currentQuery else { return }

        // 기존 쿼리에서 정렬 옵션만 변경
        query.sortOption = newSortOption

        // 변경된 쿼리로 데이터를 다시 요청
        fetchProducts(with: query)
    }

    // 새로운 필터 옵션을 적용하고 데이터를 다시 불러옴
    func applyFilterOption(_ newFilterOption: FilterOption) {
        // 현재 기억하고 있는 쿼리가 없으면 아무것도 하지 않음
        guard var query = self.currentQuery else { return }

        // 기존 쿼리에서 필터 옵션만 변경
        query.filterOption = newFilterOption

        // 변경된 쿼리로 데이터를 다시 요청
        fetchProducts(with: query)
    }
}

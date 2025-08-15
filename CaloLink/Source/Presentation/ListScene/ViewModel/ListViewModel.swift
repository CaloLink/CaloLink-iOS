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

    // 페이지네이션 상태 관리 프로퍼티
    private var currentPage = 0
    private var totalPages = 1
    private var isFetchingNextPage = false

    // MARK: - Initializer
    init(searchProductsUseCase: SearchProductsUseCaseProtocol) {
        self.searchProductsUseCase = searchProductsUseCase
    }

    // MARK: - 메서드

    // 검색 쿼리로 상품 목록을 가져옴
    func fetchProducts(with query: SearchQuery) {
        self.currentQuery = query
        self.state = .loading

        // 페이지 상태 초기화
        self.currentPage = 1 // 첫 페이지는 1로 시작
        self.totalPages = 1

        searchProductsUseCase.execute(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productPage):
                    // 서버 응답에서 페이지 정보를 받아와 저장
                    self?.currentPage = productPage.currentPage
                    self?.totalPages = productPage.totalPages

                    if productPage.products.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .success(productPage.products)
                    }
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        }
    }

    // 다음 페이지 데이터를 불러오는 메서드
    func fetchNextPage() {
        // 현재 로딩 중이거나, 마지막 페이지까지 모두 불렀다면 실행하지 않음
        guard !isFetchingNextPage, currentPage < totalPages else { return }

        guard var query = self.currentQuery else { return }

        isFetchingNextPage = true
        query.page = self.currentPage + 1

        searchProductsUseCase.execute(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetchingNextPage = false
                switch result {
                case .success(let newProductPage):
                    // 기존 products 배열에 새로운 데이터를 추가
                    if case .success(var currentProducts) = self?.state {
                        currentProducts.append(contentsOf: newProductPage.products)
                        self?.state = .success(currentProducts)
                        self?.currentPage = newProductPage.currentPage
                        self?.currentQuery?.page = newProductPage.currentPage
                    }
                case .failure(let error):
                    // 다음 페이지 로딩 실패 시 에러 처리
                    print("Failed to fetch next page: \(error.localizedDescription)")
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
        // 정렬 시 1페이지부터 다시 시작
        query.page = 1
        fetchProducts(with: query)
    }

    // 새로운 필터 옵션을 적용하고 데이터를 다시 불러옴
    func applyFilterOption(_ newFilterOption: FilterOption) {
        // 현재 기억하고 있는 쿼리가 없으면 아무것도 하지 않음
        guard var query = self.currentQuery else { return }
        // 기존 쿼리에서 필터 옵션만 변경
        query.filterOption = newFilterOption
        // 필터 시 1페이지부터 다시 시작
        query.page = 1
        fetchProducts(with: query)
    }
}

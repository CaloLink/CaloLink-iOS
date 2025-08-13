//
//  ListViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - ListViewModel
final class ListViewModel {
    // MARK: - 프로퍼티
    private let searchProductsUseCase: SearchProductsUseCaseProtocol

    private(set) var products: [Product] = []
    private(set) var isLoading: Bool = false {
        didSet { self.onUpdate?() }
    }
    private(set) var error: Error?

    // ViewModel의 상태가 변경될 때마다 호출될 클로저
    var onUpdate: (() -> Void)?

    // 에러 발생 시 에러 메시지와 함께 얼럿을 띄우도록 요청하는 클로저
    var onShowErrorAlert: ((String) -> Void)?

    // MARK: - Initializer
    init(searchProductsUseCase: SearchProductsUseCaseProtocol) {
        self.searchProductsUseCase = searchProductsUseCase
    }

    // MARK: - 메서드
    // 검색 쿼리로 상품 목록을 가져옴
    func fetchProducts(with query: SearchQuery) {
        self.isLoading = true

        searchProductsUseCase.execute(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.onUpdate?()
                case .failure(let error):
                    self?.error = error
                    // 에러가 발생하면 에러 메시지와 함께 얼럿을 띄우도록 View에 요청
                    self?.onShowErrorAlert?(error.localizedDescription)
                }
            }
        }
    }
}

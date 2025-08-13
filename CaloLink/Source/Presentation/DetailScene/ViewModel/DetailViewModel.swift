//
//  DetailViewModel.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import Foundation

// MARK: - DetailViewModel
final class DetailViewModel {
    // MARK: - 프로퍼티
    private let productId: String
    private let getProductDetailUseCase: GetProductDetailUseCaseProtocol

    // MARK: - Output to ViewController
    // View에 전달할 데이터 및 상태
    private(set) var productDetail: ProductDetail?
    private(set) var isLoading: Bool = false {
        didSet {
            // 로딩 상태가 변경되면 View에 알림
            self.onUpdate?()
        }
    }
    private(set) var error: Error?

    // ViewModel의 상태가 변경될 때마다 호출될 클로저
    var onUpdate: (() -> Void)?

    // MARK: - Initializer
    init(
        productId: String,
        getProductDetailUseCase: GetProductDetailUseCaseProtocol
    ) {
        self.productId = productId
        self.getProductDetailUseCase = getProductDetailUseCase
    }

    // MARK: - 메서드
    // ViewController의 viewDidLoad에서 호출될 메서드
    func viewDidLoad() {
        fetchProductDetail()
    }

    // 상품 상세 정보를 가져오는 메서드
    private func fetchProductDetail() {
        self.isLoading = true

        getProductDetailUseCase.execute(productId: productId) { [weak self] result in
            // 네트워크 응답은 백그라운드 스레드에서 올 수 있으므로 UI 업데이트를 위해 메인 스레드로 전환
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let detail):
                    self?.productDetail = detail
                    // 데이터가 성공적으로 로드되었음을 View에 알림
                    self?.onUpdate?()
                case .failure(let error):
                    self?.error = error
                    // 에러가 발생했음을 View에 알림
                }
            }
        }
    }
}

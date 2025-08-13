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
    // UseCase로부터 받은 원본 데이터
    private var productDetail: ProductDetail?

    // View는 아래의 가공된 데이터들을 사용
    var productName: String? { productDetail?.name }
    var imageURL: URL? { productDetail?.imageURL }
    var nutritionInfo: NutritionInfo? { productDetail?.nutritionInfo }

    // 가격이 낮은 순으로 정렬된 쇼핑몰 링크 배열
    var sortedShopLinks: [ShopLink] {
        // 원본 shopLinks를 가격 오름차순으로 정렬하여 반환
        return productDetail?.shopLinks.sorted { $0.price < $1.price } ?? []
    }

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
                    // 원본 데이터를 저장하고, View에 업데이트 신호를 보냄
                    self?.productDetail = detail
                    // 데이터가 성공적으로 로드되었음을 View에 알림
                    self?.onUpdate?()
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}

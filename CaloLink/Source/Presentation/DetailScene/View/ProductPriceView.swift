//
//  ProductPriceView.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - ProductPriceView
final class ProductPriceView: UIView {
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private let contentView = UIView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        return stackView
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public 메서드
    // ViewModel로부터 받은 데이터로 View를 업데이트
    public func updateShopLinks(with shopLinks: [ShopLink]) {
        // 기존에 있던 가격 정보 뷰들을 모두 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 데이터로 가격 정보 뷰들을 다시 만듦
        shopLinks.forEach { addPriceRow(for: $0) }
    }
}

// MARK: - Private 메서드
private extension ProductPriceView {
    // 가격 정보 한 줄을 생성하여 스택뷰에 추가하는 헬퍼 메서드
    func addPriceRow(for shopLink: ShopLink) {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing

        let linkButton = UIButton(type: .system)
        linkButton.setTitle(shopLink.mallName, for: .normal)
        linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        linkButton.tintColor = .darkGray
        linkButton.contentHorizontalAlignment = .left

        // 버튼에 URL 열기 액션을 추가
        if let url = shopLink.linkURL {
            linkButton.addAction(UIAction { _ in
                UIApplication.shared.open(url)
            }, for: .touchUpInside)
        }

        let priceLabel = UILabel()
        priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        priceLabel.textColor = .black
        priceLabel.text = formatPrice(shopLink.price)

        hStack.addArrangedSubview(linkButton)
        hStack.addArrangedSubview(priceLabel)

        stackView.addArrangedSubview(hStack)
    }

    // 숫자를 원화 형식으로 변환
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + "원"
    }

    func setupUI() {
        backgroundColor = .white

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        [
            scrollView,
            contentView,
            stackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

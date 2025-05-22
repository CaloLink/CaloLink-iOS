//
//  ProductPriceView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/22/25.
//

import UIKit

class ProductPriceView: UIView {
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 7
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
        configurePriceItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure View
extension ProductPriceView {
    private func configureView() {
        backgroundColor = .white
    }

    private func configureLayout() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func configurePriceItems() {
        let items: [(siteName: String, price: String, url: String)] = [
            ("사이트명1", "10,000원", "https://example.com/1"),
            ("사이트명2", "12,000원", "https://example.com/2"),
            ("사이트명3", "11,500원", "https://example.com/3"),
            ("사이트명4", "9,900원", "https://example.com/4"),
            ("사이트명1", "10,000원", "https://example.com/1"),
            ("사이트명2", "12,000원", "https://example.com/2"),
            ("사이트명3", "11,500원", "https://example.com/3"),
            ("사이트명4", "9,900원", "https://example.com/4"),
            ("사이트명5", "10,100원", "https://example.com/5"),
            ("사이트명6", "13,000원", "https://example.com/6"),
            ("사이트명7", "10,700원", "https://example.com/7")
        ]

        for item in items {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .equalSpacing

            let linkButton = UIButton(type: .system)
            linkButton.setTitle(item.siteName, for: .normal)
            linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            linkButton.addAction(UIAction { _ in
                if let url = URL(string: item.url) {
                    UIApplication.shared.open(url)
                }
            }, for: .touchUpInside)

            let priceLabel = UILabel()
            priceLabel.text = item.price
            priceLabel.font = UIFont.boldSystemFont(ofSize: 17)

            hStack.addArrangedSubview(linkButton)
            hStack.addArrangedSubview(priceLabel)

            stackView.addArrangedSubview(hStack)
        }
    }
}

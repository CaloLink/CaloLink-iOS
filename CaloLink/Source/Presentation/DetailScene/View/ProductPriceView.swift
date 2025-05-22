//
//  ProductPriceView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/22/25.
//

import UIKit

class ProductPriceView: UIView {
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "가격비교"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureSubViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension ProductPriceView {
    private func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Configure AutoLayout
extension ProductPriceView {
    private func configureSubViewLayout() {
        [
            mainLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
}


//
//  ListNoProductView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class ListNoProductView: UIView {
    private let noProductLabel: UILabel = {
        let label = UILabel()
        label.text = "찾는 상품이 없습니다..."
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray2
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
extension ListNoProductView {
    private func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Configure AutoLayout
extension ListNoProductView {
    private func configureSubViewLayout() {
        addSubview(noProductLabel)
        noProductLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noProductLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            noProductLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

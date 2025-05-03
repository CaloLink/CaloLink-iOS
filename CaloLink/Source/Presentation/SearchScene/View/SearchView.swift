//
//  SearchView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class SearchView: UIView {
    private let currentSearchWordLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
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
extension SearchView {
    private func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Configure AutoLayout
extension SearchView {
    private func configureSubViewLayout() {
        addSubview(currentSearchWordLabel)
        currentSearchWordLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentSearchWordLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currentSearchWordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
}

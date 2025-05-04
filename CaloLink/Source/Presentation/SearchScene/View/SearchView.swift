//
//  SearchView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class SearchView: UIView {
    private let recentSearchTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    let allDeleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.contentInsets = .zero
        config.attributedTitle = AttributedString(
            "전체삭제",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.darkGray
            ])
        )
        button.configuration = config
        return button
    }()

    private let keywordLimitInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 10개까지 저장됩니다"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        return label
    }()

    let searchKeywordTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.rowHeight = 40
        return tableView
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

// MARK: - Configure View
extension SearchView {
    private func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Configure SubView Layout
extension SearchView {
    private func configureSubViewLayout() {
        [
            recentSearchTitleLabel,
            allDeleteButton,
            keywordLimitInfoLabel,
            searchKeywordTableView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            recentSearchTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recentSearchTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),

            allDeleteButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            allDeleteButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),

            keywordLimitInfoLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            keywordLimitInfoLabel.topAnchor.constraint(equalTo: recentSearchTitleLabel.bottomAnchor, constant: 1),

            searchKeywordTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchKeywordTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchKeywordTableView.topAnchor.constraint(equalTo: keywordLimitInfoLabel.bottomAnchor, constant: 5),
            searchKeywordTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

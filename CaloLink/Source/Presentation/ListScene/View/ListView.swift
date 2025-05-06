//
//  ListView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class ListView: UIView {
    let filterButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGreen
        config.image = UIImage(systemName: "line.3.horizontal.decrease")
        config.baseForegroundColor = .white
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        let baseFont = UIFont.systemFont(ofSize: 15)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

        config.attributedTitle = AttributedString(
            "필터 설정하기",
            attributes: AttributeContainer([
                .font: scaledFont,
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = .lightGray
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

// MARK: - Configure Initial Setting
extension ListView {
    private func configureView() {
        backgroundColor = .white
    }
}

// MARK: - Configure AutoLayout
extension ListView {
    private func configureSubViewLayout() {
        [
            filterButton,
            tableView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            filterButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            filterButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),

            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

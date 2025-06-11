//
//  ListView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class ListView: UIView {
    let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)

        let image = UIImage(systemName: "line.3.horizontal.decrease")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        )
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 8

        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.background.strokeColor = .systemGray
        config.background.strokeWidth = 1
        config.background.cornerRadius = 10

        let baseFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

        config.attributedTitle = AttributedString("필터 설정하기", attributes: AttributeContainer([
            .font: scaledFont
        ]))

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .left
        return button
    }()

    let sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "추천순"

        let image = UIImage(systemName: "chevron.down")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        )
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .black

        let baseFont = UIFont.boldSystemFont(ofSize: 15)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

        config.attributedTitle = AttributedString("추천순", attributes: AttributeContainer([
            .font: scaledFont
        ]))

        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .right
        return button
    }()

    private let filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        return stack
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
        filterStackView.addArrangedSubview(filterButton)
        filterStackView.addArrangedSubview(sortButton)

        [
            filterStackView,
            separatorLine,
            tableView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            filterStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            filterStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            separatorLine.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),

            tableView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

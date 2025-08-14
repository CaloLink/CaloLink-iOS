//
//  RecentKeywordCell.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import UIKit

// MARK: - RecentKeywordCellDelegate
// 셀 내부의 삭제 버튼 탭 이벤트를 ViewController에 전달하기 위한 프로토콜
protocol RecentKeywordCellDelegate: AnyObject {
    func recentKeywordCellDidTapDeleteButton(for cell: UITableViewCell)
}

// MARK: - RecentKeywordCell
final class RecentKeywordCell: UITableViewCell {
    static let identifier = "RecentKeywordCell"
    weak var delegate: RecentKeywordCellDelegate?

    // MARK: - UI Components
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Method
    func configure(with keyword: String) {
        keywordLabel.text = keyword
    }

    // MARK: - Private Action
    @objc private func deleteButtonTapped() {
        delegate?.recentKeywordCellDidTapDeleteButton(for: self)
    }
}

// MARK: - UI Setup
private extension RecentKeywordCell {
    func setupUI() {
        contentView.backgroundColor = .white
        [keywordLabel, deleteButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keywordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            keywordLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

//
//  SearchKeywordTableViewCell.swift
//  CaloLink
//
//  Created by 김성훈 on 5/4/25.
//

import UIKit

protocol SearchKeywordTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(in cell: SearchKeywordTableViewCell)
}

class SearchKeywordTableViewCell: UITableViewCell {
    weak var delegate: SearchKeywordTableViewCellDelegate?

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAddTarget()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Subviews Layout
extension SearchKeywordTableViewCell {
    private func configureLayout() {
        [
            keywordLabel,
            deleteButton
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            keywordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            keywordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
            keywordLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: - Configure AddTarget
extension SearchKeywordTableViewCell {
    private func configureAddTarget() {
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    @objc private func deleteTapped() {
        delegate?.deleteButtonTapped(in: self)
    }
}

// MARK: - Public Method: 뷰컨에서 키워드 설정
extension SearchKeywordTableViewCell {
    func configureKeyword(with keyword: String) {
        keywordLabel.text = keyword
    }
}

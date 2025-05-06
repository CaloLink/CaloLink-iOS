//
//  ListTableViewCell.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Subviews
extension ListTableViewCell {
    private func configureSubviews() {
        [
            productImageView,
            productNameLabel,
            categoryLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - Configure Layout
extension ListTableViewCell {
    private func configureLayout() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),

            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            categoryLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 15),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            categoryLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 20)
        ])
    }
}

// MARK: - Public method: 셀 구성
extension ListTableViewCell {
    func configureProductData(image: UIImage, title: String, category: String) {
        productImageView.image = image
        productNameLabel.text = title
        categoryLabel.text = category
    }
}

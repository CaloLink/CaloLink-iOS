//
//  ProductListCell.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - ProductListCell
final class ProductListCell: UITableViewCell {
    static let identifier = "ProductListCell"

    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.tintColor = .systemGray4
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    private let nutrientsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
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

    // MARK: - Public 메서드
    public func updateContents(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = formatPrice(product.price)

        nutrientsLabel.text = product.keyNutrients
            .map { "\($0.name) \($0.value)" }
            .joined(separator: " | ")

        let placeholderImage = UIImage(
            systemName: "photo",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        )

        // TODO: - 비동기, 이미지 로드 개선
        if let imageURL = product.imageURL {
            self.productImageView.image = placeholderImage

            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                }
            }
        } else {
            self.productImageView.image = placeholderImage
        }
    }

    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: price)) ?? "\(price)") + "원"
    }
}

// MARK: - UI Setup
private extension ProductListCell {
    func setupUI() {
        contentView.backgroundColor = .white
        [
            productImageView,
            nameLabel,
            priceLabel,
            nutrientsLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // 셀 선택 시 회색 배경이 나타나도록 설정
        self.selectionStyle = .default

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),

            nameLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nutrientsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nutrientsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nutrientsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            priceLabel.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
}

//
//  ProductNutritionView.swift
//  CaloLink
//
//  Created by 김성훈 on 5/22/25.
//

import UIKit

class ProductNutritionView: UIView {
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 내용량 00g"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.text = "000kcal"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    private let percentInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 영양성분 기준치에 대한 비율"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private let nutritionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()

    private let footnoteLabel: UILabel = {
        let label = UILabel()
        label.text = "※ 1일 영양성분 기준치에 대한 비율(%)은 2,000kcal 기준이므로 개인의 필요 열량에 따라 다를 수 있습니다."
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
        configureNutritionItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure View
extension ProductNutritionView {
    private func configureView() {
        backgroundColor = .white
    }

    private func configureNutritionItems() {
        let items: [(String, String)] = [
            ("나트륨", "00mg"),
            ("탄수화물", "00g"),
            ("당류", "00g"),
            ("지방", "00g"),
            ("트랜스지방", "00g"),
            ("포화지방", "00g"),
            ("콜레스테롤", "00mg"),
            ("단백질", "00g")
        ]

        for (name, amount) in items {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .equalSpacing

            let nameLabel = UILabel()
            let attributedText = NSMutableAttributedString(
                string: "\(name) ",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
            )
            attributedText.append(NSAttributedString(
                string: amount,
                attributes: [.font: UIFont.systemFont(ofSize: 14)]
            ))
            nameLabel.attributedText = attributedText

            let percentLabel = UILabel()
            percentLabel.text = "00%"
            percentLabel.font = UIFont.boldSystemFont(ofSize: 16)

            hStack.addArrangedSubview(nameLabel)
            hStack.addArrangedSubview(percentLabel)

            nutritionStackView.addArrangedSubview(hStack)
        }
    }

    private func configureLayout() {
        [
            totalAmountLabel,
            kcalLabel,
            percentInfoLabel,
            nutritionStackView,
            footnoteLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            totalAmountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            totalAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            kcalLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 4),
            kcalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            percentInfoLabel.centerYAnchor.constraint(equalTo: totalAmountLabel.centerYAnchor),
            percentInfoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            nutritionStackView.topAnchor.constraint(equalTo: kcalLabel.bottomAnchor, constant: 20),
            nutritionStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nutritionStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            footnoteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            footnoteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            footnoteLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}

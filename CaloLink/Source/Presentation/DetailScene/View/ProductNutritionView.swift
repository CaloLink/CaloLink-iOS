//
//  ProductNutritionView.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - ProductNutritionView
final class ProductNutritionView: UIView {
    // MARK: - UI Components
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()

    private let percentInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "1일 영양성분 기준치에 대한 비율"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        return view
    }()

    private let nutritionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private let footnoteLabel: UILabel = {
        let label = UILabel()
        label.text = "※ 1일 영양성분 기준치에 대한 비율(%)은 2,000kcal 기준이므로 개인의 필요 열량에 따라 다를 수 있습니다."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public 메서드
    // ViewModel로부터 받은 데이터로 View를 업데이트
    public func updateNutritionInfo(with nutritionInfo: NutritionInfo) {
        if let totalSize = nutritionInfo.totalSize {
            totalAmountLabel.text = "총 내용량 \(totalSize)g"
        } else {
            totalAmountLabel.text = "총 내용량 - g"
        }

        if let calories = nutritionInfo.calories {
            kcalLabel.text = "\(calories)kcal"
        } else {
            kcalLabel.text = "- kcal"
        }

        // 기존에 있던 영양성분 뷰들을 모두 제거
        nutritionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 데이터로 영양성분 뷰들을 다시 만듦
        addNutritionRow(name: "나트륨", value: nutritionInfo.sodium)
        addNutritionRow(name: "탄수화물", value: nutritionInfo.carbs)
        addNutritionRow(name: "당류", value: nutritionInfo.sugars)
        addNutritionRow(name: "지방", value: nutritionInfo.fat)
        addNutritionRow(name: "트랜스지방", value: nutritionInfo.transFat)
        addNutritionRow(name: "포화지방", value: nutritionInfo.saturatedFat)
        addNutritionRow(name: "콜레스테롤", value: nutritionInfo.cholesterol)
        addNutritionRow(name: "단백질", value: nutritionInfo.protein)
    }
}

// MARK: - Private Methods
private extension ProductNutritionView {
    func setupUI() {
        backgroundColor = .white

        [
            totalAmountLabel,
            kcalLabel,
            percentInfoLabel,
            separatorView,
            nutritionStackView,
            footnoteLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            totalAmountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            totalAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            kcalLabel.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 4),
            kcalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            percentInfoLabel.bottomAnchor.constraint(equalTo: kcalLabel.bottomAnchor, constant: -4),
            percentInfoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            separatorView.topAnchor.constraint(equalTo: kcalLabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            nutritionStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            nutritionStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nutritionStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            footnoteLabel.topAnchor.constraint(greaterThanOrEqualTo: nutritionStackView.bottomAnchor, constant: 20),
            footnoteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            footnoteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            footnoteLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // 영양성분 한 줄을 생성하여 스택뷰에 추가하는 헬퍼 메서드
    func addNutritionRow(name: String, value: NutrientValue) {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill

        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = .darkGray

        // amount가 nil이면 "-"로 표시, 아니면 "값 + 단위"로 표시
        let amountText = value.amount.map { "\($0)\(value.unit)" } ?? "-"
        nameLabel.text = "\(name) \(amountText)"

        let percentLabel = UILabel()
        percentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        percentLabel.textColor = .black
        percentLabel.textAlignment = .right

        // percentage가 nil이면 "-"로 표시, 아니면 "값%"로 표시
        percentLabel.text = value.percentage.map { "\($0)%" } ?? "-"

        hStack.addArrangedSubview(nameLabel)
        hStack.addArrangedSubview(percentLabel)

        nutritionStackView.addArrangedSubview(hStack)
    }
}

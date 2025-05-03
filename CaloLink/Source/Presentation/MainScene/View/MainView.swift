//
//  MainView.swift
//  CaloLink
//
//  Created by 김성훈 on 4/26/25.
//

import UIKit

final class MainView: UIView {
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.3.sequence.fill")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let searchButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.image = UIImage(systemName: "magnifyingglass")
        config.baseForegroundColor = .darkGray
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)

        let baseFont = UIFont.systemFont(ofSize: 15)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

        config.attributedTitle = AttributedString(
            "상품을 검색해보세요!",
            attributes: AttributeContainer([
                .font: scaledFont,
                .foregroundColor: UIColor.darkGray
            ])
        )
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        return button
    }()

    private let category0 = CategoryButton(
        title: "면류",
        image: UIImage(systemName: "square.fill")!
    )

    private let category1 = CategoryButton(
        title: "간편식",
        image: UIImage(systemName: "square.fill")!
    )

    private let category2 = CategoryButton(
        title: "간식",
        image: UIImage(systemName: "square.fill")!
    )

    private let category3 = CategoryButton(
        title: "유제품",
        image: UIImage(systemName: "square.fill")!
    )

    private let category4 = CategoryButton(
        title: "음료",
        image: UIImage(systemName: "square.fill")!
    )

    private let category5 = CategoryButton(
        title: "커피 / 차",
        image: UIImage(systemName: "square.fill")!
    )

    private let category6 = CategoryButton(
        title: "헬스",
        image: UIImage(systemName: "square.fill")!
    )

    private let category7 = CategoryButton(
        title: "제로식품",
        image: UIImage(systemName: "square.fill")!
    )

    private lazy var firstCategoryRowSV: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            category0,
            category1,
            category2,
            category3
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()

    private lazy var secondCategoryRowSV: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            category4,
            category5,
            category6,
            category7
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()

    private lazy var entireCategorySV: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstCategoryRowSV, secondCategoryRowSV])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Initial Setting
extension MainView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }
}

// MARK: - Configure AutoLayout
extension MainView {
    private func configureSubviews() {
        [
            logoImage,
            searchButton,
            entireCategorySV
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 130),
            logoImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -130),
            logoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor, multiplier: 0.5),

            searchButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 60),
            searchButton.heightAnchor.constraint(equalToConstant: 50),

            entireCategorySV.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            entireCategorySV.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            entireCategorySV.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
    }
}

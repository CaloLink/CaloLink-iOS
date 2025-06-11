//
//  MainView.swift
//  CaloLink
//
//  Created by 김성훈 on 4/26/25.
//

import UIKit

final class MainView: UIView {
    // MARK: - UI Components
    private(set) var categoryButtons: [CategoryButton] = []

    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .logo)
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

    private lazy var categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCategoryButtons()
        configureInitialSetting()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Config CategoryButtons
extension MainView {
    private func createCategoryButtons() {
        let titles = ["면류", "간편식", "간식", "유제품", "음료", "커피 / 차", "헬스", "제로식품"]

        categoryButtons = titles.enumerated().map { index, title in
            // TODO: "category0" ~ "category7" 이름의 이미지를 Assets에 추가하고 연결할 것
            let image = UIImage(named: "category\(index)") ?? UIImage(systemName: "square")!
            return CategoryButton(title: title, image: image)
        }

        let rows = stride(from: 0, to: categoryButtons.count, by: 4).map {
            Array(categoryButtons[$0..<min($0 + 4, categoryButtons.count)])
        }

        rows.forEach { row in
            let rowStack = createCategoryRowStack(with: row)
            categoryStackView.addArrangedSubview(rowStack)
        }
    }

    private func createCategoryRowStack(with buttons: [UIButton]) -> UIStackView {
        let rowStack = UIStackView(arrangedSubviews: buttons)
        rowStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        rowStack.spacing = 10
        return rowStack
    }
}

// MARK: - Layout & View Config
extension MainView {
    private func configureInitialSetting() {
        backgroundColor = .white
    }

    private func configureSubviews() {
        [
            logoImage,
            searchButton,
            categoryStackView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            logoImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            logoImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70),

            searchButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),

            categoryStackView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 80),
            categoryStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            categoryStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

//
//  CategoryButton.swift
//  CaloLink
//
//  Created by 김성훈 on 4/26/25.
//

import UIKit

final class CategoryButton: UIButton {
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        configureButtonUI(title: title, image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure Button UI
extension CategoryButton {
    private func configureButtonUI(title: String, image: UIImage) {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 1

        let baseFont = UIFont.systemFont(ofSize: 15)
        let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        let fontSize = scaledFont.pointSize

        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: scaledFont,
                .foregroundColor: UIColor.black
            ])
        )

        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: fontSize * (45.0 / 13.0))

        config.imageColorTransformer = UIConfigurationColorTransformer { _ in
            return .systemGray
        }

        config.titleAlignment = .center
        self.configuration = config
    }
}

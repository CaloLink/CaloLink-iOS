//
//  DetailViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class DetailViewController: UIViewController {
    var productImage: UIImage?
    var productName: String?

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 이름"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureData()
    }
}
// MARK: - Configure Layout
extension DetailViewController {
    private func configureLayout() {
        [
            productImageView,
            productNameLabel
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 250),

            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Configure Data
extension DetailViewController {
    private func configureData() {
        productImageView.image = productImage
        productNameLabel.text = productName
    }
}

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

    private let productInfoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["영양성분", "가격비교"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .white
        return segmentedControl
    }()

    private let productNutritionView = ProductNutritionView()

    private let productPriceView = ProductPriceView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureTitle()
        configureSegmentedControl()
    }
}
// MARK: - Configure Layout
extension DetailViewController {
    private func configureLayout() {
        [
            productImageView,
            productNameLabel,
            productInfoSegmentedControl,
            productNutritionView,
            productPriceView
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
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            productInfoSegmentedControl.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            productInfoSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            productInfoSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            productInfoSegmentedControl.heightAnchor.constraint(equalToConstant: 45),

            productNutritionView.topAnchor.constraint(equalTo: productInfoSegmentedControl.bottomAnchor, constant: 10),
            productNutritionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productNutritionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productNutritionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            productPriceView.topAnchor.constraint(equalTo: productInfoSegmentedControl.bottomAnchor, constant: 10),
            productPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productPriceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Configure Data
extension DetailViewController {
    private func configureTitle() {
        productImageView.image = productImage
        productNameLabel.text = productName
    }
}

// MARK: - Configure SegmentControl
extension DetailViewController {
    private func configureSegmentedControl() {
        configureSegmentedAddTarget()
        updateSegmentedContentView()
        configureSegmentedControlStyle()
    }

    private func configureSegmentedAddTarget() {
        productInfoSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateSegmentedContentView()
    }

    private func updateSegmentedContentView() {
        let isNutritionSelected = productInfoSegmentedControl.selectedSegmentIndex == 0
        productNutritionView.isHidden = !isNutritionSelected
        productPriceView.isHidden = isNutritionSelected
    }

    private func configureSegmentedControlStyle() {
        let normalFont = UIFont.systemFont(ofSize: 15)
        let selectedFont = UIFont.boldSystemFont(ofSize: 15)

        productInfoSegmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.gray,
            .font: normalFont
        ], for: .normal)

        productInfoSegmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: selectedFont
        ], for: .selected)
    }
}

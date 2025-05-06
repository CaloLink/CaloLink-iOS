//
//  FilterViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import UIKit

class FilterViewController: UIViewController {
    let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .systemGreen
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "선택 완료",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureAddTarget()
    }

    // MARK: - Layout
    private func configureLayout() {
        view.addSubview(completeButton)

        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Configure addTarget
extension FilterViewController {
    private func configureAddTarget() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    @objc private func completeButtonTapped() {
        dismiss(animated: true)
    }
}

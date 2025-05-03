//
//  MainViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 4/26/25.
//

import UIKit

final class MainViewController: UIViewController {
    private let mainView = MainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddAction()
    }
}

// MARK: - Configure AddAction
extension MainViewController {
    private func configureAddAction() {
        mainView.searchButton.addAction(UIAction { _ in
            self.searchButtonTapped()
        }, for: .touchUpInside)
    }

    private func searchButtonTapped() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
}

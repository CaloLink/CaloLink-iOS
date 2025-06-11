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

        mainView.categoryButtons.forEach { button in
            button.addAction(UIAction { [weak self] _ in
                self?.categoryButtonTapped(with: button.titleText)
            }, for: .touchUpInside)
        }
    }

    private func searchButtonTapped() {
        let searchViewModel = DIContainer.shared.resolve(SearchViewModelProtocol.self)
        let searchViewController = SearchViewController(searchViewModel: searchViewModel)
        navigationController?.pushViewController(searchViewController, animated: true)
    }

    private func categoryButtonTapped(with categoryTitle: String) {
        let searchViewModel = DIContainer.shared.resolve(SearchViewModelProtocol.self)

        let listVC = ListViewController(
            searchText: categoryTitle,
            searchViewModel: searchViewModel
        )

        navigationController?.pushViewController(listVC, animated: true)
    }
}

//
//  SearchViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(
            string: "검색어를 입력하세요!",
            attributes: [
                .foregroundColor: UIColor.darkGray,
                .font: textField.font ?? UIFont.systemFont(ofSize: 15)
            ]
        )
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 15))
        textField.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        configureTextField()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
}

// MARK: - Configure View
extension SearchViewController {
    private func configureView() {
        view.backgroundColor = .white
    }
}

// MARK: - Configure TextField
extension SearchViewController: UITextFieldDelegate {
    private func configureTextField() {
        searchTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return false
        }
        let listViewController = ListViewController()
        listViewController.searchText = textField.text
        navigationController?.pushViewController(listViewController, animated: true)
        return true
    }
}

// MARK: - Configure NavigationBar
extension SearchViewController {
    private func configureNavigationBar() {
        // BackButton
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: backButton)

        // CancelButton
        let cancelButton = UIBarButtonItem(
            title: " 취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        cancelButton.tintColor = .black

        // NaviBar
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.titleView = searchTextField
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//
//  ListViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class ListViewController: UIViewController {
    private let listView = ListView()
    private let listNoProductView = ListNoProductView()
    var searchText: String?

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

    override func loadView() {
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextField()
        configureTableView()
    }
}

// MARK: - Configure TextField
extension ListViewController: UITextFieldDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.text = searchText
    }

    private func configureTextField() {
        searchTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return false
        }
        textField.resignFirstResponder()

        if searchText == text {
            return false
        }

        let newListViewController = ListViewController()
        newListViewController.searchText = text
        navigationController?.pushViewController(newListViewController, animated: true)

        return true
    }
}

// MARK: - Configure NavigationBar
extension ListViewController {
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

// MARK: - Configure TableView, Cell
extension ListViewController: UITableViewDataSource {
    private func configureTableView() {
        let tableView = listView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            ListTableViewCell.self,
            forCellReuseIdentifier: "ListTableViewCell"
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ListTableViewCell",
            for: indexPath
        ) as? ListTableViewCell else {
            return UITableViewCell()
        }

        // 임시 데이터 주입
        let image = UIImage(systemName: "fish")!
        let title = "상품 \(indexPath.row + 1)"
        let category = "카테고리명"

        cell.configureProductData(image: image, title: title, category: category)
        return cell
    }
}

// MARK: - 셀 선택 처리
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("셀 터치됨")
    }
}

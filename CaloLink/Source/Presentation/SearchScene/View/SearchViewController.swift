//
//  SearchViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private let searchView = SearchView()
    private var searchViewModel: SearchViewModelProtocol

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

    // MARK: - Initializer
    init(searchViewModel: SearchViewModelProtocol) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBinding()
        configureInitialKeywords()
        configureNavigationBar()
        configureTextField()
        configureTableView()
        configureAddTarget()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
}
// MARK: - Bind func
extension SearchViewController {
    private func configureBinding() {
        searchViewModel.keywordsUpdatedHandler = { [weak self] in
            self?.searchView.searchKeywordTableView.reloadData()
        }
    }

    private func configureInitialKeywords() {
        searchViewModel.loadKeywords()
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

// MARK: - Configure TextField
extension SearchViewController: UITextFieldDelegate {
    private func configureTextField() {
        searchTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !keyword.isEmpty else { return false }

        textField.resignFirstResponder()
        textField.text = ""

        searchViewModel.addKeyword(keyword)

        let listViewController = ListViewController(searchViewModel: searchViewModel)
        listViewController.searchText = keyword
        navigationController?.pushViewController(listViewController, animated: true)

        return true
    }
}

// MARK: - Configure TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    private func configureTableView() {
        let tableView = searchView.searchKeywordTableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchKeywordTableViewCell.self, forCellReuseIdentifier: "SearchKeywordTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.keywords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchKeywordTableViewCell",
            for: indexPath
        ) as? SearchKeywordTableViewCell else {
            return UITableViewCell()
        }

        let keyword = searchViewModel.keywords[indexPath.row]
        cell.configureKeyword(with: keyword)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = searchViewModel.keywords[indexPath.row]
        searchTextField.text = keyword
        _ = textFieldShouldReturn(searchTextField)
    }
}

// MARK: - 셀 개별 삭제 델리게이트
extension SearchViewController: SearchKeywordTableViewCellDelegate {
    func deleteButtonTapped(in cell: SearchKeywordTableViewCell) {
        guard let indexPath = searchView.searchKeywordTableView.indexPath(for: cell) else { return }
        let keyword = searchViewModel.keywords[indexPath.row]
        searchViewModel.deleteKeyword(keyword)
    }
}

// MARK: - Configure AddTarget
extension SearchViewController {
    private func configureAddTarget() {
        searchView.allDeleteButton.addTarget(self, action: #selector(allDeleteButtonTapped), for: .touchUpInside)
    }

    @objc private func allDeleteButtonTapped() {
        searchViewModel.allDeleteKeywords()
    }
}

//
//  SearchViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/3/25.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchView = SearchView()
    private var recentKeywords: [String] = []

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

    // MARK: - Life Cycle
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextField()
        configureTableView()
        configureAddTarget()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecentKeywords()
        searchView.searchKeywordTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
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
        guard let keyword = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !keyword.isEmpty else {
            return false
        }

        textField.resignFirstResponder()
        textField.text = ""

        addRecentKeyword(keyword)

        let listViewController = ListViewController()
        listViewController.searchText = keyword
        navigationController?.pushViewController(listViewController, animated: true)

        return true
    }
}

// MARK: - Configure TableView
extension SearchViewController {
    private func configureTableView() {
        let tableView = searchView.searchKeywordTableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchKeywordTableViewCell.self, forCellReuseIdentifier: "SearchKeywordTableViewCell")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentKeywords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SearchKeywordTableViewCell",
            for: indexPath
        ) as? SearchKeywordTableViewCell else {
            return UITableViewCell()
        }
        let keyword = recentKeywords[indexPath.row]
        cell.configureKeyword(with: keyword)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = recentKeywords[indexPath.row]
        searchTextField.text = keyword
        _ = textFieldShouldReturn(searchTextField)
    }
}

// MARK: - 최근 검색어 처리
extension SearchViewController {
    private func addRecentKeyword(_ keyword: String) {
        var keywords = UserDefaults.standard.stringArray(forKey: "recentSearchKeywords") ?? []
        keywords.removeAll { $0 == keyword }
        keywords.insert(keyword, at: 0)

        if keywords.count > 10 {
            keywords = Array(keywords.prefix(10))
        }

        UserDefaults.standard.set(keywords, forKey: "recentSearchKeywords")
        recentKeywords = keywords
        searchView.searchKeywordTableView.reloadData()
    }

    private func clearRecentKeywords() {
        recentKeywords = []
        UserDefaults.standard.removeObject(forKey: "recentSearchKeywords")
        searchView.searchKeywordTableView.reloadData()
    }

    private func loadRecentKeywords() {
        recentKeywords = UserDefaults.standard.stringArray(forKey: "recentSearchKeywords") ?? []
    }
}

// MARK: - 셀 삭제 버튼 델리게이트 처리
extension SearchViewController: SearchKeywordTableViewCellDelegate {
    func deleteButtonTapped(in cell: SearchKeywordTableViewCell) {
        guard let indexPath = searchView.searchKeywordTableView.indexPath(for: cell) else { return }

        let keywordToDelete = recentKeywords[indexPath.row]
        var keywords = UserDefaults.standard.stringArray(forKey: "recentSearchKeywords") ?? []
        keywords.removeAll { $0 == keywordToDelete }

        if keywords.count > 10 {
            keywords = Array(keywords.prefix(10))
        }

        UserDefaults.standard.set(keywords, forKey: "recentSearchKeywords")
        recentKeywords = keywords
        searchView.searchKeywordTableView.reloadData()
    }
}

// MARK: - Configure addTarget: 전체삭제 버튼
extension SearchViewController {
    private func configureAddTarget() {
        searchView.allDeleteButton.addTarget(self, action: #selector(clearAllKeywords), for: .touchUpInside)
    }

    @objc private func clearAllKeywords() {
        clearRecentKeywords()
    }
}

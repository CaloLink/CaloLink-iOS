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

    private let searchViewModel: SearchViewModelProtocol
    private let filterViewModel = FilterViewModel()
    private let sortViewModel = SortViewModel()

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

    // MARK: - Init
    init(
        searchText: String? = nil,
        searchViewModel: SearchViewModelProtocol
    ) {
        self.searchText = searchText
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = listView
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
        searchTextField.text = searchText
    }
}

// MARK: - Configure TextField
extension ListViewController: UITextFieldDelegate {
    private func configureTextField() {
        searchTextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !keyword.isEmpty else {
            return false
        }
        textField.resignFirstResponder()

        if searchText == keyword {
            return false
        }

        searchViewModel.addKeyword(keyword)

        let newListViewController = ListViewController(searchText: keyword, searchViewModel: searchViewModel)
        navigationController?.pushViewController(newListViewController, animated: true)

        return true
    }
}

// MARK: - Configure NavigationBar
extension ListViewController {
    private func configureNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: backButton)

        let cancelButton = UIBarButtonItem(
            title: " 취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        cancelButton.tintColor = .black

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
        guard let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell else { return }

        let detailVC = DetailViewController()
        detailVC.productImage = cell.getImage()
        detailVC.productName = cell.getTitle()

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Configure addTarget
extension ListViewController {
    private func configureAddTarget() {
        listView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        listView.sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }

    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController(filterViewModel: filterViewModel)
        filterVC.onFilterCompleted = { [weak self] filters in
            print("선택된 필터값: \(filters)")
            // TODO: 필터 적용 로직 추가
        }

        filterVC.modalPresentationStyle = .pageSheet
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(filterVC, animated: true)
    }

    @objc private func sortButtonTapped() {
        let sortVC = SortViewController(sortViewModel: sortViewModel)
        sortVC.modalPresentationStyle = .pageSheet

        sortVC.onSortSelected = { [weak self] selectedText in
            guard let self = self else { return }

            var config = self.listView.sortButton.configuration
            let baseFont = UIFont.boldSystemFont(ofSize: 15)
            let scaledFont = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)

            config?.attributedTitle = AttributedString(selectedText, attributes: AttributeContainer([
                .font: scaledFont
            ]))
            self.listView.sortButton.configuration = config
        }

        if let sheet = sortVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(sortVC, animated: true)
    }
}

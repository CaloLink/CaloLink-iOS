//
//  ListViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - ListViewController
final class ListViewController: UIViewController {
    // MARK: - 프로퍼티
    let viewModel: ListViewModel
    private let diContainer: DIContainer

    // MARK: - UI Components
    private let searchController = UISearchController(searchResultsController: nil)

    private let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "line.3.horizontal.decrease")
        config.title = "필터"
        config.imagePadding = 4
        config.baseForegroundColor = .black
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.cornerRadius = 8
        config.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        let button = UIButton(configuration: config)
        return button
    }()

    private let sortButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "기본순"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        config.image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 130
        tableView.separatorInset = .zero
        tableView.register(
            ProductListCell.self,
            forCellReuseIdentifier: ProductListCell.identifier
        )
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Initializer
    init(viewModel: ListViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchController()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 검색창을 활성화하여 Large Title을 접고 바로 키보드를 내림
        self.navigationItem.searchController?.isActive = true
        self.navigationItem.searchController?.searchBar.resignFirstResponder()
    }
}

// MARK: - UI Setup
private extension ListViewController {
    func setupUI() {
        view.backgroundColor = .white

        let filterStackView = UIStackView(arrangedSubviews: [filterButton, UIView(), sortButton])
        filterStackView.axis = .horizontal

        [filterStackView, tableView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Private 메서드
private extension ListViewController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // 내비게이션 바에 SearchController를 설정
    func setupSearchController() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "다른 상품 검색하기"

        // ViewModel이 기억하고 있는 검색어로 SearchBar 텍스트를 설정
        searchController.searchBar.text = viewModel.currentQuery?.searchText
    }

    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }

            // 로딩 인디케이터 처리
            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }

            self.tableView.reloadData()
        }

        viewModel.onShowErrorAlert = { [weak self] message in
            // UIAlertController를 사용하여 에러 메시지 표시
            let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        // 새로운 화면으로 push하는 대신 현재 ViewModel의 데이터를 새로고침
        let newQuery = SearchQuery(searchText: searchText,
                                     sortOption: .defaultOrder,
                                     filterOption: .default,
                                     page: 1)
        viewModel.fetchProducts(with: newQuery)

        // 검색 후 키보드를 내림
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - UITableView DataSource & Delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else {
            return UITableViewCell()
        }
        let product = viewModel.products[indexPath.row]
        cell.updateContents(with: product)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedProduct = viewModel.products[indexPath.row]

        let detailVC = diContainer.makeDetailViewController(productId: selectedProduct.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

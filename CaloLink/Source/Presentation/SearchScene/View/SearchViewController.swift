//
//  SearchViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - SearchViewController
final class SearchViewController: UIViewController {
    // MARK: - 프로퍼티
    private let viewModel: SearchViewModel
    private let diContainer: DIContainer

    // MARK: - UI Components
    private let searchController = UISearchController(searchResultsController: nil)

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "찾고 싶은 상품의 이름을 검색해 보세요."
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Initializer
    init(viewModel: SearchViewModel, diContainer: DIContainer) {
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
        setupSearchController()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 화면이 나타나면 바로 키보드가 올라오도록 설정
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UI Setup
private extension SearchViewController {
    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    // 내비게이션바에 SearchController를 설정
    func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
        // 스크롤 시에도 검색창이 항상 보이도록 설정
        self.navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "예) 닭가슴살"

        // Cancel 버튼 텍스트 및 색상 변경
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        searchController.searchBar.tintColor = .black
    }

    // ViewModel의 상태 변화를 구독하고 화면 전환 로직을 처리합니다.
    func bindViewModel() {
        viewModel.onSearchTriggered = { [weak self] searchText in
            guard let self = self else { return }

            // 검색어를 포함한 SearchQuery를 생성 (필터/정렬은 기본값 사용)
            let query = SearchQuery(searchText: searchText,
                                    sortOption: .defaultOrder,
                                    filterOption: .default,
                                    page: 1)

            // DIContainer를 통해 ListViewController를 생성
            let listVC = self.diContainer.makeListViewController()

            // ListViewController의 ViewModel에게 데이터 로딩을 시작하라고 알림
            listVC.viewModel.fetchProducts(with: query)

            // 생성된 화면으로 이동
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    // 사용자가 키보드의 "Search" 버튼을 눌렀을 때 호출됨
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        // ViewModel에게 검색을 시작하라고 알림
        viewModel.search(with: searchText)
    }
}

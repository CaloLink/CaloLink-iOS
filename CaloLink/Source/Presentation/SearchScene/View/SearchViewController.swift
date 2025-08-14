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

    private let recentSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 44
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(
            RecentKeywordCell.self,
            forCellReuseIdentifier: RecentKeywordCell.identifier
        )
        return tableView
    }()

    private lazy var recentSearchHeaderView: UIView = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .darkGray

        let button = UIButton(type: .system)
        button.setTitle("전체삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(deleteAllKeywordsButtonTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.distribution = .equalSpacing
        return stackView
    }()

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
        setupTableView()
        setupGestureRecognizers()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 화면이 나타나면 바로 키보드가 올라오도록 설정
        DispatchQueue.main.async { [weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK: - UI Setup
private extension SearchViewController {
    func setupUI() {
        view.backgroundColor = .white

        [
            recentSearchHeaderView,
            recentSearchTableView,
            infoLabel
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            recentSearchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            recentSearchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recentSearchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            recentSearchTableView.topAnchor.constraint(equalTo: recentSearchHeaderView.bottomAnchor, constant: 12),
            recentSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentSearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
}

// MARK: - Private Methods
private extension SearchViewController {
    func setupTableView() {
        recentSearchTableView.dataSource = self
        recentSearchTableView.delegate = self
    }

    // 내비게이션바에 SearchController를 설정
    func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "검색"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // 스크롤 시에도 검색창이 항상 보이도록 설정
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "예) 닭가슴살"
        searchController.searchBar.autocapitalizationType = .none

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        searchController.searchBar.tintColor = .black
    }

    // ViewModel의 상태 변화를 구독하고 화면 전환 로직을 처리합니다.
    func bindViewModel() {
        viewModel.onKeywordsUpdate = { [weak self] in
            self?.recentSearchTableView.reloadData()
            // 최근 검색어가 있으면 안내 문구를 숨기고 없으면 보여줌
            let hasKeywords = !(self?.viewModel.recentKeywords.isEmpty ?? true)
            self?.recentSearchHeaderView.isHidden = !hasKeywords
            self?.recentSearchTableView.isHidden = !hasKeywords
            self?.infoLabel.isHidden = hasKeywords
        }

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

    @objc func deleteAllKeywordsButtonTapped() {
        viewModel.deleteAllKeywords()
    }
}

// MARK: - Gesture Recognizer & Delegate
private extension SearchViewController {
    // 키보드를 내리기 위한 제스처를 설정
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // 다른 UI 요소(예: 테이블뷰 셀)의 터치 이벤트를 막지 않도록 설정
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
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

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentKeywords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentKeywordCell.identifier, for: indexPath) as? RecentKeywordCell else {
            return UITableViewCell()
        }
        let keyword = viewModel.recentKeywords[indexPath.row]
        cell.configure(with: keyword)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keyword = viewModel.recentKeywords[indexPath.row]
        // 최근 검색어를 탭하면 바로 검색 실행
        viewModel.search(with: keyword)
    }
}

// MARK: - RecentKeywordCellDelegate
extension SearchViewController: RecentKeywordCellDelegate {
    func recentKeywordCellDidTapDeleteButton(for cell: UITableViewCell) {
        guard let indexPath = recentSearchTableView.indexPath(for: cell) else { return }
        viewModel.deleteKeyword(at: indexPath.row)
    }
}

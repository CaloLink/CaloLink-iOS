//
//  MainViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import UIKit

// MARK: - MainViewController
final class MainViewController: UIViewController {
    // MARK: - 프로퍼티
    private let viewModel: MainViewModel
    private let diContainer: DIContainer

    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let searchButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "magnifyingglass")
        config.title = "상품을 검색해 보세요!"
        config.imagePadding = 8
        config.baseForegroundColor = .darkGray
        config.background.backgroundColor = .white
        config.background.strokeColor = .systemGray4
        config.background.strokeWidth = 1
        config.background.cornerRadius = 8
        config.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    // MARK: - Initializer
    init(viewModel: MainViewModel, diContainer: DIContainer) {
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
        setupCategoryButtons()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 화면에 갔다가 돌아왔을 때 내비게이션 바가 숨겨지도록 설정
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 이 화면을 떠날 때 다시 내비게이션 바가 보이도록 설정
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UI Setup
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .white
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        [
            logoImageView,
            searchButton,
            categoryStackView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),

            searchButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: 50),

            categoryStackView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 50),
            categoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func searchButtonTapped() {
        viewModel.didTapSearchButton()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    // 카테고리 버튼들을 동적으로 생성하고 스택뷰에 추가
    func setupCategoryButtons() {
        let titles = ["면류", "간편식", "간식", "유제품", "음료", "커피/차", "헬스", "제로식품"]

        // 4개씩 묶어서 가로 스택뷰를 만듦
        let rows = stride(from: 0, to: titles.count, by: 4).map {
            Array(titles[$0..<min($0 + 4, titles.count)])
        }

        rows.forEach { rowTitles in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually

            rowTitles.forEach { title in
                let button = createCategoryButton(with: title)
                rowStackView.addArrangedSubview(button)
            }
            categoryStackView.addArrangedSubview(rowStackView)
        }
    }

    // 개별 카테고리 버튼을 생성하는 헬퍼 메서드
    func createCategoryButton(with title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title

        let assetName = "category_\(title.replacingOccurrences(of: "/", with: ""))"
        config.image = UIImage(named: assetName) ?? UIImage(systemName: "square.grid.2x2")

        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseForegroundColor = .black

        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.viewModel.didTapCategoryButton(with: title)
        }, for: .touchUpInside)

        return button
    }

    // ViewModel의 상태 변화를 구독하고 화면 전환 로직을 처리
    func bindViewModel() {
        viewModel.onStartSearch = { [weak self] in
            guard let self = self else { return }
            let searchVC = self.diContainer.makeSearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }

        viewModel.onSelectCategory = { [weak self] categoryTitle in
            guard let self = self else { return }
            let query = SearchQuery(searchText: categoryTitle, sortOption: .defaultOrder, filterOption: .default, page: 1)
            let listVC = self.diContainer.makeListViewController()
            listVC.viewModel.fetchProducts(with: query)
            self.navigationController?.pushViewController(listVC, animated: true)
        }
    }
}

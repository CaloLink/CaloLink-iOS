//
//  SortViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 8/14/25.
//

import UIKit

// MARK: - SortViewController
final class SortViewController: UIViewController {
    // MARK: - 프로퍼티
    private let viewModel: SortViewModel

    // 사용자가 정렬 옵션을 선택하고 "완료"를 탭했을 때 호출될 클로저
    var onSortOptionSelected: ((SortOption) -> Void)?

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "정렬 기준"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()

    private lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("선택 완료", attributes: .init([.font: UIFont.boldSystemFont(ofSize: 16)]))
        config.baseBackgroundColor = .systemBrown
        config.background.cornerRadius = 12

        let button = UIButton(configuration: config)
        button.addAction(UIAction { [weak self] _ in
            self?.completeButtonTapped()
        }, for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    init(viewModel: SortViewModel) {
        self.viewModel = viewModel
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
    }
}

// MARK: - UI Setup
private extension SortViewController {
    func setupUI() {
        view.backgroundColor = .white

        [
            titleLabel,
            tableView,
            completeButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // 테이블 뷰 높이 == (셀 높이 * 셀 개수)
            tableView.heightAnchor.constraint(equalToConstant: 50 * CGFloat(viewModel.sortingOptions.count)),

            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

// MARK: - Private Methods
private extension SortViewController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SortCell")
    }

    @objc func completeButtonTapped() {
        // ViewModel에 저장된 최종 선택 옵션을 클로저를 통해 전달
        onSortOptionSelected?(viewModel.selectedSortOption)
        dismiss(animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension SortViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortingOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath)
        let option = viewModel.sortingOptions[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = viewModel.displayName(for: option)
        cell.contentConfiguration = content

        // 현재 선택된 옵션에 체크마크 표시
        if viewModel.isSelected(at: indexPath.row) {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .black
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ViewModel에 선택된 옵션을 업데이트하도록 알림
        viewModel.selectOption(at: indexPath.row)
        // 테이블 뷰를 새로고침하여 체크마크를 업데이트
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

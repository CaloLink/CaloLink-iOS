//
//  SortViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 6/8/25.
//

import UIKit

class SortViewController: UIViewController {
    private let sortingOptions = ["추천순", "낮은 가격순", "높은 가격순", "신상품순"]
    private var selectedIndex: Int? = nil

    var onSortSelected: ((String) -> Void)?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .systemGray4
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString(
            "선택 완료",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white
            ])
        )
        button.configuration = config
        button.isEnabled = false  // 초기엔 비활성화
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureTableView()
        configureAddTarget()
    }

    // MARK: - Layout
    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(completeButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 200),

            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SortCell")
    }

    private func configureAddTarget() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    @objc private func completeButtonTapped() {
        guard let selectedIndex = selectedIndex else {
            dismiss(animated: true)
            return
        }

        let selectedText = sortingOptions[selectedIndex]
        onSortSelected?(selectedText)
        dismiss(animated: true)
    }
}

// MARK: - UITableView Delegate & DataSource
extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath)
        cell.textLabel?.text = sortingOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)

        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false

        if selectedIndex == indexPath.row {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .systemGreen
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        completeButton.isEnabled = true
        completeButton.configuration?.background.backgroundColor = .systemGreen
        tableView.reloadData()
    }
}

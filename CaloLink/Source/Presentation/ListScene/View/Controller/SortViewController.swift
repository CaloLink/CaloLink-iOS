//
//  SortViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 6/8/25.
//

import UIKit

class SortViewController: UIViewController {
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let completeButton: UIButton = {
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
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    private let sortViewModel: SortViewModel
    var onSortSelected: ((String) -> Void)?

    // MARK: - Init
    init(sortViewModel: SortViewModel) {
        self.sortViewModel = sortViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureAddTarget()
        configureTableView()
    }
}

// MARK: - Configure Layout
extension SortViewController {
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
}

// MARK: - Configure AddTarget
extension SortViewController {
    private func configureAddTarget() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    @objc private func completeButtonTapped() {
        guard let selectedText = sortViewModel.selectedOption else {
            dismiss(animated: true)
            return
        }

        onSortSelected?(selectedText)
        dismiss(animated: true)
    }
}

extension SortViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SortCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortViewModel.sortingOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath)
        cell.textLabel?.text = sortViewModel.sortingOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false

        if sortViewModel.isSelected(at: indexPath.row) {
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark"))
            checkmark.tintColor = .systemGreen
            cell.accessoryView = checkmark
        } else {
            cell.accessoryView = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sortViewModel.selectOption(at: indexPath.row)
        completeButton.isEnabled = true
        completeButton.configuration?.background.backgroundColor = .systemGreen
        tableView.reloadData()
    }
}

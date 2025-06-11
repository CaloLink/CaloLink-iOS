//
//  FilterViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 5/6/25.
//

import UIKit

final class FilterViewController: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = .systemGreen
        config.background.cornerRadius = 10
        config.attributedTitle = AttributedString("선택 완료", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.white
        ]))
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Properties
    private let filterViewModel: FilterViewModel
    var onFilterCompleted: (([String: (min: Float, max: Float)]) -> Void)?
    var minFields: [UITextField] = []
    var maxFields: [UITextField] = []

    // MARK: - Init
    init(filterViewModel: FilterViewModel) {
        self.filterViewModel = filterViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureTextFields()
        configureAddTarget()
        configureKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI Setup
extension FilterViewController {
    private func configureLayout() {
        // reset 버튼
        let resetButton = makeResetButtonStyled()
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)

        // 스크롤 뷰
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)

        // 콘텐츠 뷰
        contentView.axis = .vertical
        contentView.spacing = 30
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // 완료 버튼
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(completeButton)

        // 오토레이아웃
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -20),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            completeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // 필터 필드 구성
    private func configureTextFields() {
        for nutrient in filterViewModel.nutrients {
            // 타이틀
            let titleLabel = UILabel()
            titleLabel.text = nutrient.title
            titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

            // min 필드 + 레이블
            let minField = createNumericTextField(placeholder: "0")
            let minLabel = makeInlineLabel("이상")
            let minStack = UIStackView(arrangedSubviews: [minField, minLabel])
            minStack.axis = .horizontal
            minStack.spacing = 4
            minStack.alignment = .center

            // max 필드 + 레이블
            let maxField = createNumericTextField(placeholder: "\(Int(nutrient.max))")
            let maxLabel = makeInlineLabel("이하")
            let maxStack = UIStackView(arrangedSubviews: [maxField, maxLabel])
            maxStack.axis = .horizontal
            maxStack.spacing = 4
            maxStack.alignment = .center

            // 저장된 값 복원
            if let saved = filterViewModel.filterValues[nutrient.key] {
                minField.text = saved.min == 0 ? "" : "\(Int(saved.min))"
                maxField.text = saved.max == nutrient.max ? "" : "\(Int(saved.max))"
            }

            minFields.append(minField)
            maxFields.append(maxField)

            // 필드 스택
            let fieldStack = UIStackView(arrangedSubviews: [minStack, maxStack])
            fieldStack.axis = .horizontal
            fieldStack.spacing = 20
            fieldStack.alignment = .center

            // 단위 레이블
            let unitLabel = UILabel()
            unitLabel.text = nutrient.unit
            unitLabel.font = .systemFont(ofSize: 20, weight: .bold)
            unitLabel.textAlignment = .right
            unitLabel.setContentHuggingPriority(.required, for: .horizontal)
            unitLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

            // 전체 수평 스택
            let hStack = UIStackView(arrangedSubviews: [fieldStack, unitLabel])
            hStack.axis = .horizontal
            hStack.spacing = 12
            hStack.alignment = .center
            hStack.distribution = .equalSpacing

            minField.widthAnchor.constraint(equalToConstant: 70).isActive = true
            maxField.widthAnchor.constraint(equalToConstant: 70).isActive = true

            // 수직 스택
            let vStack = UIStackView(arrangedSubviews: [titleLabel, hStack])
            vStack.axis = .vertical
            vStack.spacing = 6

            // 구분선
            let separator = UIView()
            separator.backgroundColor = .systemGray5
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

            contentView.addArrangedSubview(vStack)
            contentView.addArrangedSubview(separator)
        }
    }

    // for 이상, 이하 레이블
    private func makeInlineLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }

    // for 범위 텍스트필드
    private func createNumericTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 15)
        field.textAlignment = .right
        field.placeholder = placeholder
        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        field.backgroundColor = UIColor.systemGray6
        return field
    }

    // for 초기화 버튼
    private func makeResetButtonStyled() -> UIButton {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
        config.image = UIImage(systemName: "arrow.counterclockwise")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        )
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .systemRed
        config.background.strokeColor = .systemGray3
        config.background.strokeWidth = 1
        config.background.cornerRadius = 14

        config.attributedTitle = AttributedString("초기화", attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 15, weight: .medium)
        ]))

        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(resetAllFields), for: .touchUpInside)
        return button
    }

    // 완료 버튼 액션 설정
    private func configureAddTarget() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }

    // 완료 버튼 클릭
    @objc private func completeButtonTapped() {
        for (index, nutrient) in filterViewModel.nutrients.enumerated() {
            let min = Float(minFields[index].text ?? "") ?? 0
            let max = Float(maxFields[index].text ?? "") ?? nutrient.max

            if min > max {
                showAlert(title: "\(nutrient.title)의 범위가 이상합니다", message: "이상 이하의 범위를 확인해주세요.")
                return
            }

            filterViewModel.setFilter(forKey: nutrient.key, min: min, max: max)
        }

        onFilterCompleted?(filterViewModel.filterValues)
        dismiss(animated: true)
    }

    // 필드 초기화
    @objc private func resetAllFields() {
        for index in filterViewModel.nutrients.indices {
            minFields[index].text = ""
            maxFields[index].text = ""
        }
        filterViewModel.resetFilters()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Configure Keyboard
extension FilterViewController {
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        addTapToDismissKeyboard()
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = keyboardFrame.height - 20
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }

    private func addTapToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

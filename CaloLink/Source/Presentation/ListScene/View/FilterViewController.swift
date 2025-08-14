import UIKit

// MARK: - FilterViewController
final class FilterViewController: UIViewController {
    // MARK: - 프로퍼티
    private let viewModel: FilterViewModel

    // 사용자가 필터 설정을 완료했을 때 호출될 클로저
    var onFilterCompleted: ((FilterOption) -> Void)?

    // 동적으로 생성된 텍스트 필드들을 저장하기 위한 배열
    private var minTextFields: [UITextField] = []
    private var maxTextFields: [UITextField] = []

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private lazy var resetButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.counterclockwise")
        config.title = "초기화"
        config.imagePadding = 6
        config.baseForegroundColor = .systemRed
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var completeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString("필터 적용하기", attributes: .init([.font: UIFont.boldSystemFont(ofSize: 16)]))
        config.baseBackgroundColor = .systemBrown
        config.background.cornerRadius = 12
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    init(viewModel: FilterViewModel) {
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
        setupFilterFields()
        setupKeyboardHandling()
    }
}

// MARK: - UI Setup
private extension FilterViewController {
    func setupUI() {
        view.backgroundColor = .white

        [scrollView, completeButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "필터 적용"
        titleLabel.font = .boldSystemFont(ofSize: 20)

        let headerStack = UIStackView(arrangedSubviews: [titleLabel, UIView(), resetButton])

        contentView.addArrangedSubview(headerStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -20),

            // contentView의 제약을 contentLayoutGuide와 frameLayoutGuide에 올바르게 연결
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 25),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -25),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            // contentView의 너비를 스크롤뷰의 보이는 너비와 같게 만들어 좌우 스크롤을 방지
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -50),

            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

// MARK: - Private Methods & Actions
private extension FilterViewController {
    // ViewModel의 filterItems를 기반으로 UI를 동적으로 생성
    private func setupFilterFields() {
        for item in viewModel.filterItems {
            let filterRow = createFilterRow(for: item)
            contentView.addArrangedSubview(filterRow)
        }
    }

    @objc private func completeButtonTapped() {
        // 입력 값 검증 로직
        for (index, item) in viewModel.filterItems.enumerated() {
            // 텍스트 필드에서 min, max 값을 Double? 타입으로 가져옴
            let minText = minTextFields[index].text?.trimmingCharacters(in: .whitespaces)
            let maxText = maxTextFields[index].text?.trimmingCharacters(in: .whitespaces)

            let minValue = (minText?.isEmpty ?? true) ? nil : Double(minText!)
            let maxValue = (maxText?.isEmpty ?? true) ? nil : Double(maxText!)

            // min과 max 값이 모두 존재하고 min이 max보다 큰 경우 에러 알림을 띄움
            if let min = minValue, let max = maxValue, min > max {
                showAlert(title: "입력 값 오류", message: "\(item.title)의 최소값이 최대값보다 클 수 없습니다.")
                return
            }
        }

        // 검증 통과 후 텍스트 필드의 현재 값들을 ViewModel에 업데이트
        for (index, _) in viewModel.filterItems.enumerated() {
            let minText = minTextFields[index].text
            let maxText = maxTextFields[index].text
            viewModel.updateValue(at: index, minValue: minText, maxValue: maxText)
        }

        // ViewModel이 최종적으로 계산한 FilterOption을 전달하고 화면을 닫음
        onFilterCompleted?(viewModel.resultingFilterOption)
        dismiss(animated: true)
    }

    @objc private func resetButtonTapped() {
        viewModel.resetFilters()
        // 모든 텍스트 필드의 내용을 지움
        minTextFields.forEach { $0.text = "" }
        maxTextFields.forEach { $0.text = "" }
    }

    // 알림창을 띄우는 헬퍼 메서드
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UI Factory Methods
private extension FilterViewController {
    // 필터 항목 한 줄(타이틀, 입력 필드 등)을 생성
    func createFilterRow(for item: FilterViewModel.FilterItem) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = "\(item.title) (\(item.unit))"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)

        let minTextField = createNumericTextField(placeholder: "이상")
        minTextField.text = item.minValue
        minTextFields.append(minTextField)

        let maxTextField = createNumericTextField(placeholder: "이하")
        maxTextField.text = item.maxValue
        maxTextFields.append(maxTextField)

        let textFieldStack = UIStackView(arrangedSubviews: [minTextField, maxTextField])
        textFieldStack.spacing = 8
        textFieldStack.distribution = .fillEqually

        let vStack = UIStackView(arrangedSubviews: [titleLabel, textFieldStack])
        vStack.axis = .vertical
        vStack.spacing = 10

        return vStack
    }

    // 숫자 입력용 텍스트 필드를 생성
    func createNumericTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .right
        textField.font = .systemFont(ofSize: 15)
        return textField
    }
}

// MARK: - Keyboard Handling
private extension FilterViewController {
    func setupKeyboardHandling() {
        // 키보드가 나타날 때 스크롤뷰의 contentInset을 조절
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // 배경 탭 시 키보드 내리기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

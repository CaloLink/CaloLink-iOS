//
//  DetailViewController.swift
//  CaloLink
//
//  Created by 김성훈 on 8/13/25.
//

import UIKit

// MARK: - DetailViewController
final class DetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: DetailViewModel

    // MARK: - UI Components
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5 // 이미지가 없을 때 배경색
        imageView.tintColor = .systemGray3
        return imageView
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private let productInfoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["영양성분", "가격비교"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let productNutritionView = ProductNutritionView()
    private let productPriceView = ProductPriceView()

    // MARK: - Initializer
    init(viewModel: DetailViewModel) {
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
        setupNavigationBar()
        bindViewModel()
        viewModel.viewDidLoad() // ViewModel에 화면이 로드되었음을 알림
    }
}

// MARK: - Private Methods
private extension DetailViewController {
    // UI 레이아웃 및 초기 설정을 담당합니다.
    func setupUI() {
        view.backgroundColor = .white

        productInfoSegmentedControl.addTarget(
            self,
            action: #selector(segmentedControlChanged),
            for: .valueChanged
        )

        [
            productImageView,
            productNameLabel,
            productInfoSegmentedControl,
            productNutritionView,
            productPriceView,
            activityIndicator
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            productInfoSegmentedControl.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            productInfoSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            productInfoSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            productInfoSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            productNutritionView.topAnchor.constraint(equalTo: productInfoSegmentedControl.bottomAnchor),
            productNutritionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productNutritionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productNutritionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            productPriceView.topAnchor.constraint(equalTo: productInfoSegmentedControl.bottomAnchor),
            productPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productPriceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // 초기 탭 상태 설정
        updateSegmentedContentView()
    }

    // Segmented Control의 선택이 변경될 때 호출됨
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateSegmentedContentView()
    }

    // Segmented Control의 선택에 따라 올바른 뷰를 보여줌
    func updateSegmentedContentView() {
        let isNutritionSelected = productInfoSegmentedControl.selectedSegmentIndex == 0
        productNutritionView.isHidden = !isNutritionSelected
        productPriceView.isHidden = isNutritionSelected
    }

    // 내비게이션 바를 설정
    func setupNavigationBar() {
        // 기본 뒤로가기 버튼의 텍스트를 숨김
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
    }

    // ViewModel의 상태 변화를 구독하고 UI를 업데이트
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }

            if self.viewModel.isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            
            // ViewModel의 상태가 변경되면 UI를 업데이트
            self.updateUI()
        }

        viewModel.onShowErrorAlert = { [weak self] message in
            // UIAlertController를 사용하여 에러 메시지 표시
            let alert = UIAlertController(title: "에러 발생", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }

    // ViewModel로부터 받은 데이터로 UI 컴포넌트를 채움
    func updateUI() {
        productNameLabel.text = viewModel.productName

        let placeholderImage = UIImage(
            systemName: "photo",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        )

        // TODO: - 비동기, 이미지 로드 개선
        if let imageURL = viewModel.imageURL {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.productImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.productImageView.image = placeholderImage
                    }
                }
            }
        } else {
            productImageView.image = placeholderImage
        }

        // ViewModel의 가공된 프로퍼티를 사용
        if let nutritionInfo = viewModel.nutritionInfo {
            productNutritionView.updateNutritionInfo(with: nutritionInfo)
        }
        productPriceView.updateShopLinks(with: viewModel.sortedShopLinks)    }
}

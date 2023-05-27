//
//  OnboardingViewController.swift
//  UniverseAppsTest
//
//  Created by Руслан Луценко on 27.05.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Properties

    private let backgroundImageView: UIImageView = {
        let backgroundImage = UIImage(named: LocalConstants.backgroundImageName)
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImageView
    }()

    private let pageControl: RoundedRectanglePageControl = {
        let pageControl = RoundedRectanglePageControl()
        pageControl.setCurrentPage(0)
        pageControl.setNumberOfPages(4)
        pageControl.isHidden = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.sectionInset = .init(top: .zero,
                                    left: LocalConstants.LayoutConstants.spacing,
                                    bottom: .zero,
                                    right: LocalConstants.LayoutConstants.spacing)
        layout.minimumLineSpacing = LocalConstants.LayoutConstants.cellSpacing
        layout.itemSize = .init(width: cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: LocalConstants.collectionViewCellIdentifier)

        return collectionView
    }()

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = LocalConstants.LayoutConstants.continueButtonCornerRadius
        return button
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear

        do {
            let string = try NSMutableAttributedString(markdown: LocalConstants.TextConstants.textViewString)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            string.addAttributes([
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: LocalConstants.ColorConstants.secondaryTintColor,
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: string.length))

            textView.attributedText = string
        } catch {
            print("Error creating attributed string: \(error)")
        }

        return textView
    }()

    private let navigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let xmarkImage = UIImage(systemName: LocalConstants.exitButtonImageName)
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = LocalConstants.ColorConstants.restorePurchaseTintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let stackViewSpacer: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()

    private let restorePurchaseButton: UIButton = {
        let restorePurchaseButton = UIButton(type: .system)
        restorePurchaseButton.setTitle("Restore Purchase", for: .normal)
        restorePurchaseButton.tintColor = .blue
        restorePurchaseButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        restorePurchaseButton.setTitleColor(LocalConstants.ColorConstants.restorePurchaseTintColor, for: .normal)
        restorePurchaseButton.translatesAutoresizingMaskIntoConstraints = false
        return restorePurchaseButton
    }()

    private let onboardingCellsData: [OnboardingData] = [
        OnboardingData(title: "Your Personal\nAssistant",
                       description: "Simplify your life\nwith an AI companion",
                       imageName: "onboardingIntroductionImage"),
        OnboardingData(title: "Get assistance\nwith any topic",
                       description: "From daily tasks to complex\nqueries, we’ve got you covered",
                       imageName: "onboardingAssistanceImage"),
        OnboardingData(title: "Perfect copy\nyou can rely on",
                       description: "Generate professional\ntexts effortlessly",
                       imageName: "onboardingGenerationImage"),
        OnboardingData(title: "Upgrade for Unlimited\nAI Capabilities",
                       description: "7-Day Free Trial,\nthen $19.99 /month, auto-renewable",
                       imageName: "onboardingCapabilitiesImage")
    ]

    private let cellWidth: CGFloat = LocalConstants.LayoutConstants.cellWidthMultiplier * UIScreen.main.bounds.width
    private let cellHeight: CGFloat = LocalConstants.LayoutConstants.cellHeightMultiplier * UIScreen.main.bounds.height
    private let spacing: CGFloat = LocalConstants.LayoutConstants.spacingMultiplier * UIScreen.main.bounds.width
    private let cellSpacing: CGFloat = LocalConstants.LayoutConstants.cellSpacingMultiplier * UIScreen.main.bounds.width

    private let viewModel: OnboardingViewModel

    // MARK: - Initialization

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(navigationStackView)
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(collectionView)
        view.addSubview(continueButton)
        view.addSubview(pageControl)
        view.addSubview(textView)

        view.sendSubviewToBack(backgroundImageView)

        navigationStackView.addArrangedSubview(restorePurchaseButton)
        navigationStackView.addArrangedSubview(stackViewSpacer)
        navigationStackView.addArrangedSubview(closeButton)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                                     constant: LocalConstants.LayoutConstants.backgroundImageViewTop),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: LocalConstants.LayoutConstants.backgroundImageViewLeading),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: LocalConstants.LayoutConstants.backgroundImageViewTrailing),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                        constant: LocalConstants.LayoutConstants.backgroundImageViewBottom),

            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: LocalConstants.LayoutConstants.navigationStackViewLeading),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: LocalConstants.LayoutConstants.navigationStackViewTrailing),
            navigationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                     constant: LocalConstants.LayoutConstants.navigationStackViewTop),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: LocalConstants.LayoutConstants.collectionViewLeading),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: LocalConstants.LayoutConstants.collectionViewTrailing),
            collectionView.topAnchor.constraint(equalTo: navigationStackView.bottomAnchor,
                                                constant: LocalConstants.LayoutConstants.collectionViewTop),
            collectionView.heightAnchor.constraint(equalToConstant: LocalConstants.LayoutConstants.collectionViewHeight),

            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                constant: LocalConstants.LayoutConstants.continueButtonTop),
            continueButton.widthAnchor.constraint(equalToConstant: LocalConstants.LayoutConstants.continueButtonWidth),
            continueButton.heightAnchor.constraint(equalToConstant: LocalConstants.LayoutConstants.continueButtonHeight),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor,
                                                 constant: LocalConstants.LayoutConstants.pageControlCenterX),
            pageControl.topAnchor.constraint(equalTo: continueButton.bottomAnchor,
                                             constant: LocalConstants.LayoutConstants.pageControlTop),

            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: LocalConstants.LayoutConstants.textViewLeading),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: LocalConstants.LayoutConstants.textViewTrailing),
            textView.topAnchor.constraint(equalTo: continueButton.bottomAnchor,
                                          constant: LocalConstants.LayoutConstants.textViewTop),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                             constant: LocalConstants.LayoutConstants.textViewBottom)
        ])

        restorePurchaseButton.addTarget(self, action: #selector(self.restorePurchaseButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }

    private func getCurrentPage() -> Int {
        let collectionViewWidth = self.collectionView.bounds.width
        let currentPage = Int((collectionView.contentOffset.x + collectionViewWidth / 2) / collectionViewWidth)
        return currentPage
    }

    @objc private func subscribeButtonTapped() {
        viewModel.makeSubscription()
    }

    @objc private func restorePurchaseButtonTapped() {
        viewModel.restorePurchase()
    }

    @objc private func continueButtonTapped() {
        let currentOffset = collectionView.contentOffset
        let nextPage = Int(round(currentOffset.x / (cellWidth + cellSpacing))) + 1
        let nextIndexPath = IndexPath(item: nextPage, section: 0)

        UIView.animate(withDuration: 0.3) {
            if nextPage > self.onboardingCellsData.count - 1 { return }
            self.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: false)
            self.pageControl.setCurrentPage(nextPage)
            self.pageControl.layoutSubviews()
            if self.getCurrentPage() == 3 {
                self.continueButton.setTitle("Try free & Subscribe", for: .normal)
                self.continueButton.removeTarget(self, action: #selector(self.continueButtonTapped), for: .touchUpInside)
                self.continueButton.addTarget(self, action: #selector(self.subscribeButtonTapped), for: .touchUpInside)
                return
            }
        }
    }

}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingCellsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocalConstants.collectionViewCellIdentifier,
                                                      for: indexPath) as? OnboardingCell

        let data = onboardingCellsData[indexPath.item]

        let isLastItem = indexPath.item == indexPath.count - 1
        cell?.configureCell(with: data, isLastCell: isLastItem)

        cell?.contentView.layer.backgroundColor = LocalConstants.ColorConstants.collectionViewBackgroundColor.cgColor
        cell?.contentView.layer.cornerRadius = LocalConstants.LayoutConstants.onboardingCellCornerRadius
        cell?.clipsToBounds = true

        return cell ?? OnboardingCell(frame: view.frame)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = getCurrentPage()
        pageControl.setCurrentPage(currentPage)
        pageControl.isHidden = currentPage == 0 || currentPage == 3
        textView.isHidden = currentPage == 1 || currentPage == 2

        if currentPage <= 2 {
            navigationStackView.isHidden = true
        } else if currentPage == 3 {
            navigationStackView.isHidden = false
        }
    }

}

// MARK: - Local Constants

fileprivate enum LocalConstants {

    enum LayoutConstants {
        static let cellWidthMultiplier: CGFloat = 0.85
        static let cellHeightMultiplier: CGFloat = 0.65
        static let spacingMultiplier: CGFloat = 0.0625
        static let cellSpacingMultiplier: CGFloat = 0.03125
        static let spacing: CGFloat = 16.0
        static let cellSpacing: CGFloat = 16.0
        static let onboardingCellCornerRadius: CGFloat = 20.0
        static let continueButtonCornerRadius: CGFloat = 25.0
        static let backgroundImageViewTop: CGFloat = 0
        static let backgroundImageViewLeading: CGFloat = 0
        static let backgroundImageViewTrailing: CGFloat = 0
        static let backgroundImageViewBottom: CGFloat = 0
        static let navigationStackViewLeading: CGFloat = 16
        static let navigationStackViewTrailing: CGFloat = -16
        static let navigationStackViewTop: CGFloat = 8
        static let collectionViewLeading: CGFloat = 0
        static let collectionViewTrailing: CGFloat = 0
        static let collectionViewTop: CGFloat = 16
        static let continueButtonTop: CGFloat = 16
        static let continueButtonHeight: CGFloat = 50
        static let pageControlCenterX: CGFloat = -6
        static let pageControlTop: CGFloat = 32
        static let textViewLeading: CGFloat = 0
        static let textViewTrailing: CGFloat = 0
        static let textViewTop: CGFloat = 16
        static let textViewBottom: CGFloat = -40
        static let collectionViewHeight: CGFloat = cellHeightMultiplier * UIScreen.main.bounds.height
        static let continueButtonWidth: CGFloat = cellWidthMultiplier * UIScreen.main.bounds.width
    }
    struct TextConstants {
        static let continueButtonTitle = "Continue"
        static let textViewString = """
            By continuing you accept our:\u{2028}
            [Terms of Use](\(termsOfUseLink)),
            [Privacy Policy](\(privacyPolicyLink)) and
            [Subscription Terms](\(subscriptionTermsLink))
            """
        static let termsOfUseLink = "https://assistai.guru/documents/tos.html"
        static let privacyPolicyLink = "https://assistai.guru/documents/privacy.html"
        static let subscriptionTermsLink = "https://assistai.guru/documents/subscription.html"
    }

    struct ColorConstants {
        static let secondaryTintColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1)
        static let restorePurchaseTintColor = UIColor(red: 0.565, green: 0.6, blue: 0.651, alpha: 1)
        static let collectionViewBackgroundColor = UIColor(red: 0.014, green: 0.355, blue: 0.603, alpha: 0.24)
        static let continueButtonTitleColor = UIColor.black
        static let continueButtonBackgroundColor = UIColor.white
    }

    static let exitButtonImageName = "xmark"
    static let backgroundImageName = "onboardingBackgroundImage"
    static let collectionViewCellIdentifier = "onboardingCell"

}

//
//  OnboardingCell.swift
//  UniverseAppsTest
//
//  Created by Руслан Луценко on 27.05.2023.
//

import UIKit

final class OnboardingCell: UICollectionViewCell {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = LocalConstant.titleLabelTextColor
        label.font = LocalConstant.titleLabelFont
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = LocalConstant.descriptionLabelTextColor
        label.font = LocalConstant.descriptionLabelFont
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: LocalConstant.imageViewTopAnchorConstant).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: LocalConstant.imageViewWidthAnchorConstant).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LocalConstant.titleLabelTopAnchorConstant).isActive = true

        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LocalConstant.descriptionLabelTopAnchorConstant).isActive = true
    }

    // MARK: - Cell Configuration

    func configureCell(with data: OnboardingData, isLastCell: Bool) {
        titleLabel.text = data.title

        if isLastCell {
            let attributedString = NSMutableAttributedString(string: data.description)
            let boldFont = UIFont.systemFont(ofSize: 17, weight: .bold)
            let priceRange = (data.description as NSString).range(of: "$19.99")

            attributedString.addAttribute(.font, value: boldFont, range: priceRange)
            attributedString.addAttribute(.foregroundColor, value: LocalConstant.titleLabelTextColor, range: priceRange)

            descriptionLabel.attributedText = attributedString
        } else {
            descriptionLabel.text = data.description
        }

        imageView.image = UIImage(named: data.imageName)
    }

}

// MARK: - Local Constants

fileprivate enum LocalConstant {

    static let cellWidth = (8.5 / 10) * UIScreen.main.bounds.width
    static let titleLabelTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let titleLabelFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    static let descriptionLabelTextColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
    static let descriptionLabelFont = UIFont.systemFont(ofSize: 17, weight: .medium)
    static let imageViewTopAnchorConstant: CGFloat = 30
    static let imageViewWidthAnchorConstant: CGFloat = cellWidth - 20
    static let titleLabelTopAnchorConstant: CGFloat = 24
    static let descriptionLabelTopAnchorConstant: CGFloat = 16

}

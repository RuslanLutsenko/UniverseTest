//
//  RoundedRectanglePageControl.swift
//  UniverseAppsTest
//
//  Created by Руслан Луценко on 27.05.2023.
//

import UIKit

final class RoundedRectanglePageControl: UIControl {

    private var numberOfPages: Int = 0
    private var currentPage: Int = 0

    override var intrinsicContentSize: CGSize {
        let width = CGFloat(numberOfPages - 1) * LocalConstants.dotSize.width + 1 * LocalConstants.activeDotSize.width + CGFloat(max(0, numberOfPages - 2)) * LocalConstants.dotSpacing
        let height = LocalConstants.dotSize.height
        return CGSize(width: width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let totalWidth = CGFloat(numberOfPages - 2) * LocalConstants.dotSize.width + LocalConstants.activeDotSize.width + CGFloat(max(0, numberOfPages - 1)) * LocalConstants.dotSpacing
        let startX = (bounds.width - totalWidth) / 2

        for (index, subview) in subviews.enumerated() {
            let isActiveDot = index == currentPage
            var frame = CGRect(origin: .zero, size: isActiveDot ? LocalConstants.activeDotSize : LocalConstants.dotSize)
            frame.origin.x = startX + CGFloat(index) * (LocalConstants.dotSize.width + LocalConstants.dotSpacing)

            let dotIndexOffset = index > currentPage ? 1 : 0
            let spacing = (LocalConstants.activeDotSize.width - LocalConstants.dotSize.width) * CGFloat(dotIndexOffset)
            frame.origin.x += spacing

            subview.frame = frame
            subview.layer.cornerRadius = frame.size.height / 2
            subview.backgroundColor = isActiveDot ? LocalConstants.activeDotColor : LocalConstants.inactiveDotColor

            if let label = subview.subviews.first as? UILabel {
                label.frame = subview.bounds
            }
        }
    }

    func setNumberOfPages(_ numberOfPages: Int) {
        subviews.forEach { $0.removeFromSuperview() }

        self.numberOfPages = max(0, numberOfPages)
        for _ in 0..<numberOfPages {
            let dotView = UIView(frame: CGRect(origin: .zero, size: LocalConstants.dotSize))
            dotView.layer.cornerRadius = LocalConstants.dotSize.height / 2
            dotView.backgroundColor = LocalConstants.inactiveDotColor
            addSubview(dotView)
        }

        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    func setCurrentPage(_ currentPage: Int) {
        let previousPage = self.currentPage
        self.currentPage = max(0, min(numberOfPages - 1, currentPage))

        if previousPage != self.currentPage {
            subviews.enumerated().forEach { index, dotView in
                dotView.backgroundColor = index == self.currentPage ? LocalConstants.activeDotColor : LocalConstants.inactiveDotColor
                dotView.frame.size = index == self.currentPage ? LocalConstants.activeDotSize : LocalConstants.dotSize
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }

            setNeedsLayout()
            sendActions(for: .valueChanged)
        }
    }

}


fileprivate enum LocalConstants {

    static let dotSize = CGSize(width: 14, height: 4)
    static let activeDotSize = CGSize(width: 25, height: 4)
    static let dotSpacing: CGFloat = 8
    static let activeDotWidthMultiplier: CGFloat = 1.5
    static let inactiveDotColor: UIColor = .gray
    static let activeDotColor: UIColor = .tintColor
    
}


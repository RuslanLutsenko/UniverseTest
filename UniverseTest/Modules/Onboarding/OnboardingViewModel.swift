//
//  OnboardingViewModel.swift
//  UniverseAppsTest
//
//  Created by Руслан Луценко on 27.05.2023.
//

import Foundation
import StoreKit

protocol OnboardingViewModel {
    func fetchOnboardingCellsData() -> [OnboardingData]

    func makeSubscription()
    func restorePurchase()
}

final class OnboardingViewModelImpl: OnboardingViewModel {

    // MARK: - Properties

    private let subscriptionManager: SubscriptionManager
    private let onboardingCellsData: [OnboardingData]

    // MARK: - Initialization

    init(subscriptionManager: SubscriptionManager) {
        self.subscriptionManager = subscriptionManager

        self.onboardingCellsData = [
            OnboardingData(title: LocalConstants.OnboardingTexts.personalAssistantTitle,
                           description: LocalConstants.OnboardingTexts.personalAssistantDescription,
                           imageName: LocalConstants.OnboardingImages.introduction),
            OnboardingData(title: LocalConstants.OnboardingTexts.assistanceTitle,
                           description: LocalConstants.OnboardingTexts.assistanceDescription,
                           imageName: LocalConstants.OnboardingImages.assistance),
            OnboardingData(title: LocalConstants.OnboardingTexts.generationTitle,
                           description: LocalConstants.OnboardingTexts.generationDescription,
                           imageName: LocalConstants.OnboardingImages.generation),
            OnboardingData(title: LocalConstants.OnboardingTexts.upgradeTitle,
                           description: LocalConstants.OnboardingTexts.upgradeDescription,
                           imageName: LocalConstants.OnboardingImages.capabilities)
        ]

        subscriptionManager.startObservingTransactions()
        subscriptionManager.delegate = self
    }

    deinit {
        subscriptionManager.stopObservingTransactions()
    }

    func fetchOnboardingCellsData() -> [OnboardingData] {
        onboardingCellsData
    }

    func makeSubscription() {
        subscriptionManager.initiatePurchase(for: ProductIdentifiers.monthly.rawValue)
    }

    func restorePurchase() {
        subscriptionManager.restorePurchases()
    }
    
}

// MARK: - SubscriptionManagerDelegate

extension OnboardingViewModelImpl: SubscriptionManagerDelegate {

    func subscriptionManagerDidFinishTransaction(_ transaction: SKPaymentTransaction) {
        print("Finished Transaction")
    }

    func subscriptionManagerDidFailTransaction(_ transaction: SKPaymentTransaction, withError error: Error) {
        print("Transaction failed with error: \(error.localizedDescription)")
    }

    func subscriptionManagerDidRestoreTransactions(_ transactions: [SKPaymentTransaction]) {
        print("Did restore")
    }

}

// MARK: - Local Constants

fileprivate enum LocalConstants {

    enum ProductIdentifiers {
        static let monthly = "com.example.app.monthly"
    }

    enum OnboardingImages {
        static let introduction = "onboardingIntroductionImage"
        static let assistance = "onboardingAssistanceImage"
        static let generation = "onboardingGenerationImage"
        static let capabilities = "onboardingCapabilitiesImage"
    }

    enum OnboardingTexts {
        static let personalAssistantTitle = "Your Personal\nAssistant"
        static let personalAssistantDescription = "Simplify your life\nwith an AI companion"
        static let assistanceTitle = "Get assistance\nwith any topic"
        static let assistanceDescription = "From daily tasks to complex\nqueries, we’ve got you covered"
        static let generationTitle = "Perfect copy\nyou can rely on"
        static let generationDescription = "Generate professional\ntexts effortlessly"
        static let upgradeTitle = "Upgrade for Unlimited\nAI Capabilities"
        static let upgradeDescription = "7-Day Free Trial,\nthen $19.99 /month, auto-renewable"
    }

}

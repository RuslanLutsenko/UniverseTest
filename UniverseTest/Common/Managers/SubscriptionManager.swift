//
//  SubscriptionManager.swift
//  UniverseAppsTest
//
//  Created by Руслан Луценко on 27.05.2023.
//

import Foundation
import StoreKit

protocol SubscriptionManagerDelegate: AnyObject {
    func subscriptionManagerDidFinishTransaction(_ transaction: SKPaymentTransaction)
    func subscriptionManagerDidFailTransaction(_ transaction: SKPaymentTransaction, withError error: Error)
    func subscriptionManagerDidRestoreTransactions(_ transactions: [SKPaymentTransaction])
}

final class SubscriptionManager: NSObject {

    private let subscriptionProductIdentifiers: Set<String> = ["com.UniverseAppsTest.monthly"]

    weak var delegate: SubscriptionManagerDelegate?

    func startObservingTransactions() {
        SKPaymentQueue.default().add(self)
    }

    func stopObservingTransactions() {
        SKPaymentQueue.default().remove(self)
    }

    func initiatePurchase(for productIdentifier: String) {
        guard SKPaymentQueue.canMakePayments() else {
            print("In-app purchases are not available.")
            return
        }

        let request = SKProductsRequest(productIdentifiers: [productIdentifier])
        request.delegate = self
        request.start()
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

}

// MARK: - SKProductsRequestDelegate

extension SubscriptionManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let product = response.products.first { product in
            subscriptionProductIdentifiers.contains(product.productIdentifier)
        }

        if let product = product {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("No valid products available.")
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product request failed with error: \(error.localizedDescription)")
    }

}

// MARK: - SKPaymentTransactionObserver

extension SubscriptionManager: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("Transaction is being processed...")
            case .purchased, .restored:
                delegate?.subscriptionManagerDidFinishTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    delegate?.subscriptionManagerDidFailTransaction(transaction, withError: error)
                }
            case .deferred:
                print("Transaction is pending external action.")
            @unknown default:
                print("Unknown transaction state.")
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let restoredTransactions = queue.transactions
        delegate?.subscriptionManagerDidRestoreTransactions(restoredTransactions)
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restore transactions failed with error: \(error.localizedDescription)")
    }

}

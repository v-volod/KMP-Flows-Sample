//
//  Publisher+FlowCollector.swift
//  iOS_Sample_App
//
//  Created by Volodymyr Voiko on 16.08.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import Common
import Combine

extension Publishers {
    final class FlowCollector<Output, Failure>: Publisher where Failure: Error {
        private let flow: Kotlinx_coroutines_coreFlow

        init(flow: Kotlinx_coroutines_coreFlow) {
            self.flow = flow
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = FlowCollectorSubscription(subscriber: subscriber, flow: flow)
            subscriber.receive(subscription: subscription)
            subscription.collect()
        }
    }
}

fileprivate final class FlowCollectorSubscription<S>: Subscription, Kotlinx_coroutines_coreFlowCollector where S: Subscriber {
    struct TypeCastError: LocalizedError {
        let receivedType: Any.Type
        let expectedType: Any.Type

        var errorDescription: String? {
            "Failed to cast value of type \(receivedType) to expected type \(expectedType)."
        }
    }

    var subscriber: S?
    let flow: Kotlinx_coroutines_coreFlow
    var collectionTask: Task<Void, Never>?

    init(subscriber: S?, flow: Kotlinx_coroutines_coreFlow) {
        self.subscriber = subscriber
        self.flow = flow
    }

    func request(_ demand: Subscribers.Demand) { }

    func collect() {
        collectionTask = .detached { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await flow.collect(collector: self)
            } catch {
                if let error = error as? S.Failure {
                    subscriber?.receive(completion: .failure(error))
                } else {
                    subscriber?.receive(completion: .finished)
                }
            }
        }
    }
    
    func cancel() {
        collectionTask?.cancel()
        collectionTask = nil
        subscriber = nil
    }

    func emit(value: Any?) async throws {
        guard let expectedValue = value as? S.Input else {
            throw TypeCastError(receivedType: type(of: value), expectedType: S.Input.self)
        }
        _ = subscriber?.receive(expectedValue)
    }
}

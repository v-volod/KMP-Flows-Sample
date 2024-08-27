//
//  Publisher+FlowCollector.swift
//  iOS_Sample_App
//
//  Created by Volodymyr Voiko on 16.08.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import Common
import Combine

struct FlowError: LocalizedError {
    let throwable: KotlinThrowable

    var errorDescription: String? { throwable.message }
}

extension Publishers {
    final class FlowCollector<Output: AnyObject>: Publisher {
        typealias Failure = FlowError
        private let flow: MultiplatformFlow<Output>

        init(flow: MultiplatformFlow<Output>) {
            self.flow = flow
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = FlowCollectorSubscription(subscriber: subscriber, flow: flow)
            subscriber.receive(subscription: subscription)
            subscription.collect()
        }
    }
}

fileprivate final class FlowCollectorSubscription<S>: Subscription where S: Subscriber, S.Input: AnyObject, S.Failure == FlowError {
    var subscriber: S?
    let flow: MultiplatformFlow<S.Input>
    var job: Kotlinx_coroutines_coreJob?

    init(subscriber: S?, flow: MultiplatformFlow<S.Input>) {
        self.subscriber = subscriber
        self.flow = flow
    }

    func request(_ demand: Subscribers.Demand) { }

    func collect() {
        job = flow.launchCollect { [weak self] value in
            _ = self?.subscriber?.receive(value)
        } onCompletion: { [weak self] error in
            if let error = error {
                self?.subscriber?.receive(completion: .failure(FlowError(throwable: error)))
            } else {
                self?.subscriber?.receive(completion: .finished)
            }
        }
    }
    
    func cancel() {
        job?.cancel(cause: nil)
        job = nil
        subscriber = nil
    }
}

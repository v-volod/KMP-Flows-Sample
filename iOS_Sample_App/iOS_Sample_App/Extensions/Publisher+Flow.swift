//
//  Publisher+Flow.swift
//  iOS_Sample_App
//
//  Created by Volodymyr Voiko on 16.08.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import Combine
import Common

extension Publisher where Output: AnyObject {
    var flow: MultiplatformFlow<Output> {
        var cancellable: AnyCancellable?
        return MultiplatformCallbackFlow<Output> { scope in
            cancellable = sink { completion in
                switch completion {
                case let .failure(error):
                    scope.cancel(exception: KotlinCancellationException(message: error.localizedDescription))
                case .finished:
                    scope.close()
                }
            } receiveValue: { value in
                scope.trySend(value: value)
            }
        } unsubscribe: {
            cancellable?.cancel()
            cancellable = nil
        }
    }
}

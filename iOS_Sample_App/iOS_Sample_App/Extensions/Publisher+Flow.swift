//
//  Publisher+Flow.swift
//  iOS_Sample_App
//
//  Created by Volodymyr Voiko on 16.08.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import Combine
import Common

final class Flow<P>: Kotlinx_coroutines_coreFlow where P: Publisher {
    private let values: AsyncThrowingPublisher<P>

    init(publisher: P) {
        values = publisher.values
    }

    @MainActor
    func collect(collector: any Kotlinx_coroutines_coreFlowCollector) async throws {
        for try await value in values {
            try await collector.emit(value: value)
        }
    }
}

extension Publisher {
    var flow: Flow<Self> {
        Flow(publisher: self)
    }
}


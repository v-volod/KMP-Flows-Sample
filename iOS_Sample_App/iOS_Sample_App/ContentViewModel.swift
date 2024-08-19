//
//  ContentViewModel.swift
//  iOS_Sample_App
//
//  Created by Volodymyr Voiko on 16.08.2024.
//  Copyright © 2024 orgName. All rights reserved.
//

import Foundation
import Common
import Combine

final class ContentViewModel: ObservableObject {
    @Published var rawText: String = ""
    @Published var encodedText: String = ""

    private var encodedTextSubscription: AnyCancellable?

    init() {
        let textEncoder = TextEncoder(rawText: $rawText.map(TextString.init(body:)).flow)
        encodedTextSubscription = Publishers.FlowCollector<TextString, Error>(flow: textEncoder.encodedText)
            .map(\.body)
            .catch { _ in Empty() }
            .receive(on: DispatchQueue.main)
            .assign(to: \.encodedText, on: self)
    }
}

package code.example.multiplatformflows.flow

import code.example.multiplatformflows.flow.channels.MultiplatformProducerScope
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow

class MultiplatformCallbackFlow<T : Any>(
    subscribe: (MultiplatformProducerScope<T>) -> Unit,
    unsubscribe: () -> Unit
) : MultiplatformFlow<T>(
    callbackFlow {
        subscribe(MultiplatformProducerScope(this))
        awaitClose { unsubscribe() }
    }
)
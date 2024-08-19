package code.example.multiplatformflows.flow.channels

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.cancel
import kotlinx.coroutines.channels.ProducerScope

class MultiplatformProducerScope<T>(private val scope: ProducerScope<T>) {
    fun trySend(value: T) {
        scope.trySend(value)
    }

    fun cancel(exception: CancellationException? = null) {
        scope.cancel(exception)
    }

    fun close() {
        scope.channel.close()
    }
}
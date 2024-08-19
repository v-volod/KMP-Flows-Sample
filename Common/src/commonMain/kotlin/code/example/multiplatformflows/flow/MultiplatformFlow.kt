package code.example.multiplatformflows.flow

import kotlinx.coroutines.flow.Flow

open class MultiplatformFlow<T : Any>(delegate: Flow<T>) : Flow<T> by delegate

fun <T : Any> Flow<T>.multiplatform(): MultiplatformFlow<T> = MultiplatformFlow(this)
package code.example.multiplatformflows.flow

import kotlinx.coroutines.Job
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

open class MultiplatformFlow<T : Any> internal constructor(
    delegate: Flow<T>
) : Flow<T> by delegate {
    fun launchCollect(
        onEmit: (T) -> Unit,
        onCompletion: (Throwable?) -> Unit
    ): Job = MainScope().launch {
        try {
            collect(onEmit)
            onCompletion(null)
        } catch (e: Throwable) {
            onCompletion(e)
        }
    }
}

fun <T : Any> Flow<T>.multiplatform(): MultiplatformFlow<T> = MultiplatformFlow(this)
package code.example.multiplatformflows
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

class TextEncoder(rawText: Flow<String>) {
    @OptIn(ExperimentalEncodingApi::class)
    val encodedText: Flow<String> = rawText.map { text ->
        Base64.encode(text.encodeToByteArray())
    }
}
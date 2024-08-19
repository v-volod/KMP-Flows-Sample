package code.example.multiplatformflows
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

data class TextString(val body: String)

class TextEncoder(rawText: Flow<TextString>) {
    @OptIn(ExperimentalEncodingApi::class)
    val encodedText: Flow<TextString> = rawText.map { text ->
        TextString(Base64.encode(text.body.encodeToByteArray()))
    }
}
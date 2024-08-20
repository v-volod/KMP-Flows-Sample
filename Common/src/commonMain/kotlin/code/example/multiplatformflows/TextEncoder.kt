package code.example.multiplatformflows

import code.example.multiplatformflows.flow.MultiplatformFlow
import code.example.multiplatformflows.flow.multiplatform
import kotlinx.coroutines.flow.map
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

data class RawText(val body: String)
data class EncodedText(val value: String)

class TextEncoder(rawText: MultiplatformFlow<RawText>) {
    @OptIn(ExperimentalEncodingApi::class)
    val encodedText: MultiplatformFlow<EncodedText> = rawText.map { text ->
        EncodedText(Base64.encode(text.body.encodeToByteArray()))
    }.multiplatform()
}
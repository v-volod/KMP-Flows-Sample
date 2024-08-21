package code.example.multiplatformflows.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import code.example.multiplatformflows.TextEncoder
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    ContentView()
                }
            }
        }
    }
}

class ContentViewModel : ViewModel() {
    private val _rawText = MutableStateFlow("")
    val rawText: StateFlow<String> = _rawText

    private val _encodedText = MutableStateFlow("")
    val encodedText: StateFlow<String> = _encodedText

    private val textEncoder = TextEncoder(_rawText)

    init {
        collectEncodedText()
    }

    private fun collectEncodedText() {
        viewModelScope.launch {
            textEncoder.encodedText.collect { encoded ->
                _encodedText.value = encoded
            }
        }
    }

    fun updateRawText(newText: String) {
        _rawText.value = newText
    }
}

@Composable
fun ContentView(viewModel: ContentViewModel = viewModel()) {
    val inputText by viewModel.rawText.collectAsState()
    val encodedText by viewModel.encodedText.collectAsState()

    Column(
        modifier = Modifier
            .padding(16.dp)
            .fillMaxSize()
    ) {
        TextField(
            value = inputText,
            onValueChange = { viewModel.updateRawText(it) },
            label = { Text("Enter text to encode") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(16.dp))
        Text(
            text = "Encoded Text: $encodedText",
            style = MaterialTheme.typography.bodySmall
        )
    }
}

@Preview
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        ContentView()
    }
}
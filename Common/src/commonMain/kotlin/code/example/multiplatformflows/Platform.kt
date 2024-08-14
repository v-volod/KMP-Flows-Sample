package code.example.multiplatformflows

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
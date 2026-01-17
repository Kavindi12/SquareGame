// MARK: - First Screen
struct ContentView: View {
    
    // Define SkyBlue color
    let skyBlue = Color(red: 135/255, green: 206/255, blue: 235/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.green, .blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    // Game Title
                    Text("🎨 Colour \nQuest")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Buttons
                    VStack(spacing: 20) {
                        levelButton("Easy", level: .easy)
                        levelButton("Medium", level: .medium)
                        levelButton("Hard", level: .hard)
                    }
                }
                .padding(.top, 60)
            }
        }
    }
    
    // MARK: - Reusable Button (same size every time)
    func levelButton(_ title: String, level: GameLevel) -> some View {
        NavigationLink {
            GameView(level: level)
        } label: {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, minHeight: 55)
                .background(skyBlue)
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(color: skyBlue.opacity(0.6), radius: 6, x: 2, y: 2)
        }
        .padding(.horizontal, 40)
    }
}

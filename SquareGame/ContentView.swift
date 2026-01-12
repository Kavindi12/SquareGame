//
//  ContentView.swift
//  SquareGame
//
//  Created by COBSCCOMP242P-022 on 2026-01-10.
//

import SwiftUI

// MARK: - Tile Model
struct Tile: Identifiable {
    let id = UUID()
    let color: Color
    var isRevealed = false
    var isMatched = false
    var isSingle = false   // Single unmatched tile
}

// MARK: - Game Levels
enum GameLevel: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }
}

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
                
                VStack(spacing: 50) { // Increased spacing to move title higher
                    
                    // Game Title - two lines
                    Text("🎨 Colour \nQuest")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Buttons
                    VStack(spacing: 20) {
                        NavigationLink("Easy") {
                            GameView(level: .easy)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(skyBlue)
                        .frame(maxWidth: 1000, minHeight: 50) // ✅ Fixed size
                        
                        NavigationLink("Medium") {
                            GameView(level: .medium)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(skyBlue)
                        .frame(maxWidth: 1000, minHeight: 50) // ✅ Fixed size
                        
                        NavigationLink("Hard") {
                            GameView(level: .hard)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(skyBlue)
                        .frame(maxWidth: 1000, minHeight: 50) // ✅ Fixed size
                    }
                }
                .padding(.top, 60) // Move title higher
            }
        }
    }
}


// MARK: - Game Screen
struct GameView: View {
    
    let level: GameLevel
    
    @State private var tiles: [Tile] = []
    @State private var selectedTiles: [Int] = []
    @State private var score: Int = 0
    @State private var moves: Int = 0
    
    let allColors: [Color] = [
        .red, .blue, .green, .orange, .pink, .purple,
        .yellow, .cyan, .mint, .indigo, .teal, .brown
    ]
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 5),
              count: level.gridSize)
    }
    
    var body: some View {
        VStack {
            
            // Score and Moves
            HStack {
                Text("Score: \(score)")
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                Spacer()
                Text("Moves: \(moves)")
                    .font(.title2)
                    .bold()
                    .padding(.trailing)
            }
            .padding(.top)
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(tiles.indices, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(
                                tiles[index].isRevealed || tiles[index].isMatched
                                ? tiles[index].color
                                : .gray
                            )
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(6)
                        
                        // If single tile and revealed, show block sign
                        if tiles[index].isSingle && (tiles[index].isRevealed || tiles[index].isMatched) {
                            Image(systemName: "nosign")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                    .onTapGesture {
                        tileTapped(index)
                    }
                }
            }
            .padding()
            
            Button("Restart Level") {
                setupGame()
            }
            .padding(.bottom)
        }
        .navigationTitle(level.rawValue)
        .onAppear {
            setupGame()
        }
    }
    
    // MARK: - Game Logic
    
    func setupGame() {
        let totalTiles = level.gridSize * level.gridSize
        let pairCount = (totalTiles - 1) / 2   // leave space for single tile
        
        var tempTiles: [Tile] = []
        
        // Create pairs
        for i in 0..<pairCount {
            let color = allColors[i % allColors.count]
            tempTiles.append(Tile(color: color))
            tempTiles.append(Tile(color: color))
        }
        
        // Add one single unmatched tile
        let singleColor = allColors.randomElement()!
        tempTiles.append(Tile(color: singleColor, isSingle: true))
        
        tempTiles.shuffle()
        tiles = tempTiles
        selectedTiles.removeAll()
        score = 0
        moves = 0
    }
    
    func tileTapped(_ index: Int) {
        if tiles[index].isMatched || tiles[index].isRevealed {
            return
        }
        
        tiles[index].isRevealed = true
        selectedTiles.append(index)
        
        if selectedTiles.count == 2 {
            moves += 1  // ✅ Increment moves on every pair flipped
            checkMatch()
        }
    }
    
    func checkMatch() {
        let first = selectedTiles[0]
        let second = selectedTiles[1]
        
        // If any tile is single → not match
        if tiles[first].isSingle || tiles[second].isSingle {
            score -= 2
            hideTiles(first, second)
            selectedTiles.removeAll()
            return
        }
        
        if tiles[first].color == tiles[second].color {
            tiles[first].isMatched = true
            tiles[second].isMatched = true
            score += 10
        } else {
            score -= 2
            hideTiles(first, second)
        }
        
        selectedTiles.removeAll()
    }
    
    func hideTiles(_ first: Int, _ second: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            tiles[first].isRevealed = false
            tiles[second].isRevealed = false
        }
    }
}

#Preview {
    ContentView()
}

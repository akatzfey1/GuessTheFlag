//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alexander Katzfey on 2/18/22.
//

import SwiftUI

struct BlueTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}

extension View {
    func blueTitle() -> some View {
        modifier(BlueTitleModifier())
    }
}

struct FlagImage: View {
    var img: String
    
    var body: some View {
        Image(img)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var currentQuestion = 1
    @State private var prevCountry = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Question #\(currentQuestion)/8")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(img: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(playerScore)")
        }
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button(role: .cancel, action: restartGame, label: {
                Text("Start Over")
            })
        } message: {
            Text("Your final score is: \(playerScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if currentQuestion == 8 {
            showingFinalScore = true
        } else {
            prevCountry = countries[correctAnswer]
            
            while(countries[correctAnswer] == prevCountry){
                randomizeQuestion()
            }
            
            currentQuestion += 1
        }
    }
    
    func restartGame() {
        currentQuestion = 1
        playerScore = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func randomizeQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

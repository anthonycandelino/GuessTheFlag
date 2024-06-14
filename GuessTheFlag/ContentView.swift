/*
 GuessTheFlag App

 Created by Anthony Candelino on 2024-06-10.
 */

import SwiftUI

struct FlagImage: View {
    var flagIndex: Int
    var countries: [String]
    var body: some View {
        Image(countries[flagIndex]).clipShape(.capsule).shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var selectedFlagNumber = 0
    @State private var questionRound = 0
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .pink], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Spacer()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of") .font(.largeTitle.bold())
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flagIndex: number, countries: countries)
                        }
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }.padding()
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(getScoreAlertMessage())
        }.alert("End of Game", isPresented: $showingFinalScore) {
            Button("Yes", action: resetGame)
        } message: {
            Text("Your final score is: \(userScore). \n Wanna play again?")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlagNumber = number
        scoreTitle = number == correctAnswer ? "Correct!" : "Wrong"
        userScore = number == correctAnswer ? userScore + 1 : userScore
        questionRound += 1
        if (questionRound != 8) {
            showingScore = true
        } else {
            showingFinalScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func getScoreAlertMessage() -> String {
        var message = ""
        if selectedFlagNumber != correctAnswer {
            message += "That's the flag of \(countries[selectedFlagNumber]). \n"
        }
        message += "Your score is now \(userScore)"
        return message
    }
    
    func resetGame() {
        userScore = 0
        questionRound = 1
        askQuestion()
    }
}

#Preview {
    ContentView()
}

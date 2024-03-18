//
//  test.swift
//  Tabuada
//
//  Created by Igor Florentino on 14/03/24.
//

import SwiftUI

struct Quiz: View {
	
	let questions: [(table: Int, pair: Int, answer: Int)]
	@State private var userAnswers: [Int?]
	
	private var score: Int {
		var result = 0
		for i in 0..<questions.count{
			if userAnswers[i] == questions[i].answer{
				result += 1
			}
		}
		return result
	}
	
	@State private var showCorrectAnswer = false
	@State private var showGabarito = false
	@State private var newGame = false

	
	var body: some View {
		NavigationStack{
			VStack{
				Section(){
					Form(){
						ForEach(questions.indices, id:\.self){ indice in
							HStack{
								Text("\(questions[indice].table)*\(questions[indice].pair): ")
									.font(.headline)
								TextField("Your answer", value:$userAnswers[indice], format: .number)
									.onChange(of: userAnswers[indice]) { _, _ in
										withAnimation {
											showGabarito = true
										}
									}
								if showGabarito {
									Text(userAnswers[indice] == questions[indice].answer ? "Correct!" : "Wrong!")
										.foregroundStyle(userAnswers[indice] == questions[indice].answer ? .blue:.red)
										.opacity(userAnswers[indice] != nil ? 1 : 0)
										.animation(.default, value: (userAnswers[indice]))
								}
								if showCorrectAnswer {
									Text("Answer: \(questions[indice].answer)")
										.foregroundStyle(userAnswers[indice] == questions[indice].answer ? .blue:.red)
								}
							}
						}
					}
				}
				VStack{
					Button{
						withAnimation {
							showCorrectAnswer.toggle()
						}
					}label:{
						Text("Hide/Show answers")
							.padding()
							.underline()
					}
					if showCorrectAnswer {
						Text("Total correct: \(score)")
					}
				}	.frame(maxWidth: .infinity)
					.background(.blue)
					.foregroundStyle(.white)
			}
			.navigationTitle("How much is")
		}
	}
	
	init(questions: [(table: Int, pair: Int, answer: Int)]) {
		self.questions = questions
		_userAnswers = State(initialValue: Array(repeating: nil, count: questions.count))
	}
}

#Preview {
	let questionsSample = Array(repeating: (2,3,6), count: ContentView().questionPoolSize)
	return Quiz(questions: questionsSample)
}

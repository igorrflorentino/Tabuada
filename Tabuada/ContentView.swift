//
//  ContentView.swift
//  Tabuada
//
//  Created by Igor Florentino on 13/03/24.
//

import SwiftUI

struct ContentView: View {
	
	static private let maximumLevel = 13
	
	static private var buttonsLevelToShow: [Int] {
		Array(2...maximumLevel)
	}
	
	static private var allMultiTables: [[(String,Int)]] = {
		var multiTablesOuter: [[(math:String, result:Int)]] = Array(repeating: [], count: maximumLevel+1)
		for i in 0..<maximumLevel+1 {
			var multiTablesInner: [(math:String, result:Int)] = Array(repeating: ("",-1), count: maximumLevel+1)
			for j in 0..<maximumLevel+1 {
				multiTablesInner[j].math = "\(i)*\(j)"
				multiTablesInner[j].result = i*j
			}
			multiTablesOuter[i] = multiTablesInner
		}
		return multiTablesOuter
	}()
	
	let columns: [GridItem] = [
		GridItem(.flexible(), spacing: 0),
		GridItem(.flexible(), spacing: 0),
		GridItem(.flexible(), spacing: 0),
	]
	
	@State var questionPoolSize = 5
	@State private var availableMultiTables = Array(repeating: false, count: maximumLevel+1)
	@State private var gameStarted = false
	
	var questionPool: [(table: Int, pair: Int, answer: Int)] {
		var pool = [(Int,Int,Int)]()
		let selectedMultiTables = availableMultiTables.enumerated().filter{$0.element==true}.map{$0.offset}
		if selectedMultiTables.isEmpty {return []}
		for _ in 0..<questionPoolSize{
			let randomSelectedMultiTable = selectedMultiTables.randomElement()
			let randomQuestion = Int.random(in: 0...Self.maximumLevel)
			pool.append(
				(randomSelectedMultiTable!,
				 randomQuestion,
				 Self.allMultiTables[randomSelectedMultiTable!][randomQuestion].1)
			)
		}
		return pool
	}
	
	var body: some View {
		NavigationStack{
			VStack{
				Text("Chose the multiplication table")
					.font(.headline)
					.textCase(.uppercase)
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(Self.buttonsLevelToShow, id:\.self) { index in
						Text("\(index)")
							.frame(minWidth: 70, minHeight: 70)
							.background(Color.blue)
							.clipShape(Circle())
							.onTapGesture {
								availableMultiTables[index].toggle()
							}
							.saturation(availableMultiTables[index] ? 1:3)
							.scaleEffect(availableMultiTables[index] ? 1.1:1)
							.animation(.default, value: availableMultiTables[index])
					}
				}.padding(.horizontal, 50)
				VStack{
					Text("How many question do you want to answer?")
						.font(.headline)
					Picker("Questions ", selection: $questionPoolSize){
						Text(String(5)).tag(5)
						Text(String(10)).tag(10)
						Text(String(20)).tag(20)
					}.pickerStyle(.segmented)
				}
				.padding(.vertical)
				Button{
					questionPool.isEmpty ? (gameStarted = false) : (gameStarted = true)
				}label:{
					Text("Start")
						.padding()
						.frame(width: 100, height: 50)
						.background(.blue)
						.foregroundStyle(.white)
						.clipShape(.capsule)
				}.navigationDestination(isPresented: $gameStarted) {
					Quiz(questions: questionPool)
				}.opacity(questionPool.isEmpty ? 0:1)
					.animation(.default, value: questionPool.isEmpty)
			}.navigationTitle("Tabuada Game")
				.padding(.horizontal)
		}
	}
}

#Preview {
	ContentView()
}

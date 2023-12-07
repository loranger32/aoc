package main

import "testing"

func BenchmarkFunctionalStyle(b *testing.B) {
	for i := 0; i < b.N; i++ {
		functionalStyle("input.txt")
	}
}

func BenchmarkOneAtATimeStyle(b *testing.B) {
	for i := 0; i < b.N; i++ {
		oneAtATimeStyle("input.txt")
	}
}

func BenchmarkThreeAtATimeStyle(b *testing.B) {
	for i := 0; i < b.N; i++ {
		threeAtATime("input.txt")
	}
}

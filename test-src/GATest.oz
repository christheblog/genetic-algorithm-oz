functor  
import
	Application
	OzTest
	GA
	System
define
	
	local
		% Generating a predefined sequence of values
		fun {Predef Seq}
			S = {NewCell {List.reverse Seq}}
			fun {Next} 
				local X|T = @S in S := T X end
			end in
			Next
		end
		
		fun {TestPopGeneration}
			local
				NewI = {Predef ["AAAA" "CCCC" "GGGG" "TTTT"]}	% Creates a new individual
			in		
				{OzTest.assert ["AAAA" "CCCC" "GGGG" "TTTT"] {GA.newPopulation 4 NewI} _}
				true
			end	
		end
		
		fun {TestPopEvolution}
			local
				EvolvedStream = {GA.evolve ["A" "B" "C" "D"] fun {$ X} X end}	% Evolving the population with an identity function
				fun {Head X|_} X end
			in
				{OzTest.assert ["A" "B" "C" "D"] {Head {List.drop EvolvedStream 100}} _}
				true
			end	
		end
		
		
		% TODO
		
		fun {TestMatingPool}
			true
		end
		
		fun {TestNextGenNoOp}
			true
		end
		
		fun {TestNextGen}
			true
		end
	in
		% Running tests
		try
			{System.showInfo "Starting playing tests ..."}
			{OzTest.runTest "\tTesting population generation" TestPopGeneration _}
			{OzTest.runTest "\tTesting lazy evolution of the population" TestPopEvolution _}
			{OzTest.runTest "\tTesting mating pool generation" TestMatingPool _}
			{OzTest.runTest "\tTesting next generation computation with no operation" TestNextGenNoOp _}
			{OzTest.runTest "\tTesting next generation computation with operations" TestNextGen _}
			{System.showInfo "Test finished."}
		catch
			error(Msg) then {System.showInfo Msg}
		end
		{Application.exit 0}
	end
	
end

functor  
import
	Application
	OzTest
	Selector
	System
define
	
	local
		% Generating a predefined sequence of values
		fun {Predef Seq}
			S = {NewCell Seq}
			fun {Next _} 
				local X|T = @S in S := T X end
			end in
			Next
		end
		
		fun {TestTournament}
			local
				FitPop = [0.5#1 0.4#2 0.4#3 0.3#4 0.1#5]			% Fitness # Individual
				Rng = rng(nextIndex:{Predef [2 3 1 4]})				% rng with predefined sequence
				Select = {Selector.tournament Rng}					% Create tournament selector
			in		
				{OzTest.assert 0.4#3 {Select FitPop} _}
				{OzTest.assert 0.5#1 {Select FitPop} _}
				true
			end			
		end
	in
		% Running tests
		try
			{System.showInfo "Starting playing tests ..."}
			{OzTest.runTest "\tTournament selection" TestTournament _}
			{System.showInfo "Test finished."}
		catch
			error(Msg) then {System.showInfo Msg}
		end
		{Application.exit 0}
	end
	
end

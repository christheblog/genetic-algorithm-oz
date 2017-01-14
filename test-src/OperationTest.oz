functor  
import
	Application
	OzTest
	Operation
	System
define
	
	local
		fun {TestCrossover}
			local
				X = [1 1 1 1 1]		% Individual 1
				Y = [2 2 2 2 2]		% Individual 2
			in	
				{OzTest.assert (nil#nil) {Operation.crossoverAt nil nil 0} _}	
				{OzTest.assert ([2 2 2 2 2]#[1 1 1 1 1]) {Operation.crossoverAt X Y 1} _}
				{OzTest.assert ([1 2 2 2 2]#[2 1 1 1 1]) {Operation.crossoverAt X Y 2} _}
				{OzTest.assert ([1 1 2 2 2]#[2 2 1 1 1]) {Operation.crossoverAt X Y 3} _}
				{OzTest.assert ([1 1 1 2 2]#[2 2 2 1 1]) {Operation.crossoverAt X Y 4} _}
				{OzTest.assert ([1 1 1 1 2]#[2 2 2 2 1]) {Operation.crossoverAt X Y 5} _}
				true
			end			
		end
		
		fun {TestMutation}
			local
				X = [1 1 1 1 1]		% Individual
				Fn = fun {$ _ _} 2 end 
			in	
				{OzTest.assert [2 1 1 1 1] {Operation.mutateAt X 1 Fn} _}
				{OzTest.assert [1 2 1 1 1] {Operation.mutateAt X 2 Fn} _}
				{OzTest.assert [1 1 2 1 1] {Operation.mutateAt X 3 Fn} _}
				{OzTest.assert [1 1 1 2 1] {Operation.mutateAt X 4 Fn} _}
				{OzTest.assert [1 1 1 1 2] {Operation.mutateAt X 5 Fn} _}
				true
			end			
		end
	in
		% Running tests
		try
			{System.showInfo "Starting playing tests ..."}
			{OzTest.runTest "\tTesting crossover" TestCrossover _}
			{OzTest.runTest "\tTesting mutation" TestMutation _}
			{System.showInfo "Test finished."}
		catch
			error(Msg) then {System.showInfo Msg}
		end
		{Application.exit 0}
	end
	
end

functor
import
	Application
	OzTest
	Rand
	System
define   

	local
		% Testing all random doubles generated are in [0,1[
		fun {TestNextDoubleGeneration}
			local
				Rng = {Rand.snew 3}
				fun lazy {Nxt} {Rng.nextDouble}|{Nxt} end
				Rs = {Rng.nextDouble}|{Nxt}
			in	
				{OzTest.assert 0
					{List.length 
						{List.filter 
							{List.take Rs 1000000} 
							fun {$ X} {Not (X>=0.0 andthen X < 1.0)} end
						}
					}
				_ }
				true 
			end	
		end
		
		% Testing all random double 0.0 can be generated
		fun {TestNextDoubleZeroGeneration}
			local
				Rng = {Rand.snew 3}
				fun lazy {Nxt} {Rng.nextDouble}|{Nxt} end
				Rs = {Rng.nextDouble}|{Nxt}
			in	
				{OzTest.assertTrue
					({List.length 
						{List.filter 
							{List.take Rs 1000000} 
							fun {$ X} {Not (X>=0.0 andthen X < 1.0)} end
						}
					} > 0)
				_ }
				true 
			end	
		end
	in
		% Running tests
		try
			{System.showInfo "Starting playing tests ..."}
			{OzTest.runTest "\tTesting Double generation between 0.0 and 1.0" TestNextDoubleGeneration _}
			{OzTest.runTest "\tTesting Double generation can produce 0.0" TestNextDoubleZeroGeneration _}
			{System.showInfo "Test finished."}
		catch
			error(Msg) then {System.showInfo Msg}
		end
		{Application.exit 0}
	end
	
end
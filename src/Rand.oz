functor
import
	OS
export
	new:	New
	snew:	SNew
define   

	% Set the seed for a random generator
	fun {New} {SNew {OS.rand}} end

	% Set the seed for a random generator
	fun {SNew Seed}
		fun {NextInt} {OS.rand} end
		% 1-based index
		fun {NextIndex Len} ({Abs {NextInt}} mod Len) + 1 end
		% Quick and very dirty code to generate bad random floats < 1.0 ...
		fun {NextDouble} 
			local A={NextInt} B={NextInt} Epsilon=0.000001 in 
				{Int.toFloat {Value.min A B}} / ({Int.toFloat {Value.max A B}} + Epsilon) % No 0 division
			end 
		end
		in
			{OS.srand Seed}
			rng(nextInt:NextInt
				nextIndex:NextIndex 
				nextDouble:NextDouble)
	end
	
end
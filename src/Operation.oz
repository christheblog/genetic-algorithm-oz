functor
export
	crossoverFn:	SinglePointCrossoverFn
	crossoverAt:	SinglePointCrossoverAt
	mutateFn:		MutateFn
	mutateAt:		MutateAt
	preserve:		Noop
define   

	% Returns a function that will perform a crossover using the provided RNG
	fun {SinglePointCrossoverFn rng(nextIndex:NextIndex ...)}
		fun {$ G1 G2} {SinglePointCrossoverAt G1 G2 {NextIndex {Length G1}}} end
	end

	% Perform a single-point crossover of 2 lists
	fun {SinglePointCrossoverAt G1 G2 Index}
   		fun {Iterate G1 G2 I Acc1 Acc2}
   			case G1 # G2 of 
   				   (H1|T1) # (H2|T2) andthen I < Index then 
   				   		{Iterate T1 T2 (I+1) (H1|Acc1) (H2|Acc2)} 
   				[] (H1|T1) # (H2|T2) then 
   						{Iterate T1 T2 (I+1) (H2|Acc1) (H1|Acc2)}
   				[] nil # nil then {Reverse Acc1} # {Reverse Acc2}
   				else raise("Incompatible chromosome size") end
   			end
   		end in
   			{Iterate G1 G2 1 nil nil}
	end

	% Returns a function that will perform the mutation, using the provided RNG
	fun {MutateFn Fn rng(nextIndex:NextIndex ...)}
		fun {$ G} {MutateAt G {NextIndex {Length G}} Fn} end
	end

   	% Mutation of a specific gene - Applies function Fn to the selected gene at Index : {Fn Index Gene} is called
	fun {MutateAt G Index Fn}
   		{List.mapInd G fun {$ I X} if I==Index then {Fn I X} else X end end}
   	end
   	
   	% Keep individual as it is
	fun {Noop I} I end

end
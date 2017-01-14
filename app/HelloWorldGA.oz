functor
import
   Application
   System
   Rand
   Selector
   Operation
   GA
define
	local
		% Target string the GA will try to learn
		Target = "HELLOWORLD"  
		
		% Random Generator
		Rng = {Rand.new}
		fun {NextChar} {Rng.nextIndex 26} + 64 end
		
		% New individual factory : create a random string of length {List.length Target}
		NewIndividual = fun {$} 
			{List.map {List.make {List.length Target}} fun {$ _} {NextChar} end}
		end
		% Population
		Pop = {GA.newPopulation 100 NewIndividual}
			
		% Fitness function : how close are we from the Target string ?
		% Fitness = 1 / (1 + sum(abs(diff char code))
		% Max Fitness = 1.0
		FitnessFn = fun {$ C}
			local 
				fun {Sum Ls} case Ls of X|Xs then X + {Sum Xs} else 0 end end
			in
				1.0 / (1.0 + {Int.toFloat {Sum {List.zip Target C fun {$ X Y} {Abs (X-Y)} end}}})
			end
		end
		% Selector to select individuals from the population
		TS = {Selector.tournament Rng}
		% MatingFn to create a mating pool from a population
		MatingFn = fun {$ P} {GA.matingPool P FitnessFn TS} end
		% Genetic operators
		CrossFn = {Operation.crossoverFn Rng}
		MutateFn = {Operation.mutateFn fun {$ _ G} {NextChar} end Rng}
			
		% Next generation function factory
		NextFn = {GA.nextFn MatingFn Rng ops(crossover:CrossFn#0.6 mutation:MutateFn#0.1)}
		% Create a Stream of evolved populations
		Populations = {GA.evolve Pop NextFn}
	in
		{System.showInfo {GA.bestBy {List.nth Populations 1} FitnessFn}.2}
		{System.showInfo {GA.bestBy {List.nth Populations 10} FitnessFn}.2}
		{System.showInfo {GA.bestBy {List.nth Populations 100} FitnessFn}.2}
		{System.showInfo {GA.bestBy {List.nth Populations 250} FitnessFn}.2}
		{System.showInfo "Done"}
		{Application.exit 0}
	end
end

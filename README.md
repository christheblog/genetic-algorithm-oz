# A Genetic Algorithm library in Oz

## A small generic library

This project is a simple library to allow to run genetic algorihm. 

The main function to run is the following :

```oz
% Pop 		Initial population
% NextFn	Function taking the current population, and creating the population of the next generation
Populations = {GA.evolve Pop NextFn}
```

It will create an infinite stream of evolved populations. This design allows to express custom stop criterion elegantly using pattern matching and functions from the standard List module.
```oz
% Evolving a population to the 100th generation :
P100|_ = {List.drop {GA.evolve Pop NextFn} 100}

% Evolving a population until fitness of the best individual reaches a certain threshold :
fun {FitnessFn I} ... end
Threshold = 0.8
P|_ = {List.dropWhile {GA.evolve Pop NextFn} fun {$ P} {GA.bestBy P FitnessFn}.1 < Threshold end}
```

The library doesn't assume anything about the representation of the individual you are using, or how the next population is computed.
This gives full freedom to represent the individuals and next generation computation as you want. 
The library could easily be extended with a genetic programming module for instance (where individuals would be S-expression for instance)

## Building blocks

Usage is easy when you already have an initial population, and a function generating teh next generation.
```oz
% Pop 		Initial population
% NextFn	Function taking the current population, and creating the population of the next generation
Populations = {GA.evolve Pop NextFn}
```

The modules Rand, Selector, Operation and GA are providing functions to help you building the initial population and the NextFn function.

Building blocks are designed to work the following way :
- Generate randomly an initial population from a user-provided function
- Create a Next function, working the following way :
	- Creates a mating pool from the current population, using a user-provided MatingFn function.
	- Apply Crossovers and Mutations using user-provided functions and configurable probability
	- returning the newly generated population

The mating pool function can be generated using a user-provided fitness function and a user-provided selector function.
The selector function can also be generated using support form the Selector module.

This gives you a lot of control on what to use. 

Note : To use the building blocks, you may need to constraint your design to match some assumptions made by the functions - for instance an individual has to be represented by a list if you want to generate a crossover or a mutation function from the Operation module.

### GA module

The GA module provides the main functions and the main helper functions.

```oz
%
% Generate a population of N
% N - Number of individual to generate
% NewIndividual - Function to generate randomly new individuals
%
fun {NewPopulation N NewIndividual}

%
% Evolve stream of a population
% Pop - Initial population
% NextFn - Function computing the next population 
%
fun {Evolve Pop NextFn}
	
%
% Helper returning a function computing the next generation from a Population for a given : 
% MatingFn - (Pop -> Pop) to generate the mating pool (ie selecting individuals that will be used to generate new generation)
% rng(nextDouble:NextDbl ...) - random generator
% ops(crossover:CrossFn#Cfreq mutation:MutateFn#Mfreq) - genetic operators configuration
%
fun {NextFn MatingFn rng(nextDouble:NextDbl ...) ops(crossover:CrossFn#Cproba mutation:MutateFn#Mproba)}
	
%
% Mating pool - select individuals for reproduction using the provided selector
% The same individual can be selected multiple times
% Pop - Population
% FitnessFn - Function (Individual -> Float) to compute an individual fitness
% Select - Selector function (like tournament selector) that will select an individual from a Population of Fitness#Individual
%
fun {MatingPool Pop FitnessFn Select}
	
% Returns the individual with the highest fitness in a tuple : Fitness#Individual
fun {BestBy Pop FitnessFn}

```

### Selector module

The Selector module provides help to generate a selector function. The selector function is choosing an individual amongst the population, using the fitness information.
The Selector function can be pass to the {GA.matingPool} function. It will then be used to select individuals that will end-up in the mating pool.

The only selector implemented at the moment is a basic Tournament selector. Usage is :
```oz 
% Returns a function that will select one individual using fitness information
% The generated TS function takes in argument a population where individuals are mapped with their fitness in a tuple fashion Fitness#Individual
TS = {Selector.tournament Rng}
Individual = {TS FitPop}
```

### Operation module

Operation module provides support for genetic operations. At the moment only single-point crossover and mutation are implemented for individuals represented as lists.

```oz
% Genetic operators

% Crossover function generator
CrossFn = {Operation.crossoverFn Rng}
Cx1 # Cx2 = {CrossFn I1 I2}

% Mutation function generator
MutateFn = {Operation.mutateFn fun {$ Index Individual} ... end Rng}
Mutated = {MutateFn I1}
```

### Rand module

Oz doesn't have a very good support for random numbers. The Rand module builds a rng(...) atom to help you.

```oz
rng(nextInt:NextInt 		% OS.rand directly - generates a positive random integer
	nextIndex:NextIndex 	% {NextIndex Len} - generates a random integer in the range [1,Len]
	nextDouble:NextDouble	% {NextDouble} - generates a float in [0,1.0[
)
```

You can create a random generator rng using one of the ```oz {Rand.New}``` or ```oz {Rand.SNew Seed}``` functions.

## A simple "Hello World" example

Here is a small example of what it would take to implement a small GA trying to guess a String (Capitalized and no spaces).

```oz
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
		Target = "HELLOWORLD" % Target string the GA will try to learn
		
		Rng = {Rand.new} % Random Generator
		
		fun {NextChar} {Rng.nextIndex 26} + 64 end % generates a random char between 'A' and 'Z'
		% New individual factory : create a random string of length {List.length Target}
		fun {NewIndividual} 
			{List.map {List.make {List.length Target}} fun {$ _} {NextChar} end}
		end
			
		% Fitness function : how close are we from the Target string ?
		% Fitness = 1 / (1 + sum(abs(diff char code))
		% Max Fitness = 1.0
		fun {FitnessFn C}
			local fun {Sum Ls} case Ls of X|Xs then X + {Sum Xs} else 0 end end
			in 1.0 / (1.0 + {Int.toFloat {Sum {List.zip Target C fun {$ X Y} {Abs (X-Y)} end}}})
			end
		end
		
		% Selector to select individuals from the population
		TS = {Selector.tournament Rng}
		% MatingFn to create a mating pool from a population
		MatingFn = fun {$ P} {GA.matingPool P FitnessFn TS} end
		% Genetic operators
		CrossFn = {Operation.crossoverFn Rng}
		MutateFn = {Operation.mutateFn fun {$ _ G} {NextChar} end Rng}
		
		% Initial population randomly generated
		Pop = {GA.newPopulation 100 NewIndividual} 	
		% Next generation function factory
		NextFn = {GA.nextFn MatingFn Rng ops(crossover:CrossFn#0.6 mutation:MutateFn#0.1)}
		% Create a Stream of evolved populations
		Populations = {GA.evolve Pop NextFn}
	in
		{System.showInfo {GA.bestBy {List.nth Populations 250} FitnessFn}.2}
		{Application.exit 0}
	end
end
```
functor
import
  Utils
export
  newPopulation:  NewPopulation
  nextFn:      NextFn
  evolve:      Evolve
  matingPool:    MatingPool
  bestBy:      BestBy
define

  %
  % Generate a population of N
  % N - Number of individual to generate
  % NewIndividual - Function to generate randomly new individuals
  %
  fun {NewPopulation N NewIndividual}
    fun {Iterate N Acc}
      if N > 0
      then {Iterate N-1 {NewIndividual}|Acc}
      else Acc end
    end in
      {Iterate N nil}
  end

  %
  % Evolve stream of a population
  % Pop - Initial population
  % NextFn - Function computing the next population 
  %
  fun {Evolve Pop NextFn}
    fun lazy {Iterate P}
      P|{Iterate {NextFn P}}
    end in
      thread {Iterate Pop} end
  end
  
  %
  % Helper returning a function computing the next generation from a Population for a given : 
  % MatingFn - (Pop -> Pop) to generate the mating pool (ie selecting individuals that will be used to generate new generation)
  % rng(nextDouble:NextDbl ...) - random generator
  % ops(crossover:CrossFn#Cfreq mutation:MutateFn#Mfreq) - genetic operators configuration
  %
  fun {NextFn MatingFn rng(nextDouble:NextDbl ...) ops(crossover:CrossFn#Cproba mutation:MutateFn#Mproba)}
    fun {$ Pop}
      local
        fun {Identity X} X end
        % Return Fn with the given probability, else returns identity
        fun {WithProba P Fn}
          case {NextDbl} of 
            X andthen X =< P then Fn 
            else Identity
          end
        end
        % Mating pool computation using MatingFn (Pop -> Pop)
        Mp = {MatingFn Pop}
        % Computing Mutated individuals
        Mutated = {List.map Mp {WithProba Mproba fun {$ Xs} {MutateFn Xs} end}}
        % Computing crossed individuals
        Crossed = {List.map {Utils.groupByPair Mutated} {WithProba Cproba fun {$ Xs#Ys} {CrossFn Xs Ys} end}}
      in
        {Utils.flatten {List.map Crossed Utils.pairToList}}
      end
    end
  end
  
  %
  % Mating pool - select individuals for reproduction using the provided selector
  % The same individual can be selected multiple times
  % Pop - Population
  % FitnessFn - Function (Individual -> Float) to compute the individual fitness
  % Select - Selector (like tournament selector) that will select from a Population of Fitness#Individual
  %
  fun {MatingPool Pop FitnessFn Select}
    local
      fun {Snd _#X} X end
      FitPop = {List.map Pop fun {$ I} {FitnessFn I}#I end}
    in
      {List.map FitPop fun {$ _} {Snd {Select FitPop}} end}
    end
  end
  
  % Returns the individual with the highest fitness
  fun {BestBy Pop FitnessFn}
    local fun {Head X|_} X end in
    {List.foldL Pop 
      fun {$ F1#I1 I2} 
        local F2 = {FitnessFn I2} 
        in if F2 > F1 then F2#I2 else F1#I1 end end 
      end
      {FitnessFn {Head Pop}} # {Head Pop}
    } end
  end
  
end
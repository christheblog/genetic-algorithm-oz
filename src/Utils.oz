functor
export
	flatten:		Flatten
	group:			Group
	groupByPair:	GroupByPair
	maximum:		Maximum
	pairToList:		PairToList
	toString:		ToString
	listToString:	ListToString
define   
	
	fun {Group L N}
		fun {Loop Xs Acc}
			case Xs of nil then Acc
			else {Loop {List.drop Xs N} ({List.take Xs N}|Acc)} end
		end in
			{Reverse {Loop L nil}}
	end

	% Assuming an even length
	fun {GroupByPair Xs}
		{Map {Group Xs 2}  fun {$ X|Y|_} X # Y end }
	end
	
	fun {Maximum X|Xs}
     {FoldL Xs Value.max X}
    end
    
    fun {PairToList X#Y} [X Y] end
    
    % Std lib List.flatten seems to flatten an indefinite level of lists
    % We need a Flatten operating on one level only
    fun {Flatten Xs}
    	case Xs
    		of nil then nil
    		[] A|As then {List.append A {Flatten As}}
    	end
    end
    
    
    % Debugging utils
    
    fun {ToString X} {Value.toVirtualString X 50 50} end
    
    fun {ListToString Xs} 
    	case Xs 
	    	of nil then "" 
	    	[] X|Xs then {ToString X} # ", " # {ListToString Xs}
    	end
    end

end
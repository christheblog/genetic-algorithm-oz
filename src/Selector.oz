functor
export
	tournament:	Tournament
define   

	% Tournament selector
	fun {Tournament rng(nextIndex:NextIndex ...)}
		fun {Select FitPop}
			local
				Len = {List.length FitPop} 
				F1 # I1 = {List.nth FitPop {NextIndex Len}}
				F2 # I2 = {List.nth FitPop {NextIndex Len}}
			in					 
				if F1 > F2 then F1 # I1 else F2 # I2 end
			end
		end	in
			Select
	end

end
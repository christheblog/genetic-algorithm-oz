functor
import
  System
  Utils
export
  runTest:RunTest
  assert:Assert
  assertTrue:AssertTrue   
  assertFalse:AssertFalse
define
  
  proc {RunTest Name TestFn Res}
    {System.showInfo ("Running test" # Name)}
    {TestFn _}
    {System.showInfo (Name # " finished.")}
    Res=true
  end
  
  proc {Assert Expected Actual Res}
    if Expected \= Actual 
    then raise error("Error : expected=" # {Utils.toString Expected} # ", Actual=" # {Utils.toString Actual}) end
    else Res = true end
  end
  
  proc {AssertTrue Value Res}
    if Value==true
    then raise error("Error : expected=True, Actual=" # {Utils.toString Value}) end 
    else Res=true end
  end

  fun {AssertFalse Value Res}
    if Value==false 
    then raise error("Error : expected=False, Actual=" # {Utils.toString Value}) end
    else Res=true end
  end

end

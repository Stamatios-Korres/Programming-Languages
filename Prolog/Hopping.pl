read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).

read_input(File,Stairs,Steps,Broken,StepsArray,BrokenArray):-
	open(File,read,Stream),
	read_line(Stream,[Stairs,Steps,Broken]),
	(
	Broken>0->
	read_line(Stream,StepsArray),
	read_line(Stream,BrokenArray);
	Broken = 0 -> 
		read_line(Stream,StepsArray),
		BrokenArray = []
	).

/*createArray(Steps,BrokenArray,MinStep,Index,Result)*/

createArray(0,_,_,_,[]):-!.									   /* End of train destination */
createArray(Steps,[],MinStep,Index,[First|Rest]):- 				 /* No Broken Steps*/
	(Index =\=1 ->
		First = -1,
		NewSteps is Steps -1,
		Newindex is Index +1,
		createArray(NewSteps,[],MinStep,Newindex,Rest),!;	
	Index =:= 1 ->
		First = 1,
		NewSteps is Steps -1,
		Newindex is Index +1,
		createArray(NewSteps,[],MinStep,Newindex,Rest),!	
	).			  /*No Broken Steps Left*/			
createArray(Steps,BrokenArray,MinStep,Index,[1|Rest]):-		   	/* First */
	(Index =:= 1,\+ member(Index,BrokenArray) ->
		NewSteps is Steps-1,
		createArray(NewSteps,BrokenArray,MinStep,2,Rest),!;
	IsFirstNest is 1 + MinStep,IsFirstNest =:= Index,\+member(Index,BrokenArray) ->  /* FirstMin Step */
		NewSteps is Steps-1,
		\+member(1,BrokenArray),
		Newindex is Index +1,
		createArray(NewSteps,BrokenArray,MinStep,Newindex,Rest),!
	).
createArray(Steps,BrokenArray,MinStep,Index,[0|Rest]):-			 /* Broken Step */
		member(Index,BrokenArray),
		select(Index,BrokenArray,NewBrokenArray),
		NewSteps is Steps-1,
		Newindex is Index +1,
		createArray(NewSteps,NewBrokenArray,MinStep,Newindex,Rest),!.		
createArray(Steps,BrokenArray,MinStep,Index,[-1|Rest]):-         /* Ok Step*/  
	\+member(Index,BrokenArray),
	NewSteps is Steps-1,
	Newindex is Index +1,
	createArray(NewSteps,BrokenArray,MinStep,Newindex,Rest),!.

/*Create an associative list based on a array */

createAssoc([X],R,Index,Newassoc):-put_assoc(Index,R,X,Newassoc),!.
createAssoc([X|Y],AssoList,Index,ReturnAssoc):-
		put_assoc(Index,AssoList,X,AssoList2),
		Newindex is Index +1,
		createAssoc(Y,AssoList2,Newindex,ReturnAssoc),!.

/* Returs the final Sum */
/*
# countWays([],Assoc,_,_,Sum):-max_assoc(Assoc,_,Sum). 				/* countWays(List,Assoc,BrokenArray,Index,Result)*/

# countWays([Head|Tail],AS,[FirstStep|RestSteps],Index,Sum):-
# 	( Head =:= 0 ->
# 		Newindex is Index +1,
# 		countWays(Tail,AS,[FirstStep|RestSteps],Newindex,Sum),!;
# 	Head =:= 1,Index =:= 1 ->
# 		Newindex is Index +1,
# 		countWays(Tail,AS,[FirstStep|RestSteps],Newindex,Sum),!;
# 	Head =\= 0->
# 	 	countStep(Index,[FirstStep|RestSteps],AS,PartialSum1),
# 	 	PartialSum is mod(PartialSum1,1000000009),
# 	 	put_assoc(Index,AS,PartialSum,AS2),
# 	 	Newindex is Index +1,
# 	 	countWays(Tail,AS2,[FirstStep|RestSteps],Newindex,Sum),!
# 	).
*/

countWays(AS,_,Index,Sum,Total) :- Total < Index,max_assoc(AS,_,Sum),!.
countWays(AS,StepsArray,Index,Sum,Total):-
(get_assoc(Index,AS,V),V =:=0 ->
	NewIndex is Index + 1,
	countWays(AS,StepsArray,NewIndex,Sum,Total),!;
get_assoc(Index,AS,V),V =\= 0,Index =\=1 ->
	countStep(Index,StepsArray,AS,PartialSum1),
	PartialSum is mod(PartialSum1,1000000009),
	put_assoc(Index,AS,PartialSum,AS2),
	Newindex is Index +1,
	countWays(AS2,StepsArray,Newindex,Sum,Total),!;
Index =:=1 ->
	Newindex is Index +1,
	countWays(AS,StepsArray,Newindex,Sum,Total),!
).





/*For a given Index find all possible ways */

countStep(_,[],_,0):-!.
countStep(Index,[X|Y],AL2,Sum):-
	(IsOutOfBOunds is Index - X,IsOutOfBOunds > 0 ->
		get_assoc(IsOutOfBOunds,AL2,V),
		countStep(Index,Y,AL2,Sum1),
		Sum is Sum1+V;
	IsOutOfBOunds is Index - X,IsOutOfBOunds =<0 ->
		countStep(Index,Y,AL2,Sum),!
	).

/* Function to be delivered */

hopping(File,Result):-
	empty_assoc(A),
	read_input(File,Stairs,_,_,[Step1|RestStep],Broken),
	createArray(Stairs,Broken,Step1,1,Array),
	createAssoc(Array,A,1,Assoc),
	countWays(Assoc,[Step1|RestStep],1,Result,Stairs).
	

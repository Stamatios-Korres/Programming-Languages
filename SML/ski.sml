fun reverse xs =
	let fun rev (x::y,z) = rev (y,x::z)
 		|rev ([],z) = z
	in
 		rev(xs,nil)
 end 

fun create_descending ((height:IntInf.int,index)::tl) =
	let 
	fun choose ((x:IntInf.int,y)::body,min,result) = if(x < min) then choose (	body,x,(		x,y)::result) 
											  else 			   choose (body,min,result)
		|choose ([],_,result) = result
	in 
		choose (tl,height,[(height,index)])
	end	

fun read file = 
	let 
		val inStream = TextIO.openIn file
		val words = String.tokens Char.isSpace o TextIO.inputAll 
	in 
		words inStream
	end

fun convert (head::tail)  =
	let 
		fun make ([],_,result) = result
		|make ((x::tail),index,result)  = 
			let 
				val SOME height = IntInf.fromString x
			in 
				make(tail,index+1, (height,index)::result)
			end
	in 
		make (tail,0,[])
end			

fun create_upsending ((height:IntInf.int,index:int)::tl) =
	let 
		fun choose ((x:IntInf.int,y)::body,max,result) = if(x > max) then choose(body,x,(x,y)::result) 
														 else choose (body,max,result)
		|choose ([],_,result) = result
	in 
		choose (tl,height,[(height,index)])
end	

(* Returns (1)Max-Distance (2) position in which the loop stoped (3) the remaining of the list *)

fun  pos_dis(max:int,(element:IntInf.int,index:int),[(last_height,last_index:int)],position,_) = 
		if(element < last_height) then 
				if(last_index-index > max) then 
					(last_index-index,position,[]) 
				else
					(max,position,[])
		else 
			(max,position,[])
|pos_dis(max:int,(element:IntInf.int,index:int),((height:IntInf.int,pos:int)::tail),(position:int ),
(prev_heigh:IntInf.int,prev_index:int)) = 
	if	element > height andalso prev_heigh > element then  
			if(max < prev_index-index ) then 
				(prev_index-index,position,(height,pos)::tail )
			else
				(max,position, (height,pos)::tail )
	else 
		pos_dis(max,(element,index) ,tail, position+1, (height:IntInf.int,pos:int))



(*Here is where data is being proccesed *)

fun loop (_,max_distance,[],_) = max_distance 
|loop (_,max_distance,rest,[]) = max_distance 
|loop(position,max_distance,((exa1,exam2)::rest),(test1,test2)::remaining_list) =
	let 
		fun  pos_dis(max:int,(element:IntInf.int,index:int),[(last_height,last_index:int)],position,(prev_height,previous_index),(head_height,head_index)) = 
			if(element < last_height) then 
					if(last_index-index > max) then 
						(last_index-index,position,[]) 
					else
						(max,position,[])
			else 
				if(prev_height > element) then 
						if(max < previous_index - index ) then 
									(previous_index - index,position,[])
						else
									(max,position,[])
				else 
					(max,position,[])
			|pos_dis(max:int,(element:IntInf.int,index:int),(height:IntInf.int,pos:int)::tail,(position:int ),(prev_heigh:IntInf.int,prev_index:int),(head_height,head_index)) = 
				if element >= head_height  	then 
					(0,0,(height:IntInf.int,pos:int)::tail)					
				else 
					if	element > height andalso prev_heigh > element then  
							if(max < prev_index-index ) then 
								(prev_index-index,position,(height,pos)::tail )
							else
								(max,position, (height,pos)::tail )
					else 
						pos_dis(max,(element,index) ,tail, position+1, (height:IntInf.int,pos:int),(head_height,head_index))
		(*Check for off-cases*)		
		val temp_result = pos_dis(max_distance,(exa1,exam2),remaining_list,position,(0:IntInf.int,0),(test1,test2))
		fun  decide x = if #3x = [] andalso max_distance = #1x then 
					(max_distance,0,(test1,test2)::remaining_list)
				else
					x
		val temp = decide temp_result
	in
		loop (#2temp,#1temp,rest,#3temp) 
end	 



fun skitrip file = 
	let 
		val timos = convert(read file)
		val up = create_upsending timos
		val down = reverse(create_descending(reverse timos ))
	in 
	loop(0,0,down,up)
end




fun read_file file = 
	let
		(*Read Integer in first line*)
		fun next_int input =
	    	Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
		fun intInf_from_stream stream =
  			Option.valOf (TextIO.scanStream (IntInf.scan StringCvt.DEC) stream)
		val fstream = TextIO.openIn file
		val	N = next_int fstream
		fun scanner(0,result,_) = result 
		|scanner(acc,result,index) =
            let
                val d = intInf_from_stream fstream
                val new = index +1
        in
    	    scanner(acc-1,(d,new)::result,new)
		end             
    in
    	scanner(N,[],~1)         
    end	


fun skitrip file = 
let 
	val timos = read_file file
	val up = create_upsending timos
	val down = reverse(create_descending(reverse timos ))
in 
	loop(0,0,down,up)
end

(*
	val timos = read_file "text6.txt"
	val up = create_upsending timos
	val down = reverse(create_descending(reverse timos ))
	val result = loop(0,0,down,up)
	skitrip "text6.txt"skitrip "text6.txt"
*)


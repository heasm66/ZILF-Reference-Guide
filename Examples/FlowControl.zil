"Examples/Tests - Flow Control"

<VERSION XZIP>
<CONSTANT RELEASEID 1>

<CONSTANT FUNNY-RETURN? T>          

;"-----------------------------------------
   DO-FUNNY-RETURN?
   - Handles how <RETURN value> should behave
        - T  = Exit ROUTINE
        - <> = Exit BLOCK
    - Version 3-4: Default <> (FALSE)
      Version 5- : Default T (TRUE)
  -----------------------------------------"
<SETG DO-FUNNY-RETURN? ,FUNNY-RETURN?>

<GLOBAL X 0>

<ROUTINE GO ()
    <TELL "Examples/Tests - Flow Control - ">
    <VERSION? 
        (ZIP <TELL "ZIP">)
        (EZIP <TELL "EZIP">)
        (ELSE <TELL "XZIP+">)
    >   
    <TELL " - DO-FUNNY-RETURN? = ">
    <COND (,FUNNY-RETURN? <TELL "TRUE" CR CR>)(ELSE TELL "FALSE" CR CR)>
    <TEST-ROUTINE-1>
    <TEST-ROUTINE-2>
    <TEST-BIND-1>
    <TEST-BIND-2>
    <TEST-BIND-3>
    <TEST-PROG-1>
    <TEST-PROG-2>
    <TEST-PROG-3>
    <TEST-REPEAT-1>
    <TEST-REPEAT-2>
    <TEST-DO-1>
    <TEST-DO-2>
    <TEST-PASCAL-STYLE>
    <TEST-C-STYLE>
    <TEST-MIXED-STYLE>
    <TEST-MAP-CONTENTS>
    <TEST-MAP-DIRECTIONS>
>

;"-----------------------------------------
   ROUTINE
  -----------------------------------------"

;"AGAIN in ROUTINE will reinitialize atoms"  
<ROUTINE TEST-ROUTINE-1 ("AUX" (X 0))
    <TELL "ROUTINE: AGAIN in ROUTINE will reinitialize atoms" CR>
    <TELL "START: ">
    <SET X <+ .X 1>>
    <SETG X <+ ,X 1>>
    <TELL N .X " ">
    <COND (<=? ,X 3> <SETG X 0> <TELL " RETURN EXIT ROUTINE" CR CR> <RETURN>)>
    <AGAIN>             ;"Will redo ROUTINE and reinitialize X"
>

;"AGAIN in ROUTINE will keep atom if no init-value exists"  
<ROUTINE TEST-ROUTINE-2 ("AUX" X)
    <TELL "ROUTINE: AGAIN in ROUTINE will keep atom if no init-value exists" CR>
    <TELL "START: ">
    <SET X <+ .X 1>>
    <SETG X <+ ,X 1>>
    <TELL N .X " ">
    <COND (<=? ,X 3> <SETG X 0> <TELL " RETURN EXIT ROUTINE" CR CR> <RETURN>)>
    <AGAIN>             ;"Will redo ROUTINE and leave X"
>

;"-----------------------------------------
   BIND
   - Defines block of code
   - Own set of atoms
   - No default ACTIVATION
  -----------------------------------------"

;"Block have own set of atoms"  
<ROUTINE TEST-BIND-1 ("AUX" X)
    <TELL "BIND: Block have own set of atoms" CR>
    <SET X 2>
    <TELL "START: ">
    <BIND (X)
        <SET X 1>
        <TELL N .X " ">    ;"Inner X"
    >
    <TELL N .X>            ;"Outer X"
    <TELL " END" CR CR>
>

;"AGAIN, Bare RETURN without ACTIVATION"
<ROUTINE TEST-BIND-2 ()
    <TELL "BIND: AGAIN, Bare RETURN without ACTIVATION" CR>
    <TELL "START: ">
    <BIND (X)                                    ;"X is not reinitialized between iterations. No ACTIVATION created."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3>
            <TELL "RETURN EXIT ROUTINE" CR CR> 
            <RETURN>)>                           ;"RETURN without ACTIVATION will exit ROUTINE"
        <AGAIN>                                  ;"AGAIN without ACTIVATION will redo ROUTINE"
    >
    <TELL "RETURN EXIT BLOCK" CR CR>             ;"Will never be reached"
>

;"AGAIN, RETURN with value, ACTIVATION"
<ROUTINE TEST-BIND-3 ()
    <TELL "BIND: AGAIN, RETURN with value, ACTIVATION" CR>
    <TELL "START: ">
    <BIND ACT ((X 0))                           ;"X is not reinitialized between iterations. Manual ACTIVATION."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3> 
            <COND (,FUNNY-RETURN? <TELL "RETURN EXIT ROUTINE" CR CR>)> 
            <RETURN T .ACT>)>                   ;"RETURN with ACTIVATION will exit ROUTINE (FUNNY-RETURN = TRUE)"
        <AGAIN .ACT>                            ;"AGAIN with ACTIVATION will redo BLOCK"
    >
    <TELL "RETURN EXIT BLOCK" CR CR>
>

;"-----------------------------------------
   PROG
   - Defines block of code
   - Own set of atoms
   - Default ACTIVATION
  -----------------------------------------"

;"Block have own set of atoms"  
<ROUTINE TEST-PROG-1 ("AUX" X)
    <TELL "PROG: Block have own set of atoms" CR>
    <SET X 2>
    <TELL "START: ">
    <PROG (X)
        <SET X 1>
        <TELL N .X " ">    ;"Inner X"
    >
    <TELL N .X>            ;"Outer X"
    <TELL " END" CR CR>
>

;"AGAIN, Bare RETURN without ACTIVATION"
<ROUTINE TEST-PROG-2 ()
    <TELL "PROG: AGAIN, Bare RETURN without ACTIVATION" CR>
    <TELL "START: ">
    <PROG (X)                        ;"X is not reinitialized between iterations. Default ACTIVATION created."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3> <RETURN>)>  ;"Bare RETURN without ACTIVATION will exit BLOCK (FUNNY-RETURN = TRUE)"
        <AGAIN>                      ;"AGAIN without ACTIVATION will redo BLOCK"
    >
    <TELL "RETURN EXIT BLOCK" CR CR>
>

;"AGAIN, RETURN with value but without ACTIVATION"
<ROUTINE TEST-PROG-3 ()
    <TELL "PROG: AGAIN, RETURN value but without ACTIVATION" CR>
    <TELL "START: ">
    <PROG ((X 0))                    ;"X is not reinitialized between iterations Default ACTIVATION created."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3> 
            <COND (,FUNNY-RETURN? <TELL "RETURN EXIT ROUTINE" CR CR>)>
            <RETURN T>)>             ;"RETURN with value but without ACTIVATION will exit ROUTINE (FUNNY-RETURN = TRUE)"
        <AGAIN>                      ;"AGAIN without ACTIVATION will redo BLOCK"
    >
    <TELL "RETURN EXIT BLOCK" CR CR>
>

;"-----------------------------------------
   REPEAT
   - Defines block of code
   - Own set of atoms
   - Default ACTIVATION
   - Automatic AGAIN
  -----------------------------------------"

;"Bare RETURN without ACTIVATION"
<ROUTINE TEST-REPEAT-1 ()
    <TELL "REPEAT: Bare RETURN without ACTIVATION" CR>
    <TELL "START: ">
    <REPEAT ((X 0))                  ;"X is not reinitialized between iterations. Default ACTIVATION created."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3> <RETURN>)>  ;"Bare RETURN without ACTIVATION will exit BLOCK (FUNNY-RETURN = TRUE)"
    >                                ;"Automatic AGAIN at end of block"
    <TELL "RETURN EXIT BLOCK" CR CR>
>

;"RETURN with value but without ACTIVATION"
<ROUTINE TEST-REPEAT-2 ()
    <TELL "REPEAT: RETURN value but without ACTIVATION" CR>
    <TELL "START: ">
    <REPEAT ((X 0))                    ;"X is not reinitialized between iterations Default ACTIVATION created."
        <SET X <+ .X 1>>
        <TELL N .X " ">
        <COND (<=? .X 3> 
            <COND (,FUNNY-RETURN? <TELL "RETURN EXIT ROUTINE" CR CR>)>
            <RETURN T>)>             ;"RETURN with value but without ACTIVATION will exit ROUTINE (FUNNY-RETURN = TRUE)"
    >                                ;"Automatic AGAIN at end of block"
    <TELL "RETURN EXIT BLOCK" CR CR>
>

;"-----------------------------------------
   DO
   - Defines block of code
   - Own set of atoms
   - Default ACTIVATION (no manual possibl
   - Automatic AGAIN until exit-condition reached
  -----------------------------------------"

<ROUTINE TEST-DO-1 ()
    <TELL "DO: Bare RETURN and AGAIN with manually updating index" CR>
    <TELL "START: ">
    <DO (I 0 10)
        <COND (<=? .I 1 3 5 7 9>
             <SET I <+ .I 1>> <AGAIN>)> ;"Premature AGAIN will need manual updated index"
        <TELL N .I " ">
        <COND (<=? .I 10> 
            <RETURN>)>                  ;"Bare RETURN will exit BLOCK (FUNNY-RETURN = TRUE)"
    >                                   ;"Automatic AGAIN and updating index"
    <TELL "RETURN EXIT BLOCK" CR CR>
>

<ROUTINE TEST-DO-2 ()
    <TELL "DO: RETURN with value and AGAIN with manually updating index" CR>
    <TELL "START: ">
    <DO (I 0 10)
        <COND (<=? .I 1 3 5 7 9>
             <SET I <+ .I 1>> <AGAIN>)> ;"Premature AGAIN will need manual updated index"
        <TELL N .I " ">
        <COND (<=? .I 10> 
            <COND (,FUNNY-RETURN? <TELL "RETURN EXIT ROUTINE" CR CR>)>
            <RETURN T>)>                ;"RETURN with value will exit ROUTINE (FUNNY-RETURN = TRUE)"
    >                                   ;"Automatic AGAIN and updating index"
    <TELL "RETURN EXIT BLOCK" CR CR>    ;"Will never be reached"
>

;"-----------------------------------------
   DO
   - Quirks (Jesse McGrew)
  -----------------------------------------"

<CONSTANT C-ONE 1>
<CONSTANT C-TEN 10>

<ROUTINE TEST-PASCAL-STYLE ("AUX" (ONE 1) (TEN 10))
    <TELL "== Pascal style ==" CR>

    <TELL "Counting from 1 to 10...">
    ;"1 2 3 4 5 6 7 8 9 10"
    <DO (I 1 10)
        (END <CRLF>)
        <TELL " " N .I>>
  
    <TELL "Counting from 1 to 10 with step 2...">
    ;"1 3 5 7 9"
    <DO (I 1 10 2)
        (END <CRLF>)
        <TELL " " N .I>>
    
    <TELL "Counting from 10 to 1...">
    ;"10 9 8 7 6 5 4 3 2 1"
    <DO (I 10 1)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from 10 to 1 with step -2...">
    ;"10 8 6 4 2"
    <DO (I 10 1 -2)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from .ONE to .TEN...">
    ;"1 2 3 4 5 6 7 8 9 10"
    <DO (I .ONE .TEN)
        (END <CRLF>)
        <TELL " " N .I>>
    
    <TELL "Counting from .TEN to .ONE...">
    ;"10"
    ;"Since the loop bounds aren't FIXes (numeric 
	literals), ZILF doesn't know the loop is meant 
 	to count down, and it compiles a loop that counts 
	up and exits after the first iteration. A DO loop 
	whose condition is a constant or simple FORM always 
	runs at least once."
    <DO (I .TEN .ONE)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from 10 to .ONE...">
    ;"10"
    ;"See above."
    <DO (I 10 .ONE)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from .TEN to 1...">
    ;"10"
    ;"See above."
    <DO (I .TEN 1)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from .TEN to .ONE with step -1...">
    ;"10 9 8 7 6 5 4 3 2 1"
    <DO (I .TEN .ONE -1)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from ,C-TEN to ,C-ONE...">
    ;"10"
    ;"Even defining the loop bounds as CONSTANTs won't 
	tell ZILF that the loop needs to run backwards."
    <DO (I ,C-TEN ,C-ONE)
        (END <CRLF>)
        <TELL " " N .I>>

    <TELL "Counting from %,C-TEN to %,C-ONE...">
    ;"10 9 8 7 5 4 3 2 1"
    ;"The % forces ,C-TEN to be evaluated at read time, 
	so the loop bounds are specified as FIXes, allowing 
	ZILF to determine that the loop runs backwards."
    <DO (I %,C-TEN %,C-ONE)
        (END <CRLF>)
        <TELL " " N .I>>

    <CRLF>>

<OBJECT DESK
    (DESC "desk")>

<OBJECT MONITOR
    (DESC "monitor")
    (LOC DESK)>

<OBJECT KEYBOARD
    (DESC "keyboard")
    (LOC DESK)>

<OBJECT MOUSE
    (DESC "mouse")
    (LOC DESK)>

<ROUTINE TEST-C-STYLE ()
    <TELL "== C style ==" CR>

    <TELL "Counting from 10 down to 1...">
    ;"10 9 8 7 6 5 4 3 2 1"
    <DO (I 10 <L? .I 1> <- .I 1>)
        (END <CRLF>)
        <TELL " " N .I>>
    
    <TELL "Counting from 10 up (!) to 1...">
    ;""
    ;"Nothing is printed, because the exit condition 
	is initially true. A DO loop whose condition is 
	a complex FORM can exit before the first iteration."
    <DO (I 10 <G? .I 1> <+ .I 1>)
        (END <CRLF>)
        <TELL " " N .I>>
    
    <TELL "On the desk:">
    ;"monitor mouse keyboard"
    <DO (I <FIRST? ,DESK> <NOT .I> <NEXT? .I>)
        (END <CRLF>)
        <TELL " " D .I>>
    
    <CRLF>>

<ROUTINE TEST-MIXED-STYLE ()
    <TELL "== Mixed ==" CR>
    
    <TELL "Powers of 2 up to 1000:">
    ;"1 2 4 8 16 32 64 128 256 512"
    <DO (I 1 1000 <* .I 2>)
        (END <CRLF>)
        <TELL " " N .I>>
    
    <CRLF>>

;"-----------------------------------------
   MAP-CONTENTS
   - 
  -----------------------------------------"
<OBJECT SURVIVAL-KIT 
    (DESC "adventure survival kit") (WEIGHT 10)>
<OBJECT SWORD 
    (IN SURVIVAL-KIT) (DESC "sword") (WEIGHT 10)>
<OBJECT LAMP 
    (IN SURVIVAL-KIT) (DESC "brass lamp") (WEIGHT 5)>
<OBJECT SPOON 
    (IN SURVIVAL-KIT) (DESC "chrome spoon") (WEIGHT 2)>

<ROUTINE TEST-MAP-CONTENTS ()
    <TELL "Your " D ,SURVIVAL-KIT " contains:" CR>
    <MAP-CONTENTS (F ,SURVIVAL-KIT)
        <TELL "    a " D .F CR>
    >
    
    <TELL "Your " D ,SURVIVAL-KIT " contains:" CR>
    <MAP-CONTENTS (F N ,SURVIVAL-KIT)
        <TELL "    a " D .F >
        <COND (.N <TELL " (next item is the " D .N ")">)>
        <TELL CR>
    >
    
    <BIND ((W 0))
        <SET W <GETP ,SURVIVAL-KIT ,P?WEIGHT>>
        <MAP-CONTENTS (F ,SURVIVAL-KIT)
                      (END <TELL "Total weight is = " N .W CR CR>)
            <SET W <+ .W <GETP .F ,P?WEIGHT>>>
        >
    >
>

;"-----------------------------------------
   MAP-DIRECTIONS
   - 
  -----------------------------------------"

<DIRECTIONS NORTH SOUTH EAST WEST>
<OBJECT CENTER (DESC "center room")  
    (NORTH TO N-ROOM) 
    (WEST TO W-ROOM)>
<OBJECT N-ROOM (DESC "north room")>
<OBJECT W-ROOM (DESC "west room")>

<ROUTINE TEST-MAP-DIRECTIONS ()
    <TELL "You're in the " D ,CENTER>
    <TELL CR "Obvious exits:" CR>
    <MAP-DIRECTIONS (D P ,CENTER)
        (END <TELL "Room description done." CR>)
        <COND (<EQUAL? .D ,P?NORTH> <TELL "    North">)
              (<EQUAL? .D ,P?SOUTH> <TELL "    South">)
              (<EQUAL? .D ,P?EAST> <TELL "    East">)
              (<EQUAL? .D ,P?WEST> <TELL "    West">)
        >
        <VERSION?
            (ZIP <TELL " to the " D <GETB .P ,REXIT> CR>)
            (ELSE <TELL " to the " D <GET .P ,REXIT> CR>)
        >
    >
>    

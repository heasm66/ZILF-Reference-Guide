<VERSION XZIP>
<CONSTANT RELEASEID 1>

<GLOBAL READBUF <ITABLE BYTE 63>>
<GLOBAL PARSEBUF <ITABLE BYTE 28>>

<OBJECT PASSWORD (SYNONYM PASSWORD)>

<ROUTINE GO () 
    <CRLF>
    <TEST-READ>>

<ROUTINE TEST-READ ()
	<PUTB ,READBUF 0 60>    ;"Max length of READBUF"
	<PUTB ,PARSEBUF 0 6>    ;"Max # words that will be parsed"
    <TELL CR CR "You'll NEVER guess the password!!" CR>
    <REPEAT (W)
        <TELL "Enter password: ">
		<DO (I 1 63) <PUTB ,READBUF .I 0>>  ;"Clear READBUF"
		<DO (I 1 28) <PUTB ,PARSEBUF .I 0>> ;"Clear PARSEBUF"
        <READ ,READBUF ,PARSEBUF>
        <SET W <AND <GETB ,PARSEBUF 1> <GET ,PARSEBUF 1>>>
        <COND (<=? .W W?PASSWORD> <TELL "Darn!!" CR> <RETURN>)>
        <TELL "Wrong password!" CR>
    >
>

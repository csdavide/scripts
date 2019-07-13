Set wshShell = WScript.CreateObject("WScript.Shell")
Set args = WScript.Arguments

if args.Count() = 0 Then
 setenv false
else
 setenv true
end if

Sub setenv(debugOn)
	Set systemEnv = wshShell.Environment("System")
	Dim systemPath : systemPath = systemEnv.Item("PATH")
	'WScript.echo "systemPath= " & systemPath

	Set userEnv = WshShell.Environment("User")
	Dim userPath : userPath = userEnv.Item("PATH")
	'WScript.echo "userPath= " & userPath

	Dim oFS : Set oFS = CreateObject("Scripting.FileSystemObject")
	Dim dicProps : Set dicProps = CreateObject("Scripting.Dictionary")
	Dim oTS : Set oTS = oFS.OpenTextFile("D:\System\shell\scripts\source\path")
	
	Do Until oTS.AtEndOfStream
		Dim sLine : sLine = Trim(oTS.ReadLine)
		if "" <> sLine Then
			if "#" = Left( sLine, 1 ) Then
				echo debugOn, "commented line", sLine
			Else
				if "" = sLine Then
					echo debugOn, "empty line", sLine
				Else
					Dim aParts : aParts = Split( sLine, "=" )
					if 1 <> UBound( aParts ) Then
						echo debugOn, "bad line", sLine
					Else
						dicProps( Trim( aParts( 0 ) ) ) = Trim( aParts( 1 ) )
						echo debugOn, "good line", sLine
					end if
				end if
			end if
		end if
	Loop
	oTS.Close

	Dim sKey
	Dim sValue
	Dim localPath	
	
	For Each sKey In dicProps
	  sValue = dicProps(sKey)
			
   If InStr(1, sKey, "U_") = 1 Then

				If InStr(1, sValue, "@") = 1 Then
				 sValue = dicProps(Mid(sValue,2))
				end if
				
				userEnv(Mid(sKey,3)) = sValue
   end if
			
			localPath = localPath & ";""" & sValue & """"
	Next
	
	echo debugOn, "localPath", localPath
	userEnv("XENV_MPATH") = systemPath & ";" & userPath & ";" & Mid(localPath,2)
End Sub

Sub echo(debugOn, p1, p2)
 if debugOn Then
  WScript.Echo p1, p2
	end if
End Sub

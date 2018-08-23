#include "FastFind.au3"
#include <BlockInputEx.au3>

global const $DEBUG_DEFAULT = 0
;~ global const $DEBUG_GRAPHIC = $DEBUG_DEFAULT + 4
FFSetDebugMode(0) 	 ; Enable advanced (graphical) debug mode, so you will have traces + graphical feedback
Opt('SendKeyDownDelay', 100)

Local $tick = 0
local $exit = 0
While 1
  Local $timer = TimerInit ()
   FFResetExcludedAreas()
   FFResetColors()
;~    If WinActive("[CLASS:FoxGame]") Then

	  Local $aClientSize = WinGetClientSize("[CLASS:FoxGame]")
;~ 	  Local $aClientSize = WinGetClientSize("[CLASS:QWidget]")
;~ 	  ConsoleWrite("X=" & $aClientSize[0] & " Y=" & $aClientSize[1] & @CRLF)
	  Local $aClientSizeStartX = 0
	  Local $aClientSizeStartY = 0
	  Local $aClientSizeEndX = $aClientSize[0]
	  Local $aClientSizeEndY = $aClientSize[1]
	  FFSnapShot($aClientSizeStartX,$aClientSizeStartY,$aClientSizeEndX,$aClientSizeEndY,0)

	  FFResetColors() ; Reset of the list of colors
;~ 	  FFAddColor(0x00FF0000)
	  FFAddColor(0x00D40606)
	  FFAddColor(0x00E00000)

	  FFResetExcludedAreas()
;~ 	  FFAddExcludedArea(0, 0, $aClientSizeEndX*0.35, $aClientSizeEndY);on la partie gauche de l'écran pour éviter de detecter notre vie qui devient rouge
	  local $searchRed = FFNearestSpot(100, 50, $aClientSizeEndX/2, $aClientSizeEndY/2, -1, 4, False, 0, 0, 0, 0, 0)
	  If (IsArray($searchRed)) Then ;If we found a red arrow
		 $tick = $tick+1
		 ConsoleWrite("------------------------" & @CRLF)
		 ConsoleWrite("tick" & $tick & @CRLF)
		 ConsoleWrite("$searchRed : " & $searchRed[0] & " " & $searchRed[1] & @CRLF)
		 FFDuplicateSnapShot(0, 1)
		 FFKeepColor(-1, 15, false, 0, 0, 0, 0, 0)
		 FFResetExcludedAreas()
		 FFAddExcludedArea(0, 0, $searchRed[0]-125, $aClientSizeEndY);on cache la gauche
		 FFAddExcludedArea(0, 0, $aClientSizeEndX, $searchRed[1]-125);on cache le haut
		 FFAddExcludedArea($searchRed[0]+125, 0, $aClientSizeEndX, $aClientSizeEndY);on cache la droite
		 FFAddExcludedArea(0, $searchRed[1]+125, $aClientSizeEndX, $aClientSizeEndY);on cache le bas

;~ 		 $topy=$searchRed[1]
;~ 		 $bottomy=$searchRed[1]
;~ 		 $leftx=$searchRed[0]
;~ 		 $rightx=$searchRed[0]
;~ 		 $departx = $searchRed[0]-150
;~ 		 $departy = $searchRed[1]-150

;~ 		 For $xi = 1 To 300 Step 1
;~ 			For $yi = 1 To 300 Step 1
;~ 			   If FFGetPixel($departx+$xi, $departy+$yi, 0) <> 0x00000000 Then
;~ 				  if $yi < $topy Then
;~ 					  $topy = $departy+$yi
;~ 				  EndIf
;~ 				  if $yi > $bottomy Then
;~ 					  $bottomy = $departy+$yi
;~ 				  EndIf
;~ 			   EndIf
;~ 			Next
;~ 		 Next
;~ 		 ConsoleWrite("$topy : " & $topy & " $bottomy : " & $bottomy & @CRLF)

		 local $pixelTop = FFNearestSpot(1, 1, $searchRed[0], $aClientSizeStartY, -1, 15, false, 0, 0, 0, 0, 0)
		 local $pixelBottom = FFNearestSpot(1, 1, $searchRed[0], $aClientSizeEndY, -1, 15, false, 0, 0, 0, 0, 0)
		 local $pixelLeft = FFNearestSpot(1, 1, $aClientSizeStartX, $searchRed[1], -1, 15, false, 0, 0, 0, 0, 0)
		 local $pixelRight = FFNearestSpot(1, 1, $aClientSizeEndX, $searchRed[1], -1, 15, false, 0, 0, 0, 0, 0)

		 If $pixelTop <> 0 Then
			ConsoleWrite("$pixelTop " & $pixelTop[0] &  " " & $pixelTop[1] & @CRLF)
		 EndIf
		 If $pixelBottom <> 0 Then
			ConsoleWrite("$pixelBottom " & $pixelBottom[0] &  " " & $pixelBottom[1] & @CRLF)
		 EndIf
		 If $pixelLeft <> 0 Then
			ConsoleWrite("$pixelLeft " & $pixelLeft[0] &  " " & $pixelLeft[1] & @CRLF)
		 EndIf
		 If $pixelRight <> 0 Then
			ConsoleWrite("$pixelRight " & $pixelRight[0] &  " " & $pixelRight[1] & @CRLF)
		 EndIf

		 Local $topToBottom = $pixelBottom[1] - $pixelTop[1]
		 Local $leftToRight = $pixelRight[0] - $pixelLeft[0]
		 Local $topToBottomDiffX = $pixelTop[0] - $pixelBottom[0]
		 ConsoleWrite("$topToBottom = " & $topToBottom & @CRLF)
		 ConsoleWrite("$leftToRight = " & $leftToRight & @CRLF)
		 ConsoleWrite("$topToBottomDiffX = " & $topToBottomDiffX & @CRLF)

		 ConsoleWrite(TimerDiff($timer) & @CRLF)
;~ 		 $exit = 1

		 If $topToBottom+$leftToRight > 70 And $topToBottom+$leftToRight < 270 And $topToBottom > 24 And $pixelTop[1] > $aClientSizeStartY+210 And $pixelRight[0] < $aClientSizeEndX-250 And $pixelLeft[0] > $aClientSizeStartX+250 Then ;We can consider the red color detected is an arrow and not a glitch
			If $topToBottomDiffX < 20 And $topToBottomDiffX > -20 And $topToBottom > 30 And $leftToRight < 70 Then ;PUSH
;~ 			   _BlockInputEx(1)
;~ 			   FFSaveBMP("PUSH0_" & $tick, false, 0, 0, 0, 0, 0)
;~ 			   FFSaveBMP("PUSH1_" & $tick, false, 0, 0, 0, 0, 1)
			   ConsoleWrite("PUSH" & @CRLF)
			   Send("f")
			   beep(1000,50)
			   Send("f")
			   beep(1000,50)
			   Send("f")
			   beep(1000,50)
			   Send("f")
;~ 			   _BlockInputEx(0)
			elseIf $leftToRight > $topToBottom Then ;Block UP
;~ 			   _BlockInputEx(2)
			   ConsoleWrite("Block UP" & @CRLF)
				  Send("{UP}")
			   beep(1000,50)
;~ 			   FFSaveBMP("UP0_" & $tick, false, 0, 0, 0, 0, 0)
;~ 			   FFSaveBMP("UP1_" & $tick, false, 0, 0, 0, 0, 1)
			ElseIf $pixelTop[0] < $pixelBottom[0] Then ;Block Left
;~ 			   _BlockInputEx(2)
			   ConsoleWrite("Block Left" & @CRLF)
			   Send("{LEFT}")
			   beep(1000,50)
;~ 			   FFSaveBMP("LEFT0_" & $tick, false, 0, 0, 0, 0, 0)
;~ 			   FFSaveBMP("LEFT1_" & $tick, false, 0, 0, 0, 0, 1)
			ElseIf $pixelTop[0] > $pixelBottom[0] Then ;Block Right
;~ 			   _BlockInputEx(2)
			   ConsoleWrite("Block Right" & @CRLF)
			   Send("{RIGHT}")
			   beep(1000,50)
;~ 			   FFSaveBMP("RIGHT0_" & $tick, false, 0, 0, 0, 0, 0)
;~ 			   FFSaveBMP("RIGHT1_" & $tick, false, 0, 0, 0, 0, 1)
			Else ;woot ?
;~ 			   FFSaveBMP("ERROR0_", false, 0, 0, 0, 0, 0)
;~ 			   FFSaveBMP("ERROR1_", false, 0, 0, 0, 0, 1)
			EndIf
;~ 			_BlockInputEx(0)
		 Else ;We don't know why we detect red
;~ 			FFSaveBMP("ERRROR0_" & $tick, false, 0, 0, 0, 0, 0)
;~ 			FFSaveBMP("ERRROR1_" & $tick, false, 0, 0, 0, 0, 1)
		 EndIf
	  EndIf
;~ 	  ConsoleWrite(TimerDiff($timer) & @CRLF)
;~ 	  if $exit = 1 Then
;~ 		 Exit 0
;~ 	  EndIf
;~    EndIf
WEnd
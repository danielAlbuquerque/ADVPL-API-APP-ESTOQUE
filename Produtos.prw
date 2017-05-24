#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "AARRAY.CH"
#INCLUDE "JSON.CH"

WSRESTFUL produtos DESCRIPTION "Retorna os produtos"
	WSMETHOD GET DESCRIPTION "Retorna os produtos" WSSYNTAX "/produtos/"
END WSRESTFUL

WSMETHOD GET WSSERVICE produtos
	Local aResult := Array(#)
	Local nI := 0
	
	dbSelectArea("SB1")
	SB1->(dbGoTop())
	
	While SB1->(!EOF())
		aResult[#cValToChar(nI)] := Array(#)
		aResult[#cValToChar(nI)][#'filial'] := SB1->B1_FILIAL
		aResult[#cValToChar(nI)][#'codigo'] := SB1->B1_COD
		aResult[#cValToChar(nI)][#'descricao'] := SB1->B1_DESC  
		nI++
		SB1->(dbSkip())
	End-While
	
	::SetResponse(ToJson(aResult))
Return .t.
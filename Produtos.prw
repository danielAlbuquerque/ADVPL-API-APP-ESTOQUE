#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL produtos DESCRIPTION "Retorna os produtos"
	WSMETHOD GET DESCRIPTION "Retorna os produtos" WSSYNTAX "/produtos/"
END WSRESTFUL

WSMETHOD GET WSSERVICE produtos
	Local nI := 1
	
	dbSelectArea("SB1")
	SB1->(dbGoTop())
	
	::SetResponse('[')
	
	While SB1->(!EOF())
		If nI > 1
			::SetResponse(',')
		Endif
		::SetResponse('{')
		::SetResponse('"filial":"' + alltrim(SB1->B1_FILIAL)+ '",')
		::SetResponse('"codigo":"' + alltrim(SB1->B1_COD)+ '",')
		::SetResponse('"descricao":"' + alltrim(SB1->B1_DESC)+ '"')
		::SetResponse('}')
		nI++
		SB1->(dbSkip())
	End While
	
	::SetResponse(']')
Return .t.
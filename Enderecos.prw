#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL enderecos DESCRIPTION "Retorna os enderecos"
	WSMETHOD GET DESCRIPTION "Retorna os enderecos" WSSYNTAX "/enderecos/"
END WSRESTFUL

WSMETHOD GET WSSERVICE enderecos
	Local nI := 1
	
	::SetContentType("application/json")
	
	dbSelectArea("SBE")
	SBE->(dbGoTop())
	
	::SetResponse('[')
	
	While SBE->(!EOF())
		If nI > 1
			::SetResponse(',')
		Endif
		::SetResponse('{')
		::SetResponse('"filial":"' + alltrim(SBE->BE_FILIAL)+ '",')
		::SetResponse('"local":"' + alltrim(SBE->BE_LOCAL)+ '",')
		::SetResponse('"endereco":"' + alltrim(SBE->BE_LOCALIZ)+ '"')
		::SetResponse('}')
		nI++
		SBE->(dbSkip())
	End While
	
	::SetResponse(']')
Return .t.
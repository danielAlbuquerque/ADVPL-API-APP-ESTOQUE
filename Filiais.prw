#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL filiais DESCRIPTION "Retorna as filiais"
	WSMETHOD GET DESCRIPTION "Retorna as filiais" WSSYNTAX "/filiais/"
END WSRESTFUL

WSMETHOD GET WSSERVICE filiais
	Local nI := 1
	
	::SetContentType("application/json")
	
	dbSelectArea("SM0")
	SM0->(dbGoTop())
	
	::SetResponse('[')
	
	While SM0->(!EOF())
		If nI > 1
			::SetResponse(',')
		Endif
		::SetResponse('{')
		::SetResponse('"nome":"' + alltrim(SM0->M0_NOME)+ '",')
		::SetResponse('"cod_filial":"' + alltrim(SM0->M0_CODFIL)+ '",')
		::SetResponse('"filial":"' + alltrim(SM0->M0_FILIAL)+ '"')
		::SetResponse('}')
		nI++
		SM0->(dbSkip())
	End While
	
	::SetResponse(']')
Return .t.
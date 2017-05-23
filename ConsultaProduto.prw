#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL consultaproduto DESCRIPTION "Retorna os dados de um produto"
	WSDATA CodProduto AS STRING 
	WSMETHOD GET DESCRIPTION "Retorna os dados de um produto" WSSYNTAX "/consultaproduto/{CodProduto}"
END WSRESTFUL

WSMETHOD GET WSRECEIVE CodProduto WSSERVICE consultaproduto
	Local lRet := .F.
	Local nSaldoDisp := 0
	
	If Len(::aURLParms) > 0
		dbSelectArea('SB1')
		SB1->(dbSetOrder(1))
		
		If SB1->(MsSeek(xFilial('SB1')+::aURLParms[1]))
			dbSelectArea("SB2")
			SB1->(dbSetOrder(1))
			
			If SB2->( MsSeek(xFilial("SB2") + SB1->B1_COD))
				nSaldoDisp := (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP)
			EndIf
			
			::SetResponse('{"DESCRICAO":"' + alltrim(SB1->B1_DESC) + '", "SALDO_DISP":' + cValToChar(nSaldoDisp) + ',"SALDO_ATUAL":' + cValToChar(SB2->B2_QATU) + ', "TIPO": "' + alltrim(SB1->B1_TIPO) + '"}')
			
			lRet := .T.
		Else
			SetRestFault(404, "Produto não encontrado")
		EndIf
	Else
		SetRestFault(400, "Favor informar o código do produto")
	EndIf
Return(lRet)
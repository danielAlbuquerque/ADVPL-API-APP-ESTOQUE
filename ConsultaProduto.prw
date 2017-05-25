#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "AARRAY.CH"
#INCLUDE "JSON.CH"

WSRESTFUL consultaproduto DESCRIPTION "Retorna os dados de um produto"
	WSDATA CodProduto AS STRING 
	WSMETHOD GET DESCRIPTION "Retorna os dados de um produto" WSSYNTAX "/consultaproduto/{CodProduto}"
END WSRESTFUL

WSMETHOD GET WSRECEIVE CodProduto WSSERVICE consultaproduto
	Local lRet := .F.
	Local nSaldoDisp := 0
	Local aResult := Array(#)
	Local aAreaM0
	Local aEmpAux
	Local nGrp
	Local cUnidNeg
	Local aFilAux
	Local nAtu
	Local cEmpAnt
	
	::SetContentType("application/json")
	
	If Len(::aURLParms) > 0
		dbSelectArea('SB1')
		SB1->(dbSetOrder(1))
		If SB1->(MsSeek(xFilial('SB1')+::aURLParms[1]))
			dbSelectArea("SB2")
			SB1->(dbSetOrder(1))
			If SB2->( MsSeek(xFilial("SB2") + SB1->B1_COD))
				nSaldoDisp := (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QEMP)
			EndIf
			// Informações do produto
			aResult[#'descricao'] := alltrim(SB1->B1_DESC)
			aResult[#'tipo']      := alltrim(SB1->B1_TIPO)
			aResult[#'qtd_disp']  := nSaldoDisp
			aResult[#'qtd_atual'] := SB2->B2_QATU
			::SetResponse(ToJson(aResult))
			lRet := .T.
		Else
			SetRestFault(404, "Produto não encontrado")
		EndIf
	Else
		SetRestFault(400, "Favor informar o código do produto")
	EndIf
Return(lRet)
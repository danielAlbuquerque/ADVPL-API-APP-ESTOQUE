#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL recebedadosinv DESCRIPTION "Recebe os dados coletados no inventario"
	WSMETHOD POST DESCRIPTION "Recebe os dados coletados no inventario" WSSYNTAX "/recebedadosinv/"
END WSRESTFUL

WSMETHOD POST WSSERVICE recebedadosinv
	Local lRet       := .T.
	Local cBody
	Local oParseJSON := Nil
	Local aVetor     := {}
	Local aLog
	Local cErro
	Local nI
	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.   
	
	::SetContentType("application/json")
	
	cBody := ::GetContent()
	
	FWJsonDeserialize(cBody, @oParseJSON)
	
	aVetor := {;
    	{"B7_FILIAL" , PADR(oParseJSON:filial,  TAMSX3("B7_FILIAL")[1]),   Nil},;
        {"B7_COD",     PADR(oParseJSON:produto,  TAMSX3("B7_COD")[1]),     Nil},;
        {"B7_DOC",     PADR(oParseJSON:doc,      TAMSX3("B7_DOC")[1]),     Nil},;
        {"B7_QUANT",   val(oParseJSON:qtd),  		   					   Nil},;
        {"B7_QTSEGUM", val(oParseJSON:qtd2), 		   					   Nil},;
        {"B7_LOCAL",   PADR(oParseJSON:local,    TAMSX3("B7_LOCAL")[1]),   Nil},;
        {"B7_LOCALIZ", PADR(oParseJSON:endereco, TAMSX3("B7_LOCALIZ")[1]), Nil},;
        {"B7_DATA",    Date(),                                             Nil} }
	
	MSExecAuto({|x,y,z| mata270(x,y,z)},aVetor,.T.,3)
	
	If lMsErroAuto
		aLog := GetAutoGRLog()
		For nI := 1 To Len(aLog)
			//cErro += (aLog[nI] + CRLF)
			conout(aLog[nI])
		Next nI
    	lRet := .F.
    	
    	SetRestFault(500, "Erro ao processar requisição")
	Else
    	::SetResponse('{"success":"true"}')
	EndIf
	
Return(lRet)
<?xml version = '1.0' encoding = 'ISO-8859-1'?>
<!--Es müssen immer mindestens drei Jahre im Stylesheet möglich sein, wegen der Verzinsung nach § 233a AO. d.h. das aktuelle + die beiden vorangegangenen --><!--Beispiel: Voranmeldungen für 12/2004 können bis zum 31.03.2006 abgegeben werden --><!-- Version 1.2.3  A.M.--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="elster" version="1.0" >
  <xsl:output xmlns:xsl="http://www.w3.org/1999/XSL/Transform" method="html" indent="yes" encoding="UTF-8" />
  <xsl:output xmlns:xsl="http://www.w3.org/1999/XSL/Transform" doctype-public="-//W3C//DTD HTML 4.01//EN" />
  <xsl:output xmlns:xsl="http://www.w3.org/1999/XSL/Transform" doctype-system="http://www.w3.org/TR/html4/loose.dtd" />
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="elster:Elster" >
    <html>
      <head>
        <title>StylesheetUStVA</title>
        <style type="text/css" >
				body {   	color: #000000;                      background: #FFFFFF;    padding: 0px;  font-family:helvetica;    font-style:normal;         font-size:10pt;          }     
				td {        	 padding: 0px;         	font-style:normal;   	font-size:10pt;          }     
				td.kz {           padding: 0px;            font-style:normal;    font-size:10pt;          }     
				small {		 padding: 0px;             font-style:normal;    font-size:8pt;          }   
				big {		 padding: 0px;             font-weight:bold;     font-size:12pt;          }     
				b {			 padding: 0px;              font-weight:bold;      font-size:10pt;          }     
				u   {		 padding: 0px;             font-weight:normal;     font-size:10pt;    text-decoration:underline;       }   				
				</style>
      </head>
      <body>
        <table width="1024" >
          <tr>
            <td align="left" >
              <small>Übermittelt von:</small>
            </td>
          </tr>
          <tr>
            <td align="left" >
              <small>
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Name" />
              </small>
            </td>
            <td align="right" >
              <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:TransferHeader/elster:EingangsDatum" >
                  <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Eingang auf Server </xsl:text>
                  <xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:TransferHeader/elster:EingangsDatum" />
                </xsl:when>
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Ausdruck vor Übermittlung </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td align="left" >
              <small>
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Strasse" />
              </small>
            </td>
            <td align="right" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:TransferHeader/elster:TransferTicket" >
								Transferticket  
								<xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:TransferHeader/elster:TransferTicket" />
              </xsl:if>
            </td>
          </tr>
          <tr>
            <td colspan="1" align="left" >
              <small>
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:PLZ" />
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Ort" />
              </small>
            </td>
            <td align="right" >
							Erstellungsdatum    
							<xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Erstellungsdatum" />
            </td>
          </tr>
          <tr>
            <td align="left" >
              <small>
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Telefon" />
              </small>
            </td>
          </tr>
          <tr>
            <td align="left" >
              <small>
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Email" />
              </small>
            </td>
          </tr>
        </table>
        <table width="1024" >
          <tr>
            <td align="left" >
              <br/>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]" >
                <big>*** TESTFALL ***</big>
              </xsl:if>
            </td>
            <td align="center" >
              <br/>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]" >
                <big>*** TESTFALL ***</big>
              </xsl:if>
            </td>
            <td align="right" >
              <br/>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]" >
                <big>*** TESTFALL ***</big>
              </xsl:if>
            </td>
          </tr>
          <tr>
            <td colspan="3" align="center" >
              <hr/>
<!-- ***********************************************************-->              <hr/>
<!-- *********************************************************** -->            </td>
          </tr>
        </table>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater | //elster:Mandant | //elster:Unternehmer" >
          <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Berater_Mandant_Unternehmer" />
        </xsl:if>
        <xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Steuerfall/elster:Umsatzsteuervoranmeldung" />
        <xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Steuerfall/elster:Dauerfristverlaengerung" />
        <xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung" />
      </body>
    </html>
  </xsl:template>
<!-- **************** STEUERFALL ********************************* -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="//elster:Steuerfall/*" >
    <table width="1024" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="contains(elster:Kz09,'*')" >
        <tr>
          <td align="left" >
            <small>
              <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Erstellt_von" />
            </small>
            <br/>
            <p/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td align="left" >
          <br/>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="substring-after((substring-after(substring-after(substring-after(substring-after(normalize-space(elster:Kz09),'*'),'*'),'*'),'*')),'*')" >
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Unternehmer: </xsl:text>
          </xsl:if>
        </td>
        <td align="right" >
          <br/>
          <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Steuernummer" />
        </td>
      </tr>
      <tr>
        <td align="left" >
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="substring-after((substring-after(substring-after(substring-after(substring-after(normalize-space(elster:Kz09),'*'),'*'),'*'),'*')),'*')" >
            <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Unternehmer" />
          </xsl:if>
          <br/>
        </td>
      </tr>
      <tr>
        <td colspan="2" align="center" >
          <br/>
          <big>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Antrag auf Dauerfristverlängerung</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Dauerfristverlaengerung')" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Antrag auf Dauerfristverlängerung</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Anmeldung der Sondervorauszahlung</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuervoranmeldung')" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Umsatzsteuer-Voranmeldung</xsl:text>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="not(starts-with(local-name(),'Umsatzsteuervoranmeldung'))" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">(§§ 46 bis 48 UStDV)</xsl:text>
              <br/>
            </xsl:if>
            <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Zeitraum" />
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" />
            <br/>
          </big>
        </td>
      </tr>
    </table>
    <table width="1024" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="BearbeitungsKennzahlen" />
    </table>
    <table width="1024" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuervoranmeldung')" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="UStVA" />
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Dauerfristverlaengerung')" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="DV" />
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="SVZ" />
      </xsl:if>
    </table>
    <table width="1024" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Hinweise" />
    </table>
  </xsl:template>
<!--*****    ERSTELLUNGSDATUM    *******************************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="elster:Erstellungsdatum" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,7)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">.</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,5,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">.</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,1,4)" />
  </xsl:template>
<!--******   EINGANGSDATUM   *******************************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="elster:TransferHeader/elster:EingangsDatum" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,7,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">.</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,5,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">.</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,1,4)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">,</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,9,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">:</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,11,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">:</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(.,13,2)" />
  </xsl:template>
<!--*******   ERSTELLT VON   *******************************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Erstellt_von" >
<!-- aus Kz09 -->    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="contains(elster:Kz09,'*')" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="not(starts-with(normalize-space(substring-after(elster:Kz09,'*')),'*'))" >
        <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Erstellt von: </xsl:text>
      </xsl:if>
    </xsl:if>
<!-- NameBerater -->    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring-before(substring-after(elster:Kz09,'*'),'*')" />
<!-- Berufsbezeichung -->    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring-before((substring-after(substring-after(elster:Kz09,'*'),'*')),'*')" />
<!-- Vorwahl -->    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring-before(substring-after((substring-after(substring-after(elster:Kz09,'*'),'*')),'*'),'*')" />
<!-- Rufnummer -->    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring-before(substring-after((substring-after(substring-after(substring-after(elster:Kz09,'*'),'*'),'*')),'*') ,'*')" />
  </xsl:template>
<!--****  UNTERNEHMER    *****************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Unternehmer" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring-after((substring-after(substring-after(substring-after(substring-after(elster:Kz09,'*'),'*'),'*'),'*')),'*')" />
  </xsl:template>
<!-- Berater Mandant Unternehmer -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Berater_Mandant_Unternehmer" >
    <table width="1024" >
      <tr>
        <td valign="top" style="width:50%" align="left" colspan="1" >
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater" >
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Berater:</xsl:text>
            <br/>
          </xsl:if>
          <small>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Bezeichnung" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Bezeichnung" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Name | //elster:Berater/elster:Vorname" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Namensvorsatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Namensvorsatz" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Vorname" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Vorname" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Namenszusatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Namenszusatz" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Name" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Name" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Str | //elster:Berater/elster:Hausnummer" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Str" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Str" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Hausnummer" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Hausnummer" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:HNrZusatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:HNrZusatz" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:AnschriftenZusatz" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:AnschriftenZusatz" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Ort" >
              <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:PLZ" >
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:PLZ" />
                </xsl:when>
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                    <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:AuslandsPLZ" >
                      <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:AuslandsPLZ" />
                    </xsl:when>
                    <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:GKPLZ" >
                        <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:GKPLZ" />
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Ort" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Ort" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Land" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Land" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Postfach" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Postfach:</xsl:text>
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Postfach" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:PostfachOrt" >
              <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:PostfachPLZ" >
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:PostfachPLZ" />
                </xsl:when>
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:GKPLZ" >
                    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:GKPLZ" />
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:PostfachOrt" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:PostfachOrt" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Telefon" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Telefon" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Berater/elster:Email" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Berater/elster:Email" />
              <br/>
            </xsl:if>
          </small>
          <br/>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant" >
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Mandant:</xsl:text>
            <br/>
          </xsl:if>
          <small>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant/elster:Name | //elster:Mandant/elster:Vorname" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant/elster:Vorname" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Mandant/elster:Vorname" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant/elster:Name" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Mandant/elster:Name" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant/elster:MandantenNr" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Mandantennummer:</xsl:text>
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Mandant/elster:MandantenNr" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Mandant/elster:Bearbeiterkennzeichen" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Bearbeiterkennzeichen:</xsl:text>
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Mandant/elster:Bearbeiterkennzeichen" />
              <br/>
            </xsl:if>
          </small>
        </td>
        <td valign="top" style="width:50%" align="left" colspan="1" >
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer" >
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Unternehmer:</xsl:text>
            <br/>
          </xsl:if>
          <small>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Bezeichnung" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Bezeichnung" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Name | //elster:Unternehmer/elster:Vorname" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Namensvorsatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Namensvorsatz" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Vorname" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Vorname" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Namenszusatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Namenszusatz" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Name" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Name" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Str | //elster:Unternehmer/elster:Hausnummer" >
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Str" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Str" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Hausnummer" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Hausnummer" />
              </xsl:if>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:HNrZusatz" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:HNrZusatz" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:AnschriftenZusatz" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:AnschriftenZusatz" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Ort" >
              <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:PLZ" >
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:PLZ" />
                </xsl:when>
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                    <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:AuslandsPLZ" >
                      <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:AuslandsPLZ" />
                    </xsl:when>
                    <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:GKPLZ" >
                        <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:GKPLZ" />
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Ort" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Ort" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Land" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Land" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Postfach" >
              <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Postfach:</xsl:text>
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Postfach" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:PostfachOrt" >
              <xsl:choose xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                <xsl:when xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:PostfachPLZ" >
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:PostfachPLZ" />
                </xsl:when>
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:GKPLZ" >
                    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:GKPLZ" />
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:PostfachOrt" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:PostfachOrt" />
              </xsl:if>
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Telefon" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Telefon" />
              <br/>
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="//elster:Unternehmer/elster:Email" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Unternehmer/elster:Email" />
              <br/>
            </xsl:if>
          </small>
          <br/>
        </td>
      </tr>
    </table>
  </xsl:template>
<!--****  STEUERNUMMER    *****************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Steuernummer" >
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Steuernummer:  </xsl:text>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'10')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr335" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'11')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'21')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235a" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'22')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'23')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'24')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235a" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'26')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr0235" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'27')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr2341" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'28')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr55" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'3')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr335" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'4')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr335" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'5')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr344" />
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Steuernummer[starts-with(.,'9')]" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr335" />
    </xsl:if>
  </xsl:template>
<!-- Steuernummern formatieren -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr0235" >
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">0</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,3,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,5)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr2341" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,3,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,4)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,13,1)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,3,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,5)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr235a" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,3,2)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,5)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr344" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,2,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,4)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,10,4)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr335" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,2,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,5)" />
  </xsl:template>
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="StNr55" >
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,3,2)" />
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,6,3)" />
    <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">/</xsl:text>
    <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="substring(elster:Steuernummer,9,5)" />
  </xsl:template>
<!-- Zeitraume aufloesen -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Zeitraum" >
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'41')]" >
			1. Kalendervierteljahr 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'42')]" >
			2. Kalendervierteljahr 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'43')]" >
			3. Kalendervierteljahr 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'44')]" >
			4. Kalendervierteljahr 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'01')]" >
			Januar 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'02')]" >
			Februar 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'03')]" >
			März  
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'04')]" >
			April  
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'05')]" >
			Mai 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'06')]" >
			Juni 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'07')]" >
			Juli 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'08')]" >
			August 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'09')]" >
			September 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'10')]" >
			Oktober 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'11')]" >
			November 
		</xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Zeitraum[starts-with(.,'12')]" >
			Dezember 
		</xsl:if>
  </xsl:template>
<!-- **************** BearbeitungsKennzahlen ********************************* -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="BearbeitungsKennzahlen" >
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz10 | elster:Kz22 " >
      <tr>
        <td style="width:65%" />
        <td style="width:15%" />
        <td style="width:5%" align="right" >Kz</td>
        <td style="width:15%" align="right" >Wert</td>
      </tr>
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz10" >
          <td align="left" colspan="1" >
            <br/>
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  Berichtigte Anmeldung </xsl:text>
          </td>
          <td/>
          <td valign="bottom" align="right" colspan="1" >10</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz10" />
          </td>
        </xsl:if>
      </tr>
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz22" >
          <td align="left" colspan="1" >
            <br/>
            <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Belege werden gesondert eingereicht </xsl:text>
          </td>
          <td/>
          <td valign="bottom" align="right" colspan="1" >22</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz22" />
          </td>
        </xsl:if>
      </tr>
      <tr>
        <td colspan="5" align="center" >
          <br/>
          <hr/>
<!-- ***********************************************************-->        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** UStVA *******************************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="UStVA" >
    <tr>
      <td style="width:60%" />
      <td style="width:5%" align="right" >Kz</td>
      <td style="width:15%" align="right" >Bemessungsgrundlage</td>
      <td style="width:5%" align="right" >Kz</td>
      <td style="width:15%" align="right" >Steuer</td>
    </tr>
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Anmeldung der Umsatzsteuer-Vorauszahlung</xsl:text>
        </big>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz41 | elster:Kz44  | elster:Kz49  | elster:Kz43 | elster:Kz48  | elster:Kz51   | elster:Kz86    | elster:Kz35    | elster:Kz36   | elster:Kz77   | elster:Kz76   | elster:Kz80 | elster:Kz81" >
      <tr>
        <td align="left" colspan="5" >
          <br/>
          <big>
						Lieferungen und sonstige Leistungen (einschließlich unentgeltlicher Wertabgaben)
					</big>
        </td>
      </tr>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test=" elster:Kz41 | elster:Kz44  | elster:Kz49    | elster:Kz43" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stfrUmsVost" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz48" >
      <tr>
        <td align="left" colspan="5" >
          <br/>
          <b>Steuerfreie Umsätze ohne Vorsteuerabzug</b>
        </td>
      </tr>
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Umsätze nach § 4 Nr. 8 bis 28 UStG</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >48</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select=" elster:Kz48" />
        </td>
      </tr>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test=" elster:Kz51  | elster:Kz86    | elster:Kz35  | elster:Kz36 | elster:Kz81" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stpflUms" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz77  | elster:Kz76 | elster:Kz80" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="landwUms" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz89  | elster:Kz91  | elster:Kz97 | elster:Kz93 | elster:Kz95  | elster:Kz94" >
      <tr>
        <td align="left" colspan="5" >
          <br/>
          <big>
					Innergemeinschaftliche Erwerbe
					</big>
        </td>
      </tr>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz91" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz91" >
        <tr>
          <td align="left" colspan="5" >
            <br/>
            <b>Steuerfreie innergemeinschaftliche Erwerbe</b>
          </td>
        </tr>
        <tr>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz91" >
            <td align="left" colspan="1" >
              <br/>
              <small>Erwerbe nach § 4b UStG</small>
            </td>
            <td valign="bottom" align="right" colspan="1" >91</td>
            <td valign="bottom" align="right" colspan="1" >
              <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz91" />
            </td>
          </xsl:if>
        </tr>
      </xsl:if>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz89  | elster:Kz97   | elster:Kz93 | elster:Kz95    | elster:Kz94" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="innergemErwerbe" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz42	 | elster:Kz60  | elster:Kz45" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="ergAng" />
      </xsl:if>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz54   | elster:Kz55  | elster:Kz57" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200413b" />
      </xsl:if>
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz45" >
          <td align="left" colspan="1" >
            <br/>
            <b>Nicht steuerbare Umsätze</b>
          </td>
          <td valign="bottom" align="right" colspan="1" >45</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz45" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz52  | elster:Kz73   | elster:Kz84" >
        <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200513b" />
      </xsl:if>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz65" >
        <td align="left" colspan="1" >
          <br/>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
            <small>Steuer infolge Wechsels der Besteuerungsart/-form sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerhöhung</small>
          </xsl:if>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
            <small>Steuer infolge Wechsels der Besteuerungsform sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerhöhung</small>
          </xsl:if>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >65</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz65" />
        </td>
      </xsl:if>
    </tr>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz66   | elster:Kz61  | elster:Kz62   | elster:Kz67  | elster:Kz63 | elster:Kz64  | elster:Kz59" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Vorsteuer" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz69" >
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))] and elster:Jahr[not(starts-with(.,'2005'))] " >
        <tr>
          <td align="left" colspan="5" >
            <br/>
            <b>Andere Steuerbeträge</b>
            <br/>
          </td>
        </tr>
        <tr>
          <td align="left" colspan="1" >
            <small>in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbeträge (§ 14c UStG) sowie Steuerbeträge, die nach § 4 Nr. 4a Satz 1 Buchst. a Satz 2, § 6a Abs. 4 Satz 2, § 17 Abs. 1 Satz 6 oder § 25b Abs. 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="right" colspan="1" >69</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz69" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2005')]" >
        <tr>
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerbeträge, die vom letzten Abnehmer eines innergemeinschaftlichen Dreiecksgeschäfts geschuldet werden (§ 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbeträge (§ 14c UStG), Steuerbeträge für Leistungen im Sinne des § 13a Abs. 1 Nr. 6 UStG sowie Steuerbeträge, die nach § 6a Abs. 4 Satz 2 oder § 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="right" colspan="1" >69</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz69" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
        <tr>
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerbeträge, die vom letzten Abnehmer eines innergemeinschaftlichen Dreiecksgeschäfts geschuldet werden (§ 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbeträge sowie Steuerbeträge, die nach § 6a Abs. 4 Satz 2 oder § 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="right" colspan="1" >69</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz69" />
          </td>
        </tr>
      </xsl:if>
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz39" >
        <td align="left" colspan="1" >
          <br/>
          <small>Anrechnung (Abzug) der festgesetzten Sondervorauszahlung für Dauerfristverlängerung (nur auszufüllen in der letzten Voranmeldung des Besteuerungszeitraums, in der Regel Dezember)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >39</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz39" />
        </td>
      </xsl:if>
    </tr>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz83" >
        <td align="left" colspan="1" >
          <br/>
          <small>
            <b>Verbleibende Umsatzsteuer-Vorauszahlung </b>
          </small>
          <br/>
          <small>
            <b>verbleibender Überschuss</b>
          </small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >83</td>
        <td valign="bottom" align="right" colspan="1" >
          <b>
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz83" />
          </b>
        </td>
      </xsl:if>
    </tr>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz26" >
        <td align="left" colspan="5" >
          <br/>
          <big>
						Sonstige Angaben
					</big>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz29" >
        <td align="left" colspan="1" >
          <br/>
          <small>Verrechnung des Erstattungsbetrags erwünscht/ Erstattungsbetrag ist abgetreten</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >29</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz29" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz26" >
        <td align="left" colspan="1" >
          <br/>
          <small>Die Einzugsermächtigung wird ausnahmsweise (z.B. wegen Verrechnungswünschen) für diesen Voranmeldungszeitraum widerrufen</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >26</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz26" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** stfrUmsVost  ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stfrUmsVost" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerfreie Umsätze mit Vorsteuerabzug</b>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz41" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen (§ 4 Nr. 1 Buchst. b UStG) an Abnehmer mit USt-IdNr.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >41</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz41" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz44" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge an Abnehmer ohne USt-IdNr.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >44</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz44" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz49" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge außerhalb eines Unternehmens (§ 2a UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >49</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz49" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz43" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Weitere steuerfreie Umsätze mit Vorsteuerabzug (z.B. Ausfuhrlieferungen, Umsätze nach § 4 Nr. 2 bis 7 UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >43</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz43" />
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--********************'stpflUms'  !******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stpflUms" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerpflichtige Umsätze</b>
        <br/>
        <small>(Lieferungen und sonstige Leistungen einschl. unentgeltlicher Wertabgaben)</small>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz51" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >51</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz51" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz81" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 19 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >81</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz81" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz86" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >86</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz86" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz35" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Umsätze, die anderen Steuersätzen unterliegen</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >35</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz35" />
        </td>
        <td valign="bottom" align="right" >36</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz36" />
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** 'u200513b' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200513b" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
					Umsätze, für die als Leistungsempfänger die Steuer nach § 13b Abs. 2 UStG geschuldet wird
				</big>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz52" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Leistungen eines im Ausland ansässigen Unternehmers (§ 13b Abs. 1 Satz 1 Nr. 1 und 5 UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >52</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz52" />
        </td>
        <td valign="bottom" align="right" >53</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz53" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz73" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen sicherungsübereigneter Gegenstände und Umsätze, die unter das GrEStG fallen (§ 13b Abs. 1 Satz 1 Nr. 2 und 3 UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >73</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz73" />
        </td>
        <td valign="bottom" align="right" >74</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz74" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz84" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Bauleistungen eines im Inland ansässigen Unternehmers  (§ 13b Abs. 1 Satz 1 Nr. 4 UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >84</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz84" />
        </td>
        <td valign="bottom" align="right" >85</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz85" />
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** ''u200413b'' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200413b" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Umsätze, für die der Leistungsempfänger die Steuer nach § 13b Abs. 2 UStG schuldet</b>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz54" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >54</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz54" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz55" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >55</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz55" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz57" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zu anderen Steuersätzen</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >57</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz57" />
        </td>
        <td valign="bottom" align="right" >58</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz58" />
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--********************'innergemErwerbe'******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="innergemErwerbe" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerpflichtige innergemeinschaftliche Erwerbe</b>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz97" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >97</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz97" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz89" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 19 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >89</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz89" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz93" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >93</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz93" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz95" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>zu anderen Steuersätzen</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >95</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz95" />
        </td>
        <td valign="bottom" align="right" >98</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz98" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz94" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>neuer Fahrzeuge von Lieferern ohne USt-IdNr. zum allgemeinen Steuersatz</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >94</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz94" />
        </td>
        <td valign="bottom" align="right" >96</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz96" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz42" >
          <td align="left" colspan="1" >
            <br/>
            <small>Lieferungen des ersten Abnehmers bei innergemeinschaftlichen Dreiecksgeschäften (§ 25b Abs. 2 UStG) </small>
          </td>
          <td valign="bottom" align="right" colspan="1" >42</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz42" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** 'landwUms' !******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="landwUms" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Umsätze land- und forstwirtschaftlicher Betriebe nach § 24 UStG</b>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz77" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen in das übrige Gemeinschaftsgebiet an Abnehmer mit USt-IdNr.</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >77</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz77" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz76" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Umsätze, für die eine Steuer nach § 24 UStG zu entrichten ist (Sägewerkserzeugnisse, Getränke und alkohol. Flüssigkeiten, z.B. Wein)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >76</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz76" />
        </td>
        <td valign="bottom" align="right" >80</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz80" />
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** 'ergAng' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="ergAng" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
					Ergänzende Angaben zu Umsätzen
				</big>
      </td>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz42" >
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen des ersten Abnehmers  bei innergemeinschaftlichen Dreiecksgeschäften (§ 25b Abs. 2 UStG)</small>
        </td>
        <td valign="bottom" align="right" colspan="1" >42</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz42" />
        </td>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz60" >
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerpflichtige Umsätze im Sinne des § 13b Abs. 1 Satz 1 Nr. 1 bis 5 UStG, für die der Leistungsempfänger die Steuer schuldet</small>
          </td>
          <td valign="bottom" align="right" colspan="1" >60</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz60" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2005')] | elster:Jahr[starts-with(.,'2006')] " >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz45" >
          <td align="left" colspan="1" >
            <br/>
            <b>Im Inland nicht steuerbare Umsätze</b>
          </td>
          <td valign="bottom" align="right" colspan="1" >45</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz45" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2007')]|elster:Jahr[starts-with(.,'2008')]" >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz45" >
          <td align="left" colspan="1" >
            <br/>
            <b>Nicht steuerbare Umsätze </b>						
						(Leistungsort nicht im Inland)						
					</td>
          <td valign="bottom" align="right" colspan="1" >45</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz45" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** 'Vorsteuer' *****-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Vorsteuer" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
					Abziehbare Vorsteuerbeträge
				</big>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz66" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbeträge aus Rechnungen von anderen Unternehmern (§ 15 Abs. 1 Satz 1 Nr. 1 UStG), aus Leistungen im Sinne des § 13a Abs. 1 Nr. 6 UStG (§ 15 Abs. 1 Satz 1 Nr. 5 UStG) und aus innergemeinschaftlichen Dreiecksgeschäften (§25b Abs. 5 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >66</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz66" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz61" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbeträge aus dem innergemeinschaftlichen Erwerb von Gegenständen (§ 15 Abs. 1 Satz 1 Nr. 3 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >61</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz61" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz62" >
        <td align="left" colspan="1" >
          <br/>
          <small>Entrichtete Einfuhrumsatzsteuer (§ 15 Abs. 1 Satz 1 Nr. 2 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >62</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz62" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz67" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbeträge aus Leistungen im Sinne des § 13b Abs. 1 UStG (§ 15 Abs. 1 Satz 1 Nr. 4 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >67</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz67" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz63" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbeträge, die nach allgemeinen Durchschnittssätzen berechnet sind (§§ 23 und 23a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >63</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz63" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz64" >
        <td align="left" colspan="1" >
          <br/>
          <small>Berichtigung des Vorsteuerabzugs (§ 15a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >64</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz64" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz59" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerabzug für innergemeinschaftliche Lieferungen neuer Fahrzeuge außerhalb eines Unternehmens (§ 2a UStG) sowie von Kleinunternehmern im Sinne des § 19 Abs. 1 UStG (§ 15 Abs. 4a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="right" colspan="1" >59</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz59" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** DAUERFRISTVERLAENGERUNG **************** -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="DV" >
    <br/>
    <tr>
      <td>
        <b>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">I. Antrag auf Dauerfristverlängerung</xsl:text>
        </b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <br/>
        <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			Ich beantrage, die Fristen für die Abgabe der Umsatzsteuer-Voranmeldungen und für die Entrichtung der Umsatzsteuer-Vorauszahlungen um einen Monat zu verlängern.
			</xsl:text>
      </td>
    </tr>
  </xsl:template>
<!-- ******************* SONDERVORAUSZAHLUNG *********************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="SVZ" >
    <tr>
      <td>
        <b> I. Antrag auf Dauerfristverlängerung </b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <br/>
				Ich beantrage, die Fristen für die Abgabe der Umsatzsteuer-Voranmeldungen und für die Entrichtung der Umsatzsteuer-Vorauszahlungen um einen Monat zu verlängern.
			</td>
      <br/>
    </tr>
    <tr>
      <td colspan="2" align="center" >- Dieser Abschnitt ist gegenstandslos, wenn bereits Dauerfristverlängerung gewährt worden ist. -</td>
    </tr>
    <br/>
    <tr>
      <td>
        <br/>
        <br/>
        <br/>
        <b> II. Berechnung und Anmeldung der Sondervorauszahlung auf die Steuer für das Kalenderjahr 
				          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" /> von Unternehmern, die ihre Voranmeldungen monatlich abzugeben haben</b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <table width="1024" cellspacing="3" align="right" >
          <tr>
            <td style="width:80%" />
            <td style="width:5%" align="right" >Kz</td>
            <td style="width:15%" align="right" >Betrag</td>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz38" >
              <td align="left" colspan="1" >
                <br/>
                <small>Summe der verbleibenden Umsatzsteuer-Vorauszahlungen zuzüglich der angerechneten Sondervorauszahlung für das Kalenderjahr <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="(elster:Jahr)-1" />; davon 1/11 = Sondervorauszahlung <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" />
                </small>
              </td>
              <td valign="bottom" align="right" colspan="1" >38</td>
              <td valign="bottom" align="right" colspan="1" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz38" />
              </td>
            </xsl:if>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz29|elster:Kz26" >
              <td align="left" colspan="5" >
                <br/>
                <big>
                  <b>
										Sonstige Angaben
									</b>
                </big>
              </td>
            </xsl:if>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz29" >
              <td align="left" colspan="1" >
                <br/>
                <small>Verrechnung des Erstattungsbetrags erwünscht/ Erstattungsbetrag ist abgetreten</small>
              </td>
              <td valign="bottom" align="right" colspan="1" >29</td>
              <td valign="bottom" align="right" colspan="1" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz29" />
              </td>
            </xsl:if>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz26" >
              <td align="left" colspan="1" >
                <br/>
                <small>Die Einzugsermächtigung wird ausnahmsweise (z.B. wegen Verrechungswünschen) für die Sondervorauszahlung dieses Jahres widerrufen.</small>
              </td>
              <td valign="bottom" align="right" colspan="1" >26</td>
              <td valign="bottom" align="right" colspan="1" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz26" />
              </td>
            </xsl:if>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
<!--****************  Hinweise   **********************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Hinweise" >
    <tr>
      <td>
        <hr/>
<!-- ***********************************************************-->        <br/>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <big>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Hinweis zu Säumniszuschlägen</xsl:text>
        </big>
        <br/>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			Bitte beachten Sie, dass bei Zahlung der angemeldeten Steuer durch Hingabe eines Schecks erst der dritte Tag nach dem Tag des Eingangs des Schecks bei der zuständigen Finanzkasse als Einzahlungstag gilt (§ 224 Abs. 2 Nr. 1 Abgabenordnung). Fällt der dritte Tag auf einen Samstag, einen Sonntag oder einen gesetzlichen Feiertag, gilt die Zahlung erst am nächstfolgenden Werktag als bewirkt. Gilt die Zahlung der angemeldeten Steuer durch Hingabe eines Schecks erst nach dem Fälligkeitstag als bewirkt, fallen Säumniszuschläge an (§ 240 Abs. 3 Abgabenordnung). Um diese zu vermeiden wird empfohlen, am Lastschriftverfahren teilzunehmen. Die Teilnahme am Lastschriftverfahren ist jederzeit widerruflich und völlig risikolos. Sollte einmal ein Betrag zu Unrecht abgebucht werden, können Sie diese Abbuchung bei Ihrer Bank innerhalb von 6 Wochen stornieren lassen. Zur Teilnahme am Lastschriftverfahren setzen Sie sich bitte mit Ihrem Finanzamt in Verbindung.
			</xsl:text>
        <br/>
        <br/>
        <br/>
        <br/>
      </td>
    </tr>
    <tr>
      <td>
        <b>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		Dieses Übertragungsprotokoll ist nicht zur Übersendung an das Finanzamt bestimmt. Die Angaben sind auf ihre Richtigkeit hin zu prüfen.
		Sofern eine Unrichtigkeit festgestellt wird, ist eine berichtigte Steueranmeldung abzugeben.
				</xsl:text>
          <br/>
          <br/>
        </b>
        <br/>
      </td>
    </tr>
  </xsl:template>
<!-- ***********************************************************--></xsl:stylesheet>

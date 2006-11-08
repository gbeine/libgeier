<?xml version = '1.0' encoding = 'ISO-8859-1'?>
<!--Es m�ssen immer mindestens drei Jahre im Stylesheet m�glich sein, wegen der Verzinsung nach � 233a AO. d.h. das aktuelle + die beiden vorangegangenen --><!--Beispiel: Voranmeldungen f�r 12/2004 k�nnen bis zum 31.03.2006 abgegeben werden --><!-- Version 1.2.1  A.M.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:elster="http://www.elster.de/2002/XMLSchema" version="1.0" >
  <xsl:output xmlns:xsl="http://www.w3.org/1999/XSL/Transform" method="html" indent="yes" encoding="ISO-8859-1" />
  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="elster:Elster" >
    <html>
      <head>
        <title>StylesheetUStVA</title>
        <STYLE TYPE="text/css" >
				body {   	color: #000000;                   margin: 8px 8px;   background: #FFFFFF;    padding: 0px;  font-family:helvetica;    font-style:normal;         font-size:10pt;          }     
				td {        	background: #FFFFFF;        padding: 0px;       font-family:helvetica;   	font-style:normal;   	font-size:10pt;          }     
				td.kz {    	background: #FFFFFF;        padding: 2px;       font-family:helvetica;       font-style:normal;    font-size:10pt;          }      
				small {		background: #FFFFFF;        padding: 0px;       font-family:helvetica;       font-style:normal;    font-size:9pt;          }   
				big {		background: #FFFFFF;        padding: 0px;       font-family:helvetica;       font-weight:bold;     font-size:12pt;          }     
				b {			background: #FFFFFF;        padding: 0px;       font-family:helvetica;       font-weight:bold;      font-size:10pt;          }     
			
				</STYLE>
      </head>
      <body>
        <table width="645" >
          <tr>
            <td align="left" >
              <small>�bermittelt von:</small>
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
                <xsl:otherwise xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Ausdruck vor �bermittlung </xsl:otherwise>
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
        <table width="645" >
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
        </table>
        <xsl:apply-templates xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="//elster:Steuerfall/*" />
      </body>
    </html>
  </xsl:template>
<!-- **************** STEUERFALL ********************************* -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" match="//elster:Steuerfall/*" >
    <html>
      <body>
        <table width="645" >
          <tr>
            <td colspan="2" align="center" >
              <hr/>
<!-- ***********************************************************-->              <hr/>
<!-- *********************************************************** -->            </td>
          </tr>
          <tr>
            <td align="left" >
              <small>
                <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Erstellt_von" />
              </small>
              <br/>
              <p/>
            </td>
          </tr>
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
                <p>
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
										Antrag auf Dauerfristverl�ngerung
										</xsl:if>
                </p>
                <p>
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Dauerfristverlaengerung')" >
											Antrag auf Dauerfristverl�ngerung
										</xsl:if>
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
											Anmeldung der Sondervorauszahlung
										</xsl:if>
                  <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuervoranmeldung')" >
											Umsatzsteuer-Voranmeldung
										</xsl:if>
                </p>
                <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="not(starts-with(local-name(),'Umsatzsteuervoranmeldung'))" >
										(�� 46 bis 48 UStDV)
										</xsl:if>
                <p>
                  <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Zeitraum" />
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" />
                </p>
                <br/>
              </big>
            </td>
          </tr>
        </table>
        <table width="645" >
          <tr>
            <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="BearbeitungsKennzahlen" />
          </tr>
        </table>
        <table width="645" >
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuervoranmeldung')" >
              <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="UStVA" />
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Dauerfristverlaengerung')" >
              <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="DV" />
            </xsl:if>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')" >
              <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="SVZ" />
            </xsl:if>
          </tr>
        </table>
        <table width="645" >
          <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Hinweise" />
        </table>
      </body>
    </html>
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
			M�rz  
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
        <td colspan="2" >
          <table width="645" cellspacing="3" align="right" >
            <tr>
              <td width="60%" />
              <td width="15%" />
              <td width="5%" align="center" >Kz</td>
              <td width="20%" align="right" >Wert</td>
            </tr>
            <tr>
              <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz10" >
                <td align="left" colspan="1" >
                  <br/>
                  <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">  Berichtigte Anmeldung </xsl:text>
                </td>
                <td/>
                <td valign="bottom" align="center" colspan="1" >10</td>
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
                <td valign="bottom" align="center" colspan="1" >22</td>
                <td valign="bottom" align="right" colspan="1" >
                  <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz22" />
                </td>
              </xsl:if>
            </tr>
          </table>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
<!--******************** UStVA *******************************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="UStVA" >
    <br/>
    <hr/>
    <tr colspan="2" >
      <td width="50%" />
      <td width="5%" align="center" >Kz</td>
      <td width="20%" align="right" >Bemessungsgrundlage</td>
      <td width="5%" align="center" >Kz</td>
      <td width="20%" align="right" >Steuer</td>
    </tr>
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
          <u>Anmeldung der Umsatzsteuer-Vorauszahlung</u>
        </big>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz41 | elster:Kz44  | elster:Kz49  | elster:Kz43 | elster:Kz48  | elster:Kz51   | elster:Kz86    | elster:Kz35    | elster:Kz36   | elster:Kz77   | elster:Kz76   | elster:Kz80 | elster:Kz81" >
        <td align="left" colspan="5" >
          <br/>
          <big>
            <u>Lieferungen und sonstige Leistungen (einschlie�lich unentgeltlicher Wertabgaben)</u>
          </big>
        </td>
      </xsl:if>
    </tr>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test=" elster:Kz41 | elster:Kz44  | elster:Kz49    | elster:Kz43" >
      <xsl:call-template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stfrUmsVost" />
    </xsl:if>
<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ?>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz48" >
      <tr>
        <td align="left" colspan="5" >
          <br/>
          <b>Steuerfreie Ums�tze ohne Vorsteuerabzug</b>
        </td>
      </tr>
      <tr>
        <td align="left" colspan="1" >
          <br/>
          <small>Ums�tze nach � 4 Nr. 8 bis 28 UStG</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >48</td>
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
            <u>Innergemeinschaftliche Erwerbe</u>
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
              <small>Erwerbe nach � 4b UStG</small>
            </td>
            <td valign="bottom" align="center" colspan="1" >91</td>
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
            <b>Nicht steuerbare Ums�tze</b>
          </td>
          <td valign="bottom" align="center" colspan="1" >45</td>
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
            <small>Steuer infolge Wechsels der Besteuerungsart/-form sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerh�hung</small>
          </xsl:if>
          <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
            <small>Steuer infolge Wechsels der Besteuerungsform sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerh�hung</small>
          </xsl:if>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >65</td>
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
            <b>Andere Steuerbetr�ge</b>
            <br/>
          </td>
        </tr>
        <tr>
          <td align="left" colspan="1" >
            <small>in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbetr�ge (� 14c UStG) sowie Steuerbetr�ge, die nach � 4 Nr. 4a Satz 1 Buchst. a Satz 2, � 6a Abs. 4 Satz 2, � 17 Abs. 1 Satz 6 oder � 25b Abs. 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="center" colspan="1" >69</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz69" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2005')]" >
        <tr>
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerbetr�ge, die vom letzten Abnehmer eines innergemeinschaftlichen Dreiecksgesch�fts geschuldet werden (� 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbetr�ge (� 14c UStG), Steuerbetr�ge f�r Leistungen im Sinne des � 13a Abs. 1 Nr. 6 UStG sowie Steuerbetr�ge, die nach � 6a Abs. 4 Satz 2 oder � 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="center" colspan="1" >69</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz69" />
          </td>
        </tr>
      </xsl:if>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
        <tr>
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerbetr�ge, die vom letzten Abnehmer eines innergemeinschaftlichen Dreiecksgesch�fts geschuldet werden (� 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbetr�ge sowie Steuerbetr�ge, die nach � 6a Abs. 4 Satz 2 oder � 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
          </td>
          <td colspan="2" />
          <td valign="bottom" align="center" colspan="1" >69</td>
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
          <small>Anrechnung (Abzug) der festgesetzten Sondervorauszahlung f�r Dauerfristverl�ngerung (nur auszuf�llen in der letzten Voranmeldung des Besteuerungszeitraums, in der Regel Dezember)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >39</td>
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
          <u>
            <small>
              <b>Verbleibende Umsatzsteuer-Vorauszahlung </b>
            </small>
          </u>
          <br/>
          <small>
            <b>verbleibender �berschuss</b>
          </small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >83</td>
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
            <u>Sonstige Angaben</u>
          </big>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz29" >
        <td align="left" colspan="1" >
          <br/>
          <small>Verrechnung des Erstattungsbetrags erw�nscht/ Erstattungsbetrag ist abgetreten</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >29</td>
        <td valign="bottom" align="left" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz29" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz26" >
        <td align="left" colspan="1" >
          <br/>
          <small>Die Einzugserm�chtigung wird ausnahmsweise (z.B. wegen Verrechnungsw�nschen) f�r diesen Voranmeldungszeitraum widerrufen</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >26</td>
        <td valign="bottom" align="left" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz26" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** stfrUmsVost  ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stfrUmsVost" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerfreie Ums�tze mit Vorsteuerabzug</b>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz41" >
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen (� 4 Nr. 1 Buchst. b UStG) an Abnehmer mit USt-IdNr.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >41</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz41" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz44" >
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge an Abnehmer ohne USt-IdNr.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >44</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz44" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz49" >
        <td align="left" colspan="1" >
          <br/>
          <small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >49</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz49" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz43" >
        <td align="left" colspan="1" >
          <br/>
          <small>Weitere steuerfreie Ums�tze mit Vorsteuerabzug (z.B. Ausfuhrlieferungen, Ums�tze nach � 4 Nr. 2 bis 7 UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >43</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz43" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--********************'stpflUms'  !******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="stpflUms" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerpflichtige Ums�tze</b>
        <br/>
        <small>(Lieferungen und sonstige Leistungen einschl. unentgeltlicher Wertabgaben)</small>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz51" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >51</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz51" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.16 * elster:Kz51, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz81" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 19 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >81</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz81" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.19 * elster:Kz81, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz86" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >86</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz86" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.07 * elster:Kz86, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz35" >
        <td align="left" colspan="1" >
          <br/>
          <small>Ums�tze, die anderen Steuers�tzen unterliegen</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >35</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz35" />
        </td>
        <td valign="bottom" align="center" >36</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz36" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** 'u200513b' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200513b" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
          <u>Ums�tze, f�r die als Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG geschuldet wird</u>
        </big>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz52" >
        <td align="left" colspan="1" >
          <br/>
          <small>Leistungen eines im Ausland ans�ssigen Unternehmers (� 13b Abs. 1 Satz 1 Nr. 1 und 5 UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >52</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz52" />
        </td>
        <td valign="bottom" align="center" >53</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz53" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz73" >
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen sicherungs�bereigneter Gegenst�nde und Ums�tze, die unter das GrEStG fallen (� 13b Abs. 1 Satz 1 Nr. 2 und 3 UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >73</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz73" />
        </td>
        <td valign="bottom" align="center" >74</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz74" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz84" >
        <td align="left" colspan="1" >
          <br/>
          <small>Bauleistungen eines im Inland ans�ssigen Unternehmers  (� 13b Abs. 1 Satz 1 Nr. 4 UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >84</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz84" />
        </td>
        <td valign="bottom" align="center" >85</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz85" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** ''u200413b'' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="u200413b" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Ums�tze, f�r die der Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG schuldet</b>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz54" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >54</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz54" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.16 * elster:Kz54, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz55" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >55</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz55" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.07 * elster:Kz55, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz57" >
        <td align="left" colspan="1" >
          <br/>
          <small>zu anderen Steuers�tzen</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >57</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz57" />
        </td>
        <td valign="bottom" align="center" >58</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz58" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--********************'innergemErwerbe'******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="innergemErwerbe" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Steuerpflichtige innergemeinschaftliche Erwerbe</b>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz97" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 16 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >97</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz97" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.16 * elster:Kz97, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz89" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 19 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >89</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz89" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.19 * elster:Kz89, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz93" >
        <td align="left" colspan="1" >
          <br/>
          <small>zum Steuersatz von 7 v. H.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >93</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz93" />
        </td>
        <td valign="bottom" align="center" colspan="1" >--</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="format-number(0.07 * elster:Kz93, '0.00')" />
	  <sup>*)</sup>
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz95" >
        <td align="left" colspan="1" >
          <br/>
          <small>zu anderen Steuers�tzen</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >95</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz95" />
        </td>
        <td valign="bottom" align="center" >98</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz98" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz94" >
        <td align="left" colspan="1" >
          <br/>
          <small>neuer Fahrzeuge von Lieferern ohne USt-IdNr. zum allgemeinen Steuersatz</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >94</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz94" />
        </td>
        <td valign="bottom" align="center" >96</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz96" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2004')]" >
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz42" >
          <td align="left" colspan="1" >
            <br/>
            <small>Lieferungen des ersten Abnehmers bei innergemeinschaftlichen Dreiecksgesch�ften (� 25b Abs. 2 UStG) </small>
          </td>
          <td valign="bottom" align="center" colspan="1" >42</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz42" />
          </td>
        </xsl:if>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** 'landwUms' !******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="landwUms" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <b>Ums�tze land- und forstwirtschaftlicher Betriebe nach � 24 UStG</b>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz77" >
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen in das �brige Gemeinschaftsgebiet an Abnehmer mit USt-IdNr.</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >77</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz77" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz76" >
        <td align="left" colspan="1" >
          <br/>
          <small>Ums�tze, f�r die eine Steuer nach � 24 UStG zu entrichten ist (S�gewerkserzeugnisse, Getr�nke und alkohol. Fl�ssigkeiten, z.B. Wein)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >76</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz76" />
        </td>
        <td valign="bottom" align="center" >80</td>
        <td valign="bottom" align="right" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz80" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** 'ergAng' ******-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="ergAng" >
    <tr>
      <td align="left" colspan="5" >
        <br/>
        <big>
          <u>Erg�nzende Angaben zu Ums�tzen</u>
        </big>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz42" >
        <td align="left" colspan="1" >
          <br/>
          <small>Lieferungen des ersten Abnehmers  bei innergemeinschaftlichen Dreiecksgesch�ften (� 25b Abs. 2 UStG)</small>
        </td>
        <td valign="bottom" align="center" colspan="1" >42</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz42" />
        </td>
      </xsl:if>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[not(starts-with(.,'2004'))]" >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz60" >
          <td align="left" colspan="1" >
            <br/>
            <small>Steuerpflichtige Ums�tze im Sinne des � 13b Abs. 1 Satz 1 Nr. 1 bis 5 UStG, f�r die der Leistungsempf�nger die Steuer schuldet</small>
          </td>
          <td valign="bottom" align="center" colspan="1" >60</td>
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
            <b>Im Inland nicht steuerbare Ums�tze</b>
          </td>
          <td valign="bottom" align="center" colspan="1" >45</td>
          <td valign="bottom" align="right" colspan="1" >
            <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz45" />
          </td>
        </xsl:if>
      </tr>
    </xsl:if>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Jahr[starts-with(.,'2007')]" >
      <tr>
        <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz45" >
          <td align="left" colspan="1" >
            <br/>
            <b>Nicht steuerbare Ums�tze </b>
            <br/>
						(Leistungsort nicht im Inland)						
					</td>
          <td valign="bottom" align="center" colspan="1" >45</td>
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
          <u>Abziehbare Vorsteuerbetr�ge</u>
        </big>
      </td>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz66" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbetr�ge aus Rechnungen von anderen Unternehmern (� 15 Abs. 1 Satz 1 Nr. 1 UStG), aus Leistungen im Sinne des � 13a Abs. 1 Nr. 6 UStG (� 15 Abs. 1 Satz 1 Nr. 5 UStG) und aus innergemeinschaftlichen Dreiecksgesch�ften (�25b Abs. 5 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >66</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz66" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz61" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbetr�ge aus dem innergemeinschaftlichen Erwerb von Gegenst�nden (� 15 Abs. 1 Satz 1 Nr. 3 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >61</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz61" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz62" >
        <td align="left" colspan="1" >
          <br/>
          <small>Entrichtete Einfuhrumsatzsteuer (� 15 Abs. 1 Satz 1 Nr. 2 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >62</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz62" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz67" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbetr�ge aus Leistungen im Sinne des � 13b Abs. 1 UStG (� 15 Abs. 1 Satz 1 Nr. 4 UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >67</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz67" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz63" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerbetr�ge, die nach allgemeinen Durchschnittss�tzen berechnet sind (�� 23 und 23a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >63</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz63" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz64" >
        <td align="left" colspan="1" >
          <br/>
          <small>Berichtigung des Vorsteuerabzugs (� 15a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >64</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz64" />
        </td>
      </xsl:if>
    </tr>
    <tr>
      <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz59" >
        <td align="left" colspan="1" >
          <br/>
          <small>Vorsteuerabzug f�r innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG) sowie von Kleinunternehmern im Sinne des � 19 Abs. 1 UStG (� 15 Abs. 4a UStG)</small>
        </td>
        <td colspan="2" />
        <td valign="bottom" align="center" colspan="1" >59</td>
        <td valign="bottom" align="right" colspan="1" >
          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz59" />
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
<!--******************** DAUERFRISTVERLAENGERUNG **************** -->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="DV" >
    <br/>
    <hr/>
    <tr>
      <td>
        <br/>
        <b>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">I. Antrag auf Dauerfristverl�ngerung</xsl:text>
        </b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <br/>
        <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			Ich beantrage, die Fristen f�r die Abgabe der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen um einen Monat zu verl�ngern.
			</xsl:text>
      </td>
    </tr>
  </xsl:template>
<!-- ******************* SONDERVORAUSZAHLUNG *********************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="SVZ" >
    <br/>
    <hr/>
    <tr>
      <td>
        <br/>
        <b> I. Antrag auf Dauerfristverl�ngerung </b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <br/>
				Ich beantrage, die Fristen f�r die Abgabe der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen um einen Monat zu verl�ngern.
			</td>
      <br/>
    </tr>
    <tr>
      <td colspan="2" align="center" >- Dieser Abschnitt ist gegenstandslos, wenn bereits Dauerfristverl�ngerung gew�hrt worden ist. -</td>
    </tr>
    <br/>
    <tr>
      <td>
        <br/>
        <br/>
        <br/>
        <b> II. Berechnung und Anmeldung der Sondervorauszahlung auf die Steuer f�r das Kalenderjahr 
				          <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" /> von Unternehmern, die ihre Voranmeldungen monatlich abzugeben haben</b>
      </td>
    </tr>
    <tr>
      <td colspan="2" >
        <table width="645" cellspacing="3" align="right" >
          <tr>
            <td width="80%" />
            <td width="5%" align="center" >Kz</td>
            <td width="15%" align="right" >Betrag</td>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz38" >
              <td align="left" colspan="1" >
                <br/>
                <small>Summe der verbleibenden Umsatzsteuer-Vorauszahlungen zuz�glich der angerechneten Sondervorauszahlung f�r das Kalenderjahr <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="(elster:Jahr)-1" />; davon 1/11 = Sondervorauszahlung <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Jahr" />
                </small>
              </td>
              <td valign="bottom" align="center" colspan="1" >38</td>
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
                    <u>Sonstige Angaben</u>
                  </b>
                </big>
              </td>
            </xsl:if>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz29" >
              <td align="left" colspan="1" >
                <br/>
                <small>Verrechnung des Erstattungsbetrags erw�nscht/ Erstattungsbetrag ist abgetreten</small>
              </td>
              <td valign="bottom" align="center" colspan="1" >29</td>
              <td valign="bottom" align="left" colspan="1" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz29" />
              </td>
            </xsl:if>
          </tr>
          <tr>
            <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz26" >
              <td align="left" colspan="1" >
                <br/>
                <small>Die Einzugserm�chtigung wird ausnahmsweise (z.B. wegen Verrechungsw�nschen) f�r die Sondervorauszahlung dieses Jahres widerrufen.</small>
              </td>
              <td valign="bottom" align="center" colspan="1" >26</td>
              <td valign="bottom" align="left" colspan="1" >
                <xsl:value-of xmlns:xsl="http://www.w3.org/1999/XSL/Transform" select="elster:Kz26" />
              </td>
            </xsl:if>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
<!--****************  Hinweise   **********************-->  <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="Hinweise" >
    <br/>
    <br/>
    <big>
      <hr/>
<!-- ***********************************************************-->      <br/>
      <br/>
      <tr>
        <u>
          <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">Hinweis zu S�umniszuschl�gen</xsl:text>
        </u>
        <br/>
        <br/>
      </tr>
    </big>
    <tr>
      <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		Wird die angemeldete Steuer durch Hingabe eines Schecks beglichen, fallen S�umniszuschl�ge an, wenn dieser nicht am F�lligkeitstag bei der Finanzkasse vorliegt (� 240 Abs.3 Abgabenordnung). 
		Um S�umniszuschl�ge zu vermeiden wird empfohlen, am Lastschriftverfahren teilzunehmen. Die Teilnahme am Lastschriftverfahren ist jederzeit widerruflich und v�llig risikolos. 
		Sollte einmal ein Betrag zu Unrecht abgebucht werden, k�nnen Sie diese Abbuchung bei der Bank innerhalb von 6 Wochen stornieren lassen. 
		Zur Teilnahme am Lastschriftverfahren setzen Sie sich bitte mit Ihrem Finanzamt in Verbindung.
			</xsl:text>
      <br/>
      <br/>
      <br/>
      <br/>
    </tr>
    <tr>
      <b>
        <xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		Dieses �bertragungsprotokoll ist nicht zur �bersendung an das Finanzamt bestimmt. Die Angaben sind auf ihre Richtigkeit hin zu pr�fen.
		Sofern eine Unrichtigkeit festgestellt wird, ist eine berichtigte Steueranmeldung abzugeben.
				</xsl:text>
        <br/>
        <br/>
      </b>
      <br/>
    </tr>
    <xsl:if xmlns:xsl="http://www.w3.org/1999/XSL/Transform" test="elster:Kz51|elster:Kz81|elster:Kz86|elster:Kz54|elster:Kz55|elster:Kz97|elster:Kz89|elster:Kz93" >
      <tr>
	<sup>*)</sup> 
	<xsl:text xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		Dieser Wert wurde arithmetisch ermittelt und nicht an 
		die Finanzbeh�rde �bermittelt.
	</xsl:text>
      </tr>
    </xsl:if>
  </xsl:template>
<!-- ***********************************************************--></xsl:stylesheet>

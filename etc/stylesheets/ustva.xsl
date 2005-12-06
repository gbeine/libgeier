<?xml version="1.0" encoding="ISO-8859-1"?>
<!--Es m�ssen immer mindestens drei Jahre im Stylesheet m�glich sein, wegen der Verzinsung nach � 233a AO. d.h. das aktuelle + die beiden vorangegangenen -->
<!--Beispiel: Voranmeldungen f�r 12/2004 k�nnen bis zum 31.03.2006 abgegeben werden -->
<!-- Version 1.1.0  -->
<xsl:stylesheet xmlns:elster="http://www.elster.de/2002/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
	<xsl:output method="html" indent="yes" encoding="ISO-8859-1"/>
	<xsl:template match="elster:Elster">
		<html>
			<head>
				<title>StylesheetUStVA</title>
			</head>
			<body>
				<table width="645">
				<tr>
					<td align="left">
						<small>�bermittelt von:</small>
					</td>
				</tr>
				<tr>
					<td align="left">
						<small><xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Name"/></small>
					</td>
					<td align="right">
						<xsl:choose>
							<xsl:when test="elster:TransferHeader/elster:EingangsDatum">
								<xsl:text>Eingang auf Server </xsl:text>
								<xsl:apply-templates select="elster:TransferHeader/elster:EingangsDatum"/>
							</xsl:when>
							<xsl:otherwise>Ausdruck vor �bermittlung </xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td align="left">
						<small><xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Strasse"/></small>
					</td>
					<td align="right">
							<xsl:if test="elster:TransferHeader/elster:TransferTicket">
								Transferticket  
								<xsl:value-of select="elster:TransferHeader/elster:TransferTicket"/>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td align="left" colspan="1">
							<small><xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:PLZ"/> �
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Ort"/></small>
						</td>
						<td align="right">
							Erstellungsdatum    
							<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Erstellungsdatum"/>
						</td>
					</tr>
					<tr>
						<td align="left">
							<small><xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Telefon"/></small>
						</td>
					</tr>
					<tr>
						<td align="left">
							<small><xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:DatenLieferant/elster:Email"/>	</small>									</td>
					</tr>
			</table>
			<table width="645">
					<tr>
						<td align="left"><br/>
							<xsl:if test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]">
								<big>*** TESTFALL ***</big>
							</xsl:if>
						</td>
						<td align="center"><br/>
							<xsl:if test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]">
								<big>*** TESTFALL ***</big>
							</xsl:if>
						</td>

						<td align="right"><br/>
							<xsl:if test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]">
								<big>*** TESTFALL ***</big>
							</xsl:if>
						</td>
					</tr> 
				</table>
				<xsl:apply-templates select="//elster:Steuerfall/*"/>
			</body>
		</html>
	</xsl:template>
	<!-- **************** STEUERFALL ********************************* -->
	<xsl:template match="//elster:Steuerfall/*">
		<html>
			<body>
				<table width="645">
					<tr>
						<td align="center" colspan="2">
							<hr/>								<!-- ***********************************************************-->
							<hr/>								<!-- *********************************************************** -->
						</td>
					</tr>
					<tr>
						<td align="left">
							<small>
								<xsl:call-template name="Erstellt_von"/>
							</small>
							<br/>
							<p/>
						</td>
					</tr>
					<tr>
						<td align="left">
							<br/>
							<xsl:if test="substring-after((substring-after(substring-after(substring-after(substring-after(normalize-space(elster:Kz09),'*'),'*'),'*'),'*')),'*')">
							<xsl:text>Unternehmer: </xsl:text>
							</xsl:if>
						</td>
						<td align="right">
							<br/>
							<xsl:call-template name="Steuernummer"/>
						</td>
					</tr>
					<tr>
						<td align="left">
								<xsl:if test="substring-after((substring-after(substring-after(substring-after(substring-after(normalize-space(elster:Kz09),'*'),'*'),'*'),'*')),'*')">
								<xsl:call-template name="Unternehmer"/>
								</xsl:if>
								<br/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<br/>
							<big>
								<p>
									<b>
										<xsl:if test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')">
										Antrag auf Dauerfristverl�ngerung
										</xsl:if>
									</b>
								</p>

								<p>
									<b>
										<xsl:if test="starts-with(local-name(),'Dauerfristverlaengerung')">
											Antrag auf Dauerfristverl�ngerung
										</xsl:if>
										<xsl:if test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')">
											Anmeldung der Sondervorauszahlung
										</xsl:if>
										<xsl:if test="starts-with(local-name(),'Umsatzsteuervoranmeldung')">
											Umsatzsteuer - Voranmeldung
										</xsl:if>
									</b>
								</p>
										<xsl:if test="not(starts-with(local-name(),'Umsatzsteuervoranmeldung'))">
										(�� 46 bis 48 UStDV)
										</xsl:if>
								<p>
									<b>
										<xsl:call-template name="Zeitraum"/>
										<xsl:value-of select="elster:Jahr"/>
									</b>
								</p>
								<br/>
							</big>
						</td>
					</tr>
				</table>
				<table width="645">
					<tr>
						<xsl:call-template name="BearbeitungsKennzahlen"/>
					</tr>
				</table>
				<table width="645">
					<tr>
						<xsl:if test="starts-with(local-name(),'Umsatzsteuervoranmeldung')">
							<xsl:call-template name="UStVA"/>
						</xsl:if>
						<xsl:if test="starts-with(local-name(),'Dauerfristverlaengerung')">
							<xsl:call-template name="DV"/>
						</xsl:if>
						<xsl:if test="starts-with(local-name(),'Umsatzsteuersondervorauszahlung')">
							<xsl:call-template name="SVZ"/>
						</xsl:if>
					</tr>
				</table>
				<table width="645">					
						<xsl:call-template name="Hinweise"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<!--*****    ERSTELLUNGSDATUM    *******************************-->
	<xsl:template match="elster:Erstellungsdatum">
		<xsl:value-of select="substring(.,7)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,5,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	<!--******   EINGANGSDATUM   *******************************-->
	<xsl:template match="elster:TransferHeader/elster:EingangsDatum">
		<xsl:value-of select="substring(.,7,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,5,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
		<xsl:text>,</xsl:text>
		<xsl:value-of select="substring(.,9,2)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(.,11,2)"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="substring(.,13,2)"/>
	</xsl:template>
	<!--*******   ERSTELLT VON   *******************************-->
	<xsl:template name="Erstellt_von">
		<!-- aus Kz09 -->
		<xsl:if test="contains(elster:Kz09,'*')">
			<xsl:if test="not(starts-with(normalize-space(substring-after(elster:Kz09,'*')),'*'))">
				<xsl:text>Erstellt von: </xsl:text>
			</xsl:if>
		</xsl:if>
		�
		<!-- NameBerater -->
		<xsl:value-of select="substring-before(substring-after(elster:Kz09,'*'),'*')"/>
		����
		<!-- Berufsbezeichung -->
		<xsl:value-of select="substring-before((substring-after(substring-after(elster:Kz09,'*'),'*')),'*')"/>
		����
		<!-- Vorwahl -->
		<xsl:value-of select="substring-before(substring-after((substring-after(substring-after(elster:Kz09,'*'),'*')),'*'),'*')"/>
		�
		<!-- Rufnummer -->
		<xsl:value-of select="substring-before(substring-after((substring-after(substring-after(substring-after(elster:Kz09,'*'),'*'),'*')),'*') ,'*')"/>
	</xsl:template>
	<!--****  UNTERNEHMER    *****************-->
	<xsl:template name="Unternehmer">
		<xsl:value-of select="substring-after((substring-after(substring-after(substring-after(substring-after(elster:Kz09,'*'),'*'),'*'),'*')),'*')"/>
	</xsl:template>
	<!--****  STEUERNUMMER    *****************-->
	<xsl:template name="Steuernummer">
		<xsl:text>Steuernummer:  </xsl:text>
		<xsl:if test="elster:Steuernummer[starts-with(.,'10')]">
			<xsl:call-template name="StNr335"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'11')]">
			<xsl:call-template name="StNr235"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'21')]">
			<xsl:call-template name="StNr235a"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'22')]">
			<xsl:call-template name="StNr235"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'23')]">
			<xsl:call-template name="StNr235"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'24')]">
			<xsl:call-template name="StNr235a"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'26')]">
			<xsl:call-template name="StNr0235"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'27')]">
			<xsl:call-template name="StNr2341"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'28')]">
			<xsl:call-template name="StNr55"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'3')]">
			<xsl:call-template name="StNr335"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'4')]">
			<xsl:call-template name="StNr335"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'5')]">
			<xsl:call-template name="StNr344"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'9')]">
			<xsl:call-template name="StNr335"/>
		</xsl:if>
	</xsl:template>
	<!-- Steuernummern formatieren -->
	<xsl:template name="StNr0235">
		<xsl:text>0</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr2341">
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,4)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,13,1)"/>
	</xsl:template>
	<xsl:template name="StNr235">
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr235a">
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr344">
		<xsl:value-of select="substring(elster:Steuernummer,2,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,4)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,10,4)"/>
	</xsl:template>
	<xsl:template name="StNr335">
		<xsl:value-of select="substring(elster:Steuernummer,2,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr55">
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,9,5)"/>
	</xsl:template>
	<!-- Zeitraume aufloesen -->
	<xsl:template name="Zeitraum">
		<xsl:if test="elster:Zeitraum[starts-with(.,'41')]">
			1. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'42')]">
			2. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'43')]">
			3. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'44')]">
			4. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'01')]">
			Januar 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'02')]">
			Februar 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'03')]">
			M�rz  
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'04')]">
			April  
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'05')]">
			Mai 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'06')]">
			Juni 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'07')]">
			Juli 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'08')]">
			August 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'09')]">
			September 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'10')]">
			Oktober 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'11')]">
			November 
		</xsl:if>
		<xsl:if test="elster:Zeitraum[starts-with(.,'12')]">
			Dezember 
		</xsl:if>
	</xsl:template>
	<!-- **************** BearbeitungsKennzahlen ********************************* -->
	<xsl:template name="BearbeitungsKennzahlen">
		<xsl:if test="elster:Kz10 | elster:Kz22 ">		
		<tr>
			<td colspan="2">
				<table align="right" width="645" cellspacing="3">
					<tr>
						<td width="60%"/>
						<td width="15%"/>
						<td width="5%" align="center">Kz</td>
						<td width="20%" align="right">Wert</td>
					</tr>
					<tr>
						<xsl:if test="elster:Kz10">
							<td colspan="1" align="left">
								<br/>
								<xsl:text>  Berichtigte Anmeldung </xsl:text>
							</td>
							<td/>
							<td colspan="1" align="center" valign="bottom">10</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:Kz10"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						
						<xsl:if test="elster:Kz22">
							<td colspan="1" align="left">
								<br/>
								<xsl:text>Belege werden gesondert eingereicht </xsl:text>
							</td>
							<td/>
							<td colspan="1" align="center" valign="bottom">22</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:Kz22"/>
							</td>
						</xsl:if>
					</tr>
				</table>
			</td>
		</tr>
		</xsl:if>
	</xsl:template>
	<!--******************** UStVA *******************************-->
	<xsl:template name="UStVA">
		<br/>
		<hr/>
		<tr colspan="2">
			<td width="50%"/>
			<td width="5%" align="center">Kz</td>
			<td width="20%" align="right">Bemessungsgrundlage</td>
			<td width="5%" align="center">Kz</td>
			<td width="20%" align="right">Steuer</td>
		</tr>
		<tr>
			<td colspan="5" align="left">
				<br/>
				<big>
					<b>
						<u>Anmeldung der Umsatzsteuer - Vorauszahlung</u>
					</b>
				</big>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz41 | elster:Kz44  | elster:Kz49  | elster:Kz43 | elster:Kz48  | elster:Kz51   | elster:Kz86    | elster:Kz35    | elster:Kz36   | elster:Kz77   | elster:Kz76   | elster:Kz80">
				<td colspan="5" align="left">
					<br/>
					<big>
						<u>Lieferungen und sonstige Leistungen (einschl. unentgeltlicher Wertabgaben)</u>
					</big>
				</td>
			</xsl:if>
		</tr>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test=" elster:Kz41 | elster:Kz44  | elster:Kz49    | elster:Kz43">
			<xsl:call-template name="stfrUmsVost"/>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz48">
			<tr>
				<td colspan="5" align="left">
					<br/>
					<b>Steuerfreie Ums�tze ohne Vorsteuerabzug</b>
				</td>
			</tr>
			<tr>
				<td colspan="1" align="left">
					<br/>
					<small>Ums�tze nach � 4 Nr. 8 bis 28 UStG</small>
				</td>
				<td colspan="1" align="center" valign="bottom">48</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select=" elster:Kz48"/>
				</td>
			</tr>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test=" elster:Kz51  | elster:Kz86    | elster:Kz35 | elster:Kz36">
			<xsl:call-template name="stpflUms"/>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz77  | elster:Kz76 | elster:Kz80">
			<xsl:call-template name="landwUms"/>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz91  | elster:Kz97 | elster:Kz93 | elster:Kz95  | elster:Kz94">
			<tr>
				<td colspan="5" align="left">
					<br/>
					<big>
						<u>Innergemeinschaftliche Erwerbe</u>
					</big>
				</td>
			</tr>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz91">
			<xsl:if test="elster:Kz91">
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerfreie innergemeinschaftliche Erwerbe</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:Kz91">
						<td colspan="1" align="left">
							<br/>
							<small>Erwerbe nach � 4b UStG</small>
						</td>
						<td colspan="1" align="center" valign="bottom">91</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:Kz91"/>
						</td>
					</xsl:if>
				</tr>
			</xsl:if>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz97   | elster:Kz93 | elster:Kz95    | elster:Kz94">
			<xsl:call-template name="innergemErwerbe"/>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Jahr[not(starts-with(.,'2004'))]">
			<xsl:if test="elster:Kz42  | elster:Kz60  | elster:Kz45">
				<xsl:call-template name="ergAng"/>
			</xsl:if>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Jahr[starts-with(.,'2004')]">
			<xsl:if test="elster:Kz54   | elster:Kz55  | elster:Kz57">
				<xsl:call-template name="u200413b"/>
			</xsl:if>
			<tr>
				<xsl:if test="elster:Kz45">
					<td colspan="1" align="left">
						<br/>
						<b>Nicht steuerbare Ums�tze</b>
					</td>
					<td colspan="1" align="center" valign="bottom">45</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:Kz45"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Jahr[not(starts-with(.,'2004'))]">
			<xsl:if test="elster:Kz52  | elster:Kz73   | elster:Kz84">
				<xsl:call-template name="u200513b"/>
			</xsl:if>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<tr>
			<xsl:if test="elster:Kz65">
				<td colspan="1" align="left">
					<br/>
					<small>Steuer infolge Wechsels der Besteuerungsart/-form sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerh�hung</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">65</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz65"/>
				</td>
			</xsl:if>
		</tr>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<xsl:if test="elster:Kz66   | elster:Kz61  | elster:Kz62   | elster:Kz67  | elster:Kz63 | elster:Kz64  | elster:Kz59">
			<xsl:call-template name="Vorsteuer"/>
		</xsl:if>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<tr>
			<xsl:if test="elster:Kz69">
				<td colspan="1" align="left">
					<br/>
					<small>Steuerbetr�ge, die vom letzten Abnehmer eines innergemeinschaftlichen Dreiecksgesch�fts geschuldet werden (� 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbetr�ge (� 14 Abs. 2 und 3 UStG) sowie Steuerbetr�ge, die nach � 6a Abs. 4 Satz 2 oder � 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">69</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz69"/>
				</td>
			</xsl:if>
		</tr>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<tr>
			<xsl:if test="elster:Kz39">
				<td colspan="1" align="left">
					<br/>
					<small>Anrechnung (Abzug) der festgesetzten Sondervorauszahlung f�r Dauerfristverl�ngerung (nur auszuf�llen in der letzten Voranmeldung des Besteuerungszeitraums, in der Regel Dezember)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">39</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz39"/>
				</td>
			</xsl:if>
		</tr>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<tr>
			<xsl:if test="elster:Kz83">
				<td colspan="1" align="left">
					<br/>
					<b>Verbleibende Umsatzsteuer-Vorauszahlung bzw. verbleibender �berschuss</b>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">83</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz83"/>
				</td>
			</xsl:if>
		</tr>
		<?XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?>
		<tr>
			<xsl:if test="elster:Kz26">
				<td colspan="5" align="left">
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
			<xsl:if test="elster:Kz29">
				<td colspan="1" align="left">
					<br/>
					<small>Verrechnung des Erstattungsbetrages erw�nscht</small>
				</td>
				<td colspan="1" align="center" valign="bottom">29</td>
				<td colspan="1" align="left" valign="bottom">
					<xsl:value-of select="elster:Kz29"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz26">
				<td colspan="1" align="left">
					<br/>
					<small>Die Einzugserm�chtigung wird ausnahmsweise (z.B. wegen Verrechnungsw�nschen) f�r diesen Voranmeldungszeitraum widerrufen</small>
				</td>
				<td colspan="1" align="center" valign="bottom">26</td>
				<td colspan="1" align="left" valign="bottom">
					<xsl:value-of select="elster:Kz26"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** stfrUmsVost  ******-->
	<xsl:template name="stfrUmsVost">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<b>Steuerfreie Ums�tze mit Vorsteuerabzug</b>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz41">
				<td colspan="1" align="left">
					<br/>
					<small>Innergemeinschaftliche Lieferungen (� 4 Nr. 1 Buchst. b UStG) an Abnehmer mit USt-IdNr.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">41</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz41"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz44">
				<td colspan="1" align="left">
					<br/>
					<small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge an Abnehmer ohne USt-IdNr.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">44</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz44"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz49">
				<td colspan="1" align="left">
					<br/>
					<small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">49</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz49"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz43">
				<td colspan="1" align="left">
					<br/>
					<small>Weitere steuerfreie Ums�tze mit Vorsteuerabzug (z.B. Ausfuhrlieferungen, Ums�tze nach � 4 Nr. 2 bis 7 UStG)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">43</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz43"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--********************'stpflUms'  !******-->
	<xsl:template name="stpflUms">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<b>Steuerpflichtige Ums�tze</b>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz51">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 16 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">51</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz51"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz86">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 7 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">86</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz86"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz35">
				<td colspan="1" align="left">
					<br/>
					<small>Ums�tze, die anderen Steuers�tzen unterliegen</small>
				</td>
				<td colspan="1" align="center" valign="bottom">35</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz35"/>
				</td>
				<td align="center" valign="bottom">36</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz36"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** 'u200513b' ******-->
	<xsl:template name="u200513b">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<big>
					<u>Ums�tze, f�r die als Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG geschuldet wird</u>
				</big>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz52">
				<td colspan="1" align="left">
					<br/>
					<small>Leistungen eines im Ausland ans�ssigen Unternehmers (� 13b Abs. 1 Satz 1 Nr. 1 und 5 UStG)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">52</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz52"/>
				</td>
				<td align="center" valign="bottom">53</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz53"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz73">
				<td colspan="1" align="left">
					<br/>
					<small>Leistungen sicherungs�bereigneter Gegenst�nde und Ums�tze, die unter das GrEStG fallen (� 13b Abs. 1 Satz 1 Nr. 2 und 3 UStG)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">73</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz73"/>
				</td>
				<td align="center" valign="bottom">74</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz74"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz84">
				<td colspan="1" align="left">
					<br/>
					<small>Bauleistungen eines im Inland ans�ssigen Unternehmers  (� 13b Abs. 1 Satz 1 Nr. 4 UStG)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">84</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz84"/>
				</td>
				<td align="center" valign="bottom">85</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz85"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** ''u200413b'' ******-->
	<xsl:template name="u200413b">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<b>Ums�tze, f�r die der Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG schuldet</b>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz54">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 16 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">54</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz54"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz55">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 7 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">55</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz55"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz57">
				<td colspan="1" align="left">
					<br/>
					<small>zu anderen Steuers�tzen</small>
				</td>
				<td colspan="1" align="center" valign="bottom">57</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz57"/>
				</td>
				<td align="center" valign="bottom">58</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz58"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--********************'innergemErwerbe'******-->
	<xsl:template name="innergemErwerbe">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<b>Steuerpflichtige innergemeinschaftliche Erwerbe</b>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz97">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 16 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">97</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz97"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz93">
				<td colspan="1" align="left">
					<br/>
					<small>zum Steuersatz von 7 v. H.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">93</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz93"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz95">
				<td colspan="1" align="left">
					<br/>
					<small>zu anderen Steuers�tzen</small>
				</td>
				<td colspan="1" align="center" valign="bottom">95</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz95"/>
				</td>
				<td align="center" valign="bottom">98</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz98"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz94">
				<td colspan="1" align="left">
					<br/>
					<small>neuer Fahrzeuge von Lieferern ohne USt-IdNr. zum allgemeinen Steuersatz</small>
				</td>
				<td colspan="1" align="center" valign="bottom">94</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz94"/>
				</td>
				<td align="center" valign="bottom">96</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz96"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Jahr[starts-with(.,'2004')]">
				<xsl:if test="elster:Kz42">
					<td colspan="1" align="left">
						<br/>
						<small>Lieferungen des ersten Abnehmers (� 25b Abs. 2 UStG) bei innergemeinschaftlichen Dreiecksgesch�ften</small>
					</td>
					<td colspan="1" align="center" valign="bottom">42</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:Kz42"/>
					</td>
				</xsl:if>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** 'landwUms' !******-->
	<xsl:template name="landwUms">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<b>Ums�tze land- und forstwirtschaftlicher Betriebe nach � 24 UStG</b>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz77">
				<td colspan="1" align="left">
					<br/>
					<small>Lieferungen in das �brige Gemeinschaftsgebiet an Abnehmer mit USt-IdNr.</small>
				</td>
				<td colspan="1" align="center" valign="bottom">77</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz77"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz76">
				<td colspan="1" align="left">
					<br/>
					<small>Ums�tze, f�r die eine Steuer nach � 24 UStG zu entrichten ist (S�gewerkserzeugnisse, Getr�nke und Alkohol. Fl�ssigkeiten, z.B. Wein)</small>
				</td>
				<td colspan="1" align="center" valign="bottom">76</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz76"/>
				</td>
				<td align="center" valign="bottom">80</td>
				<td align="right" valign="bottom">
					<xsl:value-of select="elster:Kz80"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** 'ergAng' ******-->
	<xsl:template name="ergAng">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<big>
					<u>Erg�nzende Angaben zu Ums�tzen</u>
				</big>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz42">
				<td colspan="1" align="left">
					<br/>
					<small>Lieferungen des ersten Abnehmers (� 25b Abs. 2 UStG) bei innergemeinschaftlichen Dreiecksgesch�ften</small>
				</td>
				<td colspan="1" align="center" valign="bottom">42</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz42"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:if test="elster:Jahr[not(starts-with(.,'2004'))]">
			<tr>
				<xsl:if test="elster:Kz60">
					<td colspan="1" align="left">
						<br/>
						<small>Steuerpflichtige Ums�tze im Sinne des � 13b Abs. 1 Satz 1 Nr. 1 bis 5 UStG, f�r die der Leistungsempf�nger die Steuer schuldet</small>
					</td>
					<td colspan="1" align="center" valign="bottom">60</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:Kz60"/>
					</td>
				</xsl:if>
			</tr>
			<tr>
				<xsl:if test="elster:Kz45">
					<td colspan="1" align="left">
						<br/>
						<big>Im Inland nicht steuerbare Ums�tze</big>
					</td>
					<td colspan="1" align="center" valign="bottom">45</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:Kz45"/>
					</td>
				</xsl:if>
			</tr>
		</xsl:if>
	</xsl:template>
	<!--******************** 'Vorsteuer' *****-->
	<xsl:template name="Vorsteuer">
		<tr>
			<td colspan="5" align="left">
				<br/>
				<big>
					<u>Abziehbare Vorsteuerbetr�ge</u>
				</big>
			</td>
		</tr>
		<tr>
			<xsl:if test="elster:Kz66">
				<td colspan="1" align="left">
					<br/>
					<small>Vorsteuerbetr�ge aus Rechnungen von anderen Unternehmern (� 15 Abs. 1 Satz 1 Nr. 1 UStG), aus Leistungen im Sinne des � 13a Abs. 1 Nr. 6 UStG (� 15 Abs. 1 Satz 1 Nr. 5 UStG) und aus innergemeinschaftlichen Dreiecksgesch�ften (�25b Abs. 5 UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">66</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz66"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz61">
				<td colspan="1" align="left">
					<br/>
					<small>Vorsteuerbetr�ge aus dem innergemeinschaftlichen Erwerb von Gegenst�nden (� 15 Abs. 1 Satz 1 Nr. 3 UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">61</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz61"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz62">
				<td colspan="1" align="left">
					<br/>
					<small>Entrichtete Einfuhrumsatzsteuer (� 15 Abs. 1 Satz 1 Nr. 2 UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">62</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz62"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz67">
				<td colspan="1" align="left">
					<br/>
					<small>Vorsteuerbetr�ge aus Leistungen im Sinne des � 13b Abs. 1 UStG (� 15 Abs. 1 Satz 1 Nr. 4 UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">67</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz67"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz63">
				<td colspan="1" align="left">
					<br/>
					<small>Vorsteuerbetr�ge, die nach allgemeinen Durchschnittss�tzen berechnet sind (�� 23 und 23a UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">63</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz63"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz64">
				<td colspan="1" align="left">
					<br/>
					<small>Berichtigung des Vorsteuerbetrags (� 15a UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">64</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz64"/>
				</td>
			</xsl:if>
		</tr>
		<tr>
			<xsl:if test="elster:Kz59">
				<td colspan="1" align="left">
					<br/>
					<small>Vorsteuerabzug f�r innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG) sowie von Kleinunternehmern im Sinne des � 19 Abs. 1 UStG (� 15 Abs. 4a UStG)</small>
				</td>
				<td colspan="2"/>
				<td colspan="1" align="center" valign="bottom">59</td>
				<td colspan="1" align="right" valign="bottom">
					<xsl:value-of select="elster:Kz59"/>
				</td>
			</xsl:if>
		</tr>
	</xsl:template>
	<!--******************** DAUERFRISTVERLAENGERUNG **************** -->
	<xsl:template name="DV">
		<br/>
		<hr/>
		<tr>
			<td><br/>
				<big><xsl:text>I. Antrag auf Dauerfristverl�ngerung</xsl:text>  </big>
			</td>
			
		</tr>
		<tr>
			<td colspan="2"><br/>
			<xsl:text>
			Ich beantrage, die Fristen f�r die Abgaben der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen sowie f�r die Anmeldung und Entrichtung der Umsatzsteuer im Abzugsverfahren um einen Monat zu verl�ngern.
			</xsl:text> 
			
			</td>
		</tr>
	</xsl:template>
	<!-- ******************* SONDERVORAUSZAHLUNG *********************-->
	<xsl:template name="SVZ">
		<br/>
		<hr/>
		<tr>
			<td><br/>
				<big> I. Antrag auf Dauerfristverl�ngerung </big>
			</td>
		</tr>
		<tr>
			<td colspan="2"> <br/>
				Ich beantrage, die Fristen f�r die Abgaben der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen sowie f�r die Anmeldung und Entrichtung der Umsatzsteuer im Abzugsverfahren um einen Monat zu verl�ngern. 
			</td><br/>
		</tr>
		<tr>
			<td align="center" colspan="2">- Dieser Abschnitt ist gegenstandslos, wenn bereits Dauerfristverl�ngerung gew�hrt worden ist. -</td>
		</tr>
		<br/>
		<tr>
			<td>
				<br/>
				<br/>
				<br/>
				<big> II. Berechnung und Anmeldung der Sondervorauszahlung auf die Steuer f�r das Kalenderjahr 
				          <xsl:value-of select="elster:Jahr"/> von Unternehmern, die ihre Voranmeldungen monatlich abzugeben haben</big>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table align="right" width="645" cellspacing="3">
					<tr>
						<td width="80%"/>
						<td width="5%" align="center">Kz</td>
						<td width="15%" align="right">Betrag</td>
					</tr>
					<tr>
						<xsl:if test="elster:Kz38">
							<td colspan="1" align="left">
								<br/>
								<small>Summe der Umsatzsteuer-Vorauszahlungen zuz�glich der Sondervorauszahlung f�r das Kalenderjahr <xsl:value-of select="(elster:Jahr)-1"/>; davon 1/11 = Sondervorauszahlung <xsl:value-of select="elster:Jahr"/>
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">38</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:Kz38"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:Kz29|elster:Kz26">
							<td colspan="5" align="left">
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
						<xsl:if test="elster:Kz29">
							<td colspan="1" align="left">
								<br/>
								<small>Verrechnung des Erstattungsbetrages erw�nscht</small>
							</td>
							<td colspan="1" align="center" valign="bottom">29</td>
							<td colspan="1" align="left" valign="bottom">
								<xsl:value-of select="elster:Kz29"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:Kz26">
							<td colspan="1" align="left">
								<br/>
								<small>Die Einzugserm�chtigung wird ausnahmsweise (z.B. wegen Verrechungsw�nschen) f�r diese Umsatzsteuersondervorauszahlung widerrufen.</small>
							</td>
							<td colspan="1" align="center" valign="bottom">26</td>
							<td colspan="1" align="left" valign="bottom">
								<xsl:value-of select="elster:Kz26"/>
							</td>
						</xsl:if>
					</tr>
				</table>
			</td>
		</tr>
	</xsl:template>
	<!--****************  Hinweise   **********************-->
	<xsl:template name="Hinweise">
		<tr>
		    <td>
	              <br/><br/>
	              <big>
			<hr/>               <!-- ***********************************************************-->
			<br/><br/>
	
			<u><xsl:text>Hinweis zu S�umniszuschl�gen</xsl:text></u>
			<br/><br/>
	              </big>
		    </td>
		</tr>
		<tr>
		    <td>
			<xsl:text>
		Wird die angemeldete Steuer durch Hingabe eines Schecks beglichen, fallen S�umniszuschl�ge an, wenn dieser nicht am F�lligkeitstag bei der Finanzkasse vorliegt (� 240 Abs.3 Abgabenordnung). 
		Um S�umniszuschl�ge zu vermeiden wird empfohlen, am Lastschriftverfahren teilzunehmen. Die Teilnahme am Lastschriftverfahren ist jederzeit widerruflich und v�llig risikolos. 
		Sollte einmal ein Betrag zu Unrecht abgebucht werden, k�nnen Sie diese Abbuchung bei der Bank innerhalb von 6 Wochen stornieren lassen. 
		Zur Teilnahme am Lastschriftverfahren setzen Sie sich bitte mit Ihrem Finanzamt in Verbindung.
			</xsl:text>
			<br/><br/><br/><br/> 
		    </td>
		</tr>
		<tr>
		    <td>
			<big>
				<xsl:text>
		Dieses �bertragungsprotokoll ist nicht zur �bersendung an das Finanzamt bestimmt. Die Angaben sind auf ihre Richtigkeit hin zu pr�fen.
		Sofern eine Unrichtigkeit festgestellt wird, ist eine berichtigte Steueranmeldung abzugeben.
				</xsl:text>
				<br/><br/>
			</big>
			<br/>
		    </td>
		</tr>
	</xsl:template>
	<!-- ***********************************************************-->
</xsl:stylesheet>

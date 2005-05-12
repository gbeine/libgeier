<?xml version="1.0" encoding="ISO-8859-1"?>
<!--Version 2.0 -->
<!--Es m�ssen immer mindestens drei Jahre im Stylesheet m�glich sein, wegen der Verzinsung nach � 233a AO. d.h. das aktuelle + die beiden vorangegangenen -->
<!--Beispiel: Voranmeldungen f�r 12/2004 k�nnen bis zum 31.03.2006 abgegeben werden -->
<xsl:stylesheet version="2.0" xmlns="http://www.elster.de/2002/XMLSchema" xmlns:elster="http://www.elster.de/2002/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="no" encoding="ISO-8859-1"/>
	<xsl:template match="elster:Elster">
		<html>
			<head>
				<title>StylesheetUStVA</title>
			</head>
			<body>
				<table width="645">
					<tr>
						<td align="left">
							<xsl:choose>
								<xsl:when test="elster:TransferHeader/elster:EingangsDatum">
									<xsl:text>Eingang auf Server</xsl:text>
									<xsl:apply-templates select="elster:TransferHeader/elster:EingangsDatum"/>
								</xsl:when>
								<xsl:otherwise>Ausdruck vor �bermittlung </xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td align="left">
							<xsl:if test="elster:TransferHeader/elster:TransferTicket">
								Transferticket  
								<xsl:value-of select="elster:TransferHeader/elster:TransferTicket"/>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<td align="left">
							Erstellungsdatum    
							<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Erstellungsdatum"/>
						</td>
						<td align="right">
							<b>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung">
									<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung"/>
								</xsl:if>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
									<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung"/>
								</xsl:if>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung">
									<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung"/>
								</xsl:if>
							</b>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<br/>
							<big>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung">
									<big>Umsatzsteuer-Voranmeldung</big>
								</xsl:if>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung">
									<big>Antrag auf Dauerfristverl�ngerung</big>
								</xsl:if>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
									<big>Antrag auf Dauerfristverl�ngerung</big>
								</xsl:if>
							</big>
							<br/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<big>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung">
									<big>(�� 46 bis 48 UStDV)</big>
								</xsl:if>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
									<big>Anmeldung zur Sondervorauszahlung</big>
								</xsl:if>
							</big>
							<br/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<big>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
									<big>(�� 46 bis 48 UStDV)</big>
								</xsl:if>
							</big>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:call-template name="Kz09Mandant"/>
							<br/>
						</td>
						<td align="center">
							<br/>
							<b>
								<xsl:call-template name="zeitraum"/>
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Jahr"/>
								<big>
									<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Jahr"/>
								</big>
								<big>
									<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Jahr"/>
								</big>
							</b>
						</td>
					</tr>
					<tr>
						<td>
							<small>
								<xsl:call-template name="Kz09Berater"/>
							</small>
						</td>
						<td align="center">
							<br/>
							<b>
								<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz10">
									Berichtigte Anmeldung
								</xsl:if>
							</b>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:text>________________________________________________________________________________ </xsl:text>
						</td>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung">
							<xsl:call-template name="UStVA"/>
						</xsl:if>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung">
							<xsl:call-template name="DV"/>
						</xsl:if>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
							<xsl:call-template name="SVZ"/>
						</xsl:if>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="DV">
		<tr>
			<td>
				<br/>
				<br/>
				<b> I. Antrag auf Dauerfristverl�gerung </b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Ich beantrage, die Fristen f�r die Abgaben der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen sowie f�r die Anmeldung und Entrichtung der Umsatzsteuer im Abzugsverfahren um einen Monat zu verl�ngern.
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="SVZ">
		<br/>
		<tr>
			<td>
				<br/>
				<br/>
				<b> I. Antrag auf Dauerfristverl�gerung </b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Ich beantrage, die Fristen f�r die Abgaben der Umsatzsteuer-Voranmeldungen und f�r die Entrichtung der Umsatzsteuer-Vorauszahlungen sowie f�r die Anmeldung und Entrichtung der Umsatzsteuer im Abzugsverfahren um einen Monat zu verl�ngern.
			</td>
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
				<b> II. Berechnung und Anmeldung der Sondervorauszahlung auf die Steuer f�r das Kalenderjahr  <xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Jahr"/> von Unternehmern, die ihre Voranmeldungen monatlich abzugeben haben</b>
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
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz38">
							<td colspan="1" align="left">
								<br/>
								<small>Summe der Umsatzsteuer-Vorauszahlungen zuz�glich der Sondervorauszahlung f�r das Kalenderjahr <xsl:value-of select="(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Jahr)-1"/>; davon 1/11 = Sondervorauszahlung <xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Jahr"/>
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">38</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz38"/>
							</td>
						</xsl:if>
					</tr>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="UStVA">
		<td colspan="2">
			<table align="right" width="645" cellspacing="5">
				<tr>
					<td width="50%"/>
					<td width="5%" align="center">Kz</td>
					<td width="20%" align="right">Bemessungsgrundlage</td>
					<td width="5%" align="center">Kz</td>
					<td width="20%" align="center">Steuer</td>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<big>
							<b>
								<u>Anmeldung der Umsatzsteuer-Voranmeldung</u>
							</b>
						</big>
					</td>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<big>
							<u>Lieferungen und sonstige Leistungen (einschl. unentgeltlicher Wertabgaben)</u>
						</big>
					</td>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerfreie Ums�tze mit Vorsteuerabzug</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz41">
						<td colspan="1" align="left">
							<br/>
							<small>Innergemeinschaftliche Lieferungen (� 4 Nr. 1 Buchst. b UStG) an Abnehmer mit USt-IdNr.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">41</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz41"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz44">
						<td colspan="1" align="left">
							<br/>
							<small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge an Abnehmer ohne USt-IdNr.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">44</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz44"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz49">
						<td colspan="1" align="left">
							<br/>
							<small>Innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG)</small>
						</td>
						<td colspan="1" align="center" valign="bottom">49</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz49"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz43">
						<td colspan="1" align="left">
							<br/>
							<small>Weitere steuerfreie Ums�tze mit Vorsteuerabzug (z.B. Ausfuhrlieferungen, Ums�tze nach � 4 Nr. 2 bis 7 UStG)</small>
						</td>
						<td colspan="1" align="center" valign="bottom">43</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz43"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerfreie Ums�tze ohne Vorsteuerabzug</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz48">
						<td colspan="1" align="left">
							<br/>
							<small>Ums�tze nach � 4 Nr. 8 bis 28 UStG</small>
						</td>
						<td colspan="1" align="center" valign="bottom">48</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz48"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerpflichtige Ums�tze</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz51">
						<td colspan="1" align="left">
							<br/>
							<small>zum Steuersatz von 16 v. H.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">51</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz51"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz86">
						<td colspan="1" align="left">
							<br/>
							<small>zum Steuersatz von 7 v. H.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">86</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz86"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz35">
						<td colspan="1" align="left">
							<br/>
							<small>Ums�tze, die anderen Steuers�tzen unterliegen</small>
						</td>
						<td colspan="1" align="center" valign="bottom">35</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz35"/>
						</td>
						<td align="center" valign="bottom">36</td>
						<td align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz36"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Ums�tze land- und forstwirtschaftlicher Betriebe nach � 24 UStG</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz77">
						<td colspan="1" align="left">
							<br/>
							<small>Lieferungen in das �brige Gemeinschaftsgebiet an Abnehmer mit USt-IdNr.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">77</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz77"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz76">
						<td colspan="1" align="left">
							<br/>
							<small>Ums�tze, f�r die eine Steuer nach � 24 UStG zu entrichten ist (S�gewerkserzeugnisse, Getr�nke und alkohol. Fl�ssigkeiten, z.B. Wein)</small>
						</td>
						<td colspan="1" align="center" valign="bottom">76</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz76"/>
						</td>
						<td align="center" valign="bottom">80</td>
						<td align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz80"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<big>
							<u>Innergemeinschaftliche Erwerbe</u>
						</big>
					</td>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerfreie innergemeinschaftliche Erwerbe</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz91">
						<td colspan="1" align="left">
							<br/>
							<small>Erwerbe nach � 4b UStG</small>
						</td>
						<td colspan="1" align="center" valign="bottom">91</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz91"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<b>Steuerpflichtige innergemeinschaftliche Erwerbe</b>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz97">
						<td colspan="1" align="left">
							<br/>
							<small>zum Steuersatz von 16 v. H.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">97</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz97"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz93">
						<td colspan="1" align="left">
							<br/>
							<small>zum Steuersatz von 7 v. H.</small>
						</td>
						<td colspan="1" align="center" valign="bottom">93</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz93"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz95">
						<td colspan="1" align="left">
							<br/>
							<small>zu anderen Steuers�tzen</small>
						</td>
						<td colspan="1" align="center" valign="bottom">95</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz95"/>
						</td>
						<td align="center" valign="bottom">98</td>
						<td align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz98"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz94">
						<td colspan="1" align="left">
							<br/>
							<small>neuer Fahrzeuge von Lieferern ohne USt-IdNr. zum allgemeinen Steuersatz</small>
						</td>
						<td colspan="1" align="center" valign="bottom">94</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz94"/>
						</td>
						<td align="center" valign="bottom">96</td>
						<td align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz96"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(Jahr,'2005')]">
						<td colspan="5" align="left">
							<br/>
							<b>Erg�nzende Angaben zu Ums�tzen</b>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz42">
						<td colspan="1" align="left">
							<br/>
							<small>Lieferungen des ersten Abnehmers (� 25b Abs. 2 UStG) bei innergemeinschaflichen Dreiecksgesch�ften</small>
						</td>
						<td colspan="1" align="center" valign="bottom">42</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz42"/>
						</td>
					</xsl:if>
				</tr>
				<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Jahr[starts-with(.,'2005')]">
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz60">
							<td colspan="1" align="left">
								<br/>
								<small>Steuerpflichtige Ums�tze im Sinne des � 13b Abs. 1 Satz 1 Nr. 1 bis 5 UStG, f�r die der Leistungsempf�nger die Steuer schuldet</small>
							</td>
							<td colspan="1" align="center" valign="bottom">60</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz60"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz45">
							<td colspan="1" align="left">
								<br/>
								<small>Nicht steuerbare Ums�tze</small>
							</td>
							<td colspan="1" align="center" valign="bottom">45</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz45"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Jahr[starts-with(.,'2004')]">
					<tr>
						<td colspan="5" align="left">
							<br/>
							<b>Ums�tze, f�r die der Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG schuldet</b>
						</td>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz54">
							<td colspan="1" align="left">
								<br/>
								<small>zum Steuersatz von 16 v. H.</small>
							</td>
							<td colspan="1" align="center" valign="bottom">54</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz54"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz55">
							<td colspan="1" align="left">
								<br/>
								<small>zum Steuersatz von 7 v. H.</small>
							</td>
							<td colspan="1" align="center" valign="bottom">55</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz55"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz57">
							<td colspan="1" align="left">
								<br/>
								<small>zu anderen Steuers�tzen</small>
							</td>
							<td colspan="1" align="center" valign="bottom">57</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz57"/>
							</td>
							<td align="center" valign="bottom">58</td>
							<td align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz58"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz45">
							<td colspan="1" align="left">
								<br/>
								<b>Nicht steuerbare Ums�tze</b>
							</td>
							<td colspan="1" align="center" valign="bottom">45</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz45"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Jahr[starts-with(.,'2005')]">
					<tr>
						<td colspan="5" align="left">
							<br/>
							<b>Ums�tze, f�r die der Leistungsempf�nger die Steuer nach � 13b Abs. 2 UStG schuldet</b>
						</td>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz52">
							<td colspan="1" align="left">
								<br/>
								<small>Leistungen eines im Ausland ans�ssigen Unternehmers (� 13b Abs. 1 Satz 1 Nr. 1 und 5 UStG)</small>
							</td>
							<td colspan="1" align="center" valign="bottom">52</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz52"/>
							</td>
							<td align="center" valign="bottom">53</td>
							<td align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz53"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz73">
							<td colspan="1" align="left">
								<br/>
								<small>Leistungen sicherungs�bereigneter Gegenst�nde und Ums�tze, die unter das GrEStG fallen (� 13b Abs. 1 Satz 1 Nr. 2 und 3 UStG)</small>
							</td>
							<td colspan="1" align="center" valign="bottom">73</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz73"/>
							</td>
							<td align="center" valign="bottom">74</td>
							<td align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz74"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz84">
							<td colspan="1" align="left">
								<br/>
								<small>Bauleistungen eines im Inland ans�ssigen Unternehmers  (� 13b Abs. 1 Satz 1 Nr. 4 UStG)</small>
							</td>
							<td colspan="1" align="center" valign="bottom">84</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz84"/>
							</td>
							<td align="center" valign="bottom">85</td>
							<td align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz85"/>
							</td>
						</xsl:if>
					</tr>
				</xsl:if>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz65">
						<td colspan="1" align="left">
							<br/>
							<small>Steuer infolge Wechsels der Besteuerungsart/-form sowie Nachsteuer auf versteuerte Anzahlungen wegen Steuersatzerh�hung</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">65</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz65"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<td colspan="5" align="left">
						<br/>
						<big>
							<u>Abziehbare Vorsteuerbetr�ge</u>
						</big>
					</td>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz66">
						<td colspan="1" align="left">
							<br/>
							<small>Vorsteuerbetr�ge aus Rechnungen von anderen Unternehmern (� 15 Abs. 1 Satz 1 Nr. 1 UStG), aus Leistungen im Sinne des � 13a Abs. 1 Nr. 6 UStG (� 15 Abs. 1 Satz 1 Nr. 5 UStG) und aus innergemeinschaftlichen Dreiecksgesch�ften (�25b Abs. 5 UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">66</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz66"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz61">
						<td colspan="1" align="left">
							<br/>
							<small>Vorsteuerbetr�ge aus dem innergemeinschaftlichen Erwerb von Gegenst�nden (� 15 Abs. 1 Satz 1 Nr. 3 UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">61</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz61"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz62">
						<td colspan="1" align="left">
							<br/>
							<small>Entrichtete Einfuhrumsatzsteuer (� 15 Abs. 1 Satz 1 Nr. 2 UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">62</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz62"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz67">
						<td colspan="1" align="left">
							<br/>
							<small>Vorsteuerbetr�ge aus Leistungen im Sinne des � 13b Abs. 1 UStG (� 15 Abs. 1 Satz 1 Nr. 4 UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">67</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz67"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz63">
						<td colspan="1" align="left">
							<br/>
							<small>Vorsteuerbetr�ge, die nach allgemeinen Durchschnittss�tzen berechnet sind (�� 23 und 23a UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">63</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz63"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz64">
						<td colspan="1" align="left">
							<br/>
							<small>Berichtigung des Vorsteuerbetrags (� 15a UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">64</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz64"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz59">
						<td colspan="1" align="left">
							<br/>
							<small>Vorsteuerabzug f�r innergemeinschaftliche Lieferungen neuer Fahrzeuge au�erhalb eines Unternehmens (� 2a UStG) sowie von Kleinunternehmern im Sinne des � 19 Abs. 1 UStG (� 15 Abs. 4a UStG)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">59</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz59"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz69">
						<td colspan="1" align="left">
							<br/>
							<small>Steuerbetr�ge, die vom letzten Abnehmer eines innergemeinschafltichen Dreiecksgesch�fts geschuldet werden (� 25b Abs. 2 UStG), in Rechnungen unrichtig oder unberechtigt ausgewiesene Steuerbetr�ge (� 14 Abs. 2 und 3 UStG) sowie Steuerbetr�ge, die nach � 6a Abs. 4 Satz 2 oder � 17 Abs. 1 Satz 2 UStG geschuldet werden</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">69</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz69"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz39">
						<td colspan="1" align="left">
							<br/>
							<small>Anrechnung (Abzug) der festgesetzten Sondervorauszahlung f�r Dauerfristverl�ngerung (nur auszuf�llen in der letzten Voranmeldung des Besteuerungszeitraums, in der Regel Dezember)</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">39</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz39"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz83">
						<td colspan="1" align="left">
							<br/>
							<small>Verbleibende Umsatzsteuer-Vorauszahlung bzw. verbleibender �berschuss</small>
						</td>
						<td colspan="2"/>
						<td colspan="1" align="center" valign="bottom">83</td>
						<td colspan="1" align="right" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz83"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz29|elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz26">
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
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz29">
						<td colspan="1" align="left">
							<br/>
							<small>Verrechnung des Erstattungsbetrages erw�nscht</small>
						</td>
						<td colspan="1" align="center" valign="bottom">29</td>
						<td colspan="1" align="left" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz29"/>
						</td>
					</xsl:if>
				</tr>
				<tr>
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz26">
						<td colspan="1" align="left">
							<br/>
							<small>Die Einzugserm�chtigung wird ausnahmsweise (z.B. wegen Verrrechungsw�nschen) f�r diesen Voranmeldungszeitraum widerrufen</small>
						</td>
						<td colspan="1" align="center" valign="bottom">26</td>
						<td colspan="1" align="left" valign="bottom">
							<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz26"/>
						</td>
					</xsl:if>
				</tr>
			</table>
		</td>
	</xsl:template>
	<xsl:template match="elster:Erstellungsdatum">
		<xsl:value-of select="substring(.,7)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,5,2)"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
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
	<xsl:template match="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung">
		<xsl:call-template name="SteuerNr"/>
	</xsl:template>
	<xsl:template match="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung">
		<xsl:call-template name="SteuerNr"/>
	</xsl:template>
	<xsl:template match="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung">
		<xsl:call-template name="SteuerNr"/>
	</xsl:template>
	<xsl:template name="SteuerNr">
		<xsl:text>Steuernummer:  </xsl:text>
		<xsl:if test="elster:Steuernummer[starts-with(.,'10')]">
			<xsl:call-template name="StNr335"/>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'11')]">
			<xsl:call-template name="StNr234"/>
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
	<xsl:template name="StNr234">
		<xsl:value-of select="substring(elster:Steuernummer,3,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring(elster:Steuernummer,10,4)"/>
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
	<xsl:template name="zeitraum">
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'41')]">
			1. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'42')]">
			2. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'43')]">
			3. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'44')]">
			4. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'01')]">
			Januar 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'02')]">
			Februar 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'03')]">
			M�rz  
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'04')]">
			April  
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'05')]">
			Mai 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'06')]">
			Juni 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'07')]">
			Juli 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'08')]">
			August 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'09')]">
			September 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'10')]">
			Oktober 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'11')]">
			November 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung[starts-with(elster:Zeitraum,'12')]">
			Dezember 
		</xsl:if>
	</xsl:template>
	<xsl:template name="Kz09Mandant">
		<!-- Name Mandant -->
		<xsl:text>Unternehmer:</xsl:text>
		<br/>
		<xsl:value-of select="substring-after(
									(substring-after(
									 	substring-after(
									 		substring-after(
									 			substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz09,'*')
									 		,'*')
									 	,'*')
									,'*'))
								,'*')"/>
		<xsl:value-of select="substring-after(
									(substring-after(
									 	substring-after(
									 		substring-after(
									 			substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Kz09,'*')
									 		,'*')
									 	,'*')
									,'*'))
								,'*')"/>
		<xsl:value-of select="substring-after(
									(substring-after(
									 	substring-after(
									 		substring-after(
									 			substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz09,'*')
									 		,'*')
									 	,'*')
									,'*'))
								,'*')"/>
		<br/>
	</xsl:template>
	<xsl:template name="Kz09Berater">
		<!-- NameBerater -->
		<br/>
		<xsl:text>Erstellt von: </xsl:text>
		<br/>
		<xsl:value-of select="substring-before(
									substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz09,'*')
								,'*')"/>
		<xsl:value-of select="substring-before(
									substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Kz09,'*')
								,'*')"/>
		<xsl:value-of select="substring-before(
									substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz09,'*')
								,'*')"/>
		<br/>
		<!-- Berufsbezeichung -->
		<xsl:value-of select="substring-before(
									(substring-after(
									 	substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz09,'*')
									,'*'))
								,'*')"/>
		<xsl:value-of select="substring-before(
									(substring-after(
									 	substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Kz09,'*')
									,'*'))
								,'*')"/>
		<xsl:value-of select="substring-before(
									(substring-after(
									 	substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz09,'*')
									,'*'))
								,'*')"/>
		<br/>
		<!-- Vorwahl -->
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
									 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz09,'*')
										,'*'))
									,'*')
								,'*')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
									 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Kz09,'*')
										,'*'))
									,'*')
								,'*')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
									 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz09,'*')
										,'*'))
									,'*')
								,'*')"/>
		<xsl:text> </xsl:text>
		<!-- Rufnummer -->
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
										 	substring-after(
										 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuervoranmeldung/elster:Kz09,'*')
										 	,'*')
										,'*'))
									,'*')
								 ,'*')"/>
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
										 	substring-after(
										 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Dauerfristverlaengerung/elster:Kz09,'*')
										 	,'*')
										,'*'))
									,'*')
								 ,'*')"/>
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
										 	substring-after(
										 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Umsatzsteuersondervorauszahlung/elster:Kz09,'*')
										 	,'*')
										,'*'))
									,'*')
								 ,'*')"/>
	</xsl:template>
</xsl:stylesheet>

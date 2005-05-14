<?xml version="1.0" encoding="ISO-8859-1"?>
<!--Version 2.0 -->
<xsl:stylesheet version="2.0" xmlns="http://www.elster.de/2002/XMLSchema" xmlns:elster="http://www.elster.de/2002/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="no" encoding="ISO-8859-1"/>
	<xsl:template match="elster:Elster">
		<html>
			<head>
				<title>StylesheetLStA</title>
			</head>
			<body>
				<table width="645">
					<xsl:call-template name="tabelle1"/>
					<tr>
						<xsl:call-template name="LStA"/>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="tabelle1">
		<tr>
			<td align="left">
				<xsl:choose>
					<xsl:when test="elster:TransferHeader/elster:EingangsDatum">
						<xsl:text>Eingang auf Server</xsl:text>
						<xsl:apply-templates select="elster:TransferHeader/elster:EingangsDatum"/>
					</xsl:when>
					<xsl:otherwise>Ausdruck vor Übermittlung </xsl:otherwise>
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
			<td>Erstellungsdatum
				<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Erstellungsdatum"/>
			</td>
			<td align="right">
				<b>
					<xsl:apply-templates select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung"/>
				</b>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<br/>
				<big>
					<big>Lohnsteuer-Anmeldung</big>
				</big>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<xsl:if test="elster:TransferHeader[starts-with(elster:Testmerker,'7')]">
					<big>
						<br/>
						<big>*** TESTFALL ***</big>
					</big>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
				<xsl:call-template name="Kz09Mandant"/>
				<br/>
			</td>
			<td align="center">
				<br/>
				<b>
					<xsl:call-template name="zeitraum"/>
					<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Jahr"/>
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
					<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz10[starts-with(.,'1')]">
									Berichtigte Anmeldung
					</xsl:if>
				</b>
				<br/>
				<br/>
				<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz86">
									Zahl der beschäftigten Arbeitnehmer: <xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz86"/>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<xsl:text>________________________________________________________________________________ </xsl:text>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="LStA">
		<br/>
		<tr>
			<td colspan="2">
				<table align="right" width="645" cellspacing="3">
					<tr>
						<td width="70%"/>
						<td width="5%" align="center">Kz</td>
						<td width="25%" align="center">Betrag</td>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz42">
							<td colspan="1" align="left">
								<br/>
								<small>Lohnsteuer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">42</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz42"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz43">
							<td colspan="1" align="left">
								<br/>
								<small>abzüglich an Arbeitnehmer ausgezahltes Kindergeld
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">43</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz43"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz46">
							<td colspan="1" align="left">
								<br/>
								<small>abzüglich an Arbeitnehmer ausgezahlte Bergmannsprämien
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">46</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz46"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz33">
							<td colspan="1" align="left">
								<br/>
								<small>abzüglich Kürzungsbetrag für Besatzungsmitglieder von Handelsschiffen
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">33</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz33"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz48">
							<td colspan="1" align="left">
								<br/>
								<small>
									<b>verbleiben</b>
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">48</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz48"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz49">
							<td colspan="1" align="left">
								<br/>
								<small>Solidaritätszuschlag
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">49</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz49"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz61">
							<td colspan="1" align="left">
								<br/>
								<small>Evangelische Kirchensteuer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">61</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz61"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz62">
							<td colspan="1" align="left">
								<br/>
								<small>Römisch-Katholische Kirchensteuer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">62</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz62"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz63">
							<td colspan="1" align="left">
								<br/>
								<small>Altkatholische Kirchensteuer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">63</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz63"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz64">
							<xsl:call-template name="Kz64"/>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz65">
							<td colspan="1" align="left">
								<br/>
								<small>Freireligiöse Gemeinde Mainz
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">65</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz65"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz66">
							<td colspan="1" align="left">
								<br/>
								<small>Freireligiöse Gemeinde Offenbach/M.
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">66</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz66"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz67">
							<td colspan="1" align="left">
								<br/>
								<small>Kirchensteuer der Freireligiösen Landesgemeinde Baden
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">67</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz67"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz68">
							<xsl:call-template name="Kz68"/>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz69">
							<td colspan="1" align="left">
								<br/>
								<small>Beiträge zur Angestelltenkammer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">69</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz69"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz70">
							<td colspan="1" align="left">
								<br/>
								<small>Beiträge zur Arbeitskammer
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">70</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz70"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz72">
							<td colspan="1" align="left">
								<br/>
								<small>Freie Religionsgemeinschaft Alzey
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">72</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz72"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz73">
							<td colspan="1" align="left">
								<br/>
								<small>Kirchensteuer der Israelitischen Religionsgemeinschaft Württembergs
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">73</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz73"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz74">
							<td colspan="1" align="left">
								<br/>
								<small>Israelitische Kultussteuer der kultusberechtigten Gemeinden
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">74</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz74"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz76">
							<td colspan="1" align="left">
								<br/>
								<small>
									Kirchensteuer-lt/rf (ev)
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">76</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz76"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz77">
							<td colspan="1" align="left">
								<br/>
								<small>
									Kirchensteuer-rk/ak
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">77</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz77"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz78">
							<td colspan="1" align="left">
								<br/>
								<small>Kirchensteuer der Israelischen Religionsgemeinschaft Baden
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">78</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz78"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz83">
							<td colspan="1" align="left">
								<br/>
								<small>
									<b>Gesamtbetrag</b>
								</small>
							</td>
							<td colspan="1" align="center" valign="bottom">83</td>
							<td colspan="1" align="right" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz83"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz29										   |elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz26">
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
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz29">
							<td colspan="1" align="left">
								<br/>
								<small>Verrechnung des Erstattungsbetrages erwünscht</small>
							</td>
							<td colspan="1" align="center" valign="bottom">29</td>
							<td colspan="1" align="left" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz29"/>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz26">
							<td colspan="1" align="left">
								<br/>
								<small>Die Einzugsermächtigung wird ausnahmsweise (z.B. wegen Verrrechungswünschen) für diesen Voranmeldungszeitraum widerrufen</small>
							</td>
							<td colspan="1" align="center" valign="bottom">26</td>
							<td colspan="1" align="left" valign="bottom">
								<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz26"/>
							</td>
						</xsl:if>
					</tr>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung">
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
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'41')]">
			1. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'42')]">
			2. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'43')]">
			3. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'44')]">
			4. Vierteljahr 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'01')]">
			Januar 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'02')]">
			Februar 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'03')]">
			März  
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'04')]">
			April  
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'05')]">
			Mai 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'06')]">
			Juni 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'07')]">
			Juli 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'08')]">
			August 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'09')]">
			September 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'10')]">
			Oktober 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'11')]">
			November 
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung[starts-with(elster:Zeitraum,'12')]">
			Dezember 
		</xsl:if>
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
	<xsl:template name="Kz09Mandant">
		<!-- Name Mandant -->
		<xsl:text>Unternehmer:</xsl:text>
		<br/>
		<xsl:value-of select="substring-after(
									(substring-after(
									 	substring-after(
									 		substring-after(
									 			substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz09,'*')
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
									substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz09,'*')
								,'*')"/>
		<br/>
		<!-- Berufsbezeichung -->
		<xsl:value-of select="substring-before(
									(substring-after(
									 	substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz09,'*')
									,'*'))
								,'*')"/>
		<br/>
		<!-- Vorwahl -->
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
									 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz09,'*')
										,'*'))
									,'*')
								,'*')"/>
		<xsl:text> </xsl:text>
		<xsl:text> </xsl:text>
		<!-- Rufnummer -->
		<xsl:value-of select="substring-before(
									substring-after(
										(substring-after(
										 	substring-after(
										 		substring-after(elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz09,'*')
										 	,'*')
										,'*'))
									,'*')
								 ,'*')"/>
	</xsl:template>
	<xsl:template name="Kz64">
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'9')]">
			<td colspan="1" align="left">
				<br/>
				<small>
				Israelitische Bekenntnissteuer
				<td colspan="1" align="center" valign="bottom">64</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz64"/>
					</td>
				</small>
			</td>
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'26')]">
			<td colspan="1" align="left">
				<br/>
				<small>
				Israelitische Kultussteuer Frankfurt
				<td colspan="1" align="center" valign="bottom">64</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz64"/>
					</td>
				</small>
			</td>
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'10')]">
			<td colspan="1" align="left">
				<br/>
				<small>

				Israelitische Kultussteuer
				<td colspan="1" align="center" valign="bottom">64</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz64"/>
					</td>
				</small>
			</td>
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'27')]|
					   elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'5')]">
			<td colspan="1" align="left">
				<br/>
				<small>
				Jüdische Kultussteuer
				<td colspan="1" align="center" valign="bottom">64</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz64"/>
					</td>
				</small>
			</td>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Kz68">
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'24')]">
			<td colspan="1" align="left">
				<br/>
				<small>
					Beiträge zur Arbeitnehmerkammer
					<td colspan="1" align="center" valign="bottom">68</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz68"/>
					</td>
				</small>
			</td>
		</xsl:if>
		<xsl:if test="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Steuernummer[starts-with(.,'27')]">
			<td colspan="1" align="left">
				<br/>
				<small>
					Freireligiöse Landesgemeinde Pfalz
					<td colspan="1" align="center" valign="bottom">68</td>
					<td colspan="1" align="right" valign="bottom">
						<xsl:value-of select="elster:DatenTeil/elster:Nutzdatenblock/elster:Nutzdaten/elster:Anmeldungssteuern/elster:Steuerfall/elster:Lohnsteueranmeldung/elster:Kz68"/>
					</td>
				</small>
			</td>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

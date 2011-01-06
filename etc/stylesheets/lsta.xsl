<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Version 2.0 -->
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:elster="http://www.elster.de/2002/XMLSchema" 
		exclude-result-prefixes="elster">
	<xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" doctype-system="http://www.w3.org/TR/html4/loose.dtd"/>
	<xsl:include href="elsteranmeldung.xsl" />
	<xsl:include href="geldbetraege.xsl" />

	<xsl:template match="elster:Elster"> 
		<html>
			<head>
				<title>
					<xsl:call-template name="Titel" />
				</title>
				<style type="text/css">
					<xsl:text>
                  body {
                  	font-family: Helvetica, Arial, sans-serif;
                  	font-size: 0.85em;
                  	word-wrap: break-word;
                  }
                  
                  #content {
                  	font-size: 0.99em;
                  	width: 46em;
                  	margin-left: 0.5em;
                  }
                  
                  h1 {
                  	font-size: 1.2em;
                  	page-break-after:avoid;
                  }
                  
                  h2 {
                  	font-size: 1.1em;
                  	page-break-after:avoid;
                  }
                  
                  table {
                  	width: 100%;
                  	table-layout: fixed;
                   	page-break-inside:avoid;
                  }
                  table,td,th{
                      border-collapse:collapse;
                      border:1px solid #AAAAAA;
                    }
                  td,th {
                  	padding: 2px;
                    padding-left:0.3em;
                	font-weight:normal;
                	vertical-align: bottom;
                  }
                  
                  td.kz {
                  	padding: 0px;
                  	font-style: normal;
                  	font-size: 1em;
                  }
                  
                  small {
                  	padding: 0px;
                  	font-style: normal;
                  	font-size: 0.8em;
                  	line-height: 1.6em;
                  }
                  
                  strong {
                  	padding: 0px;
                  	font-weight: bold;
                  	font-size: 1em;
                  }
                  
                  div.left,p.left,table.left {
                  	margin-top: 0;
                  	width: 49%;
                  	float: left;
                  	text-align: left;
                  }
                  
                  div.right,p.right,table.right {
                  	margin-top: 0;
                  	width: 49%;
                  	float: right;
                  	text-align: right;
                  }
                  
                  #content .alRight {
                  	text-align: right;
                  }
                  
                  #content .alLeft {
                  	text-align: left;
                  }
                  
                  #content .alCenter {
                  	text-align: center;
                  }
                  
                  div.clear {
                  	height: 1px;
                  	margin: 0;
                  	padding: 0;
                  	clear: both;
                  }
                  
                  hr {
                  	clear: both;
                  }
                  
                  .indent {
                  	margin-left: 2em;
                  }
                  
                  .help {
                  	cursor: help;
                  }
                  </xsl:text>
				</style>
			</head>

			<body>
				<div id="content">
					<p class="left">
						<xsl:call-template name="Uebermittelt_von" />
					</p>

					<p class="right">
						<xsl:call-template name="Transferdaten" />
					</p>

					<xsl:call-template name="testfall" />

					<hr />
					
					<xsl:call-template name="ElsterInfoMitTrennlinie" />

					<xsl:if test="//elster:Berater | //elster:Mandant | //elster:Unternehmer">
						<xsl:call-template name="Berater_Mandant_Unternehmer" />
					</xsl:if>

					<xsl:apply-templates select="//elster:Steuerfall/elster:Lohnsteueranmeldung" />
				</div>
			</body>
		</html>
	</xsl:template>

	<!-- **************** STEUERFALL ********************************* -->
	<xsl:template match="//elster:Steuerfall/*">

		<xsl:call-template name="ErstelltVon" />

		<xsl:if test="substring-after((substring-after(substring-after(substring-after(substring-after(normalize-space(elster:Kz09),'*'),'*'),'*'),'*')),'*')">
			<xsl:call-template name="Kz09_Unternehmer" />
		</xsl:if>

		<xsl:call-template name="Steuernummer" />

		<div class="clear"></div>

		<div class="alCenter">
			<h1>
				<xsl:call-template name="Titel" />
				<br />
				<xsl:call-template name="Zeitraum" />
				<xsl:text>&#160;</xsl:text>
				<xsl:value-of select="elster:Jahr" />
			</h1>
		</div>
		<xsl:call-template name="BearbeitungsKennzahlen" />
		
		<xsl:call-template name="LStA" />
		<hr />

		<h2>Hinweis zu Säumniszuschlägen</h2>
		<xsl:call-template name="Hinweis_zu_Saeumniszuschlaegen" />

	</xsl:template>

	<!--****  UNTERNEHMER    *****************-->
	<xsl:template name="Kz09_Unternehmer">
		<p class="left">
			<xsl:text>Unternehmer: </xsl:text>
			<br />
			<xsl:value-of select="substring-after((substring-after(substring-after(substring-after(substring-after(elster:Kz09,'*'),'*'),'*'),'*')),'*')" />
		</p>
	</xsl:template>

	<xsl:template name="Titel">
		<xsl:text>Lohnsteuer-Anmeldung</xsl:text>
	</xsl:template>

	<!-- **************** BearbeitungsKennzahlen ********************************* -->
	<xsl:template name="BearbeitungsKennzahlen">
		<table cellspacing="3">
			<tr>
				<td style="width: 70%"></td>
				<th style="width: 5%" class="alCenter">
					<abbr title="Kennziffer" class="help">Kz</abbr>
				</th>
				<th style="width: 25%" class="alRight">Wert</th>
			</tr>
			<xsl:if test="elster:Kz10">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>Berichtigte Anmeldung </xsl:text>
					</th>

					<td class="alCenter">10</td>
					<td class="alRight">
						<xsl:value-of select="elster:Kz10" />
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz86">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>Zahl der Arbeitnehmer</xsl:text>
					</th>
					<td class="alCenter">86</td>
					<td class="alRight">
						<xsl:value-of select="elster:Kz86" />
					</td>
				</tr>
			</xsl:if>
		</table>
		<hr />
	</xsl:template>

	<!-- **************** LStA ********************************* -->
	<xsl:template name="LStA">
		<table>
			<tr>
				<td style="width: 70%"></td>
				<th style="width: 5%" class="alCenter">
					<abbr title="Kennziffer" class="help">Kz</abbr>
				</th>
				<th style="width: 25%" class="alRight">Betrag</th>
			</tr>
			<xsl:choose>
				<xsl:when test="elster:Jahr[starts-with(.,'2004')]|elster:Jahr[starts-with(.,'2005')]|elster:Jahr[starts-with(.,'2006')]">
					<tr>
						<xsl:if test="elster:Kz42">
							<th scope="row" class="alLeft">
								<br />
								<xsl:text>Lohnsteuer</xsl:text>
							</th>
							<td class="alCenter">42</td>
							<td class="alRight">
								<xsl:call-template name="formatiereGeldbetrag">
									<xsl:with-param name="betrag" select="//elster:Kz42"/>
								</xsl:call-template>
							</td>
						</xsl:if>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<xsl:if test="elster:Kz42">
							<th scope="row" class="alLeft">
								<br />
								<xsl:choose>									
									<xsl:when test="elster:Jahr[starts-with(.,'2007')]|elster:Jahr[starts-with(.,'2008')]">
										<xsl:text>Summe der einzubehaltenen Lohnsteuer</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<!-- ab 2009 -->
										<xsl:text>Summe der einzubehaltenden Lohnsteuer</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</th>
							<td class="alCenter">42</td>
							<td class="alRight">
								<xsl:call-template name="formatiereGeldbetrag">
									<xsl:with-param name="betrag" select="//elster:Kz42"/>
								</xsl:call-template>
							</td>
						</xsl:if>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="elster:Kz41">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:choose>
							<xsl:when test="elster:Jahr[starts-with(.,'2004')]|elster:Jahr[starts-with(.,'2005')]|elster:Jahr[starts-with(.,'2006')]|elster:Jahr[starts-with(.,'2007')]|elster:Jahr[starts-with(.,'2008')]">
								<xsl:text>Summe der pauschalen Lohnsteuer</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<!-- ab 2009 wird eine Unterscheidung bzgl. § 37b getroffen--> 
								<xsl:text>Summe der pauschalen Lohnsteuer - ohne § 37b Einkommensteuergesetz </xsl:text>(<abbr>EStG</abbr>)
							</xsl:otherwise>
						</xsl:choose>
					</th>
					<td class="alCenter">41</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz41"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz44">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>Summe der pauschalen Lohnsteuer nach § 37b Einkommensteuergesetz </xsl:text>(<abbr>EStG</abbr>)
					</th>
					<td class="alCenter">44</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz44"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz43">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>abzüglich an Arbeitnehmer ausgezahltes Kindergeld</xsl:text>
					</th>
					<td class="alCenter">43</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz43"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz46">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>abzüglich an Arbeitnehmer ausgezahlte Bergmannsprämien</xsl:text>
					</th>
					<td class="alCenter">46</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz46"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz33">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>abzüglich Kürzungsbetrag für Besatzungsmitglieder von Handelsschiffen</xsl:text>
					</th>
					<td class="alCenter">33</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz33"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz48">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<strong>verbleiben</strong>
					</th>
					<td class="alCenter">48</td>
					<td class="alRight">
						<strong>
							<xsl:call-template name="formatiereGeldbetrag">
								<xsl:with-param name="betrag" select="//elster:Kz48"/>
							</xsl:call-template>
						</strong>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz49">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>Solidaritätszuschlag</xsl:text>
					</th>
					<td class="alCenter">49</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz49"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz47">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						pauschale Kirchensteuer im vereinfachten Verfahren
					</th>
					<td class="alCenter">47</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz47"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz61">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Evangelische Kirchensteuer
					</th>
					<td class="alCenter">61</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz61"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz62">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Römisch-Katholische Kirchensteuer
					</th>
					<td class="alCenter">62</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz62"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz63">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Altkatholische Kirchensteuer
					</th>
					<td class="alCenter">63</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz63"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz64">
				<xsl:call-template name="Kz64" />
			</xsl:if>
			<xsl:if test="elster:Kz65">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Freireligiöse Gemeinde Mainz
					</th>
					<td class="alCenter">65</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz65"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz66">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Freireligiöse Gemeinde Offenbach/M.
					</th>
					<td class="alCenter">66</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz66"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz67">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Kirchensteuer der Freireligiösen Landesgemeinde Baden
					</th>
					<td class="alCenter">67</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz67"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz68">
				<xsl:call-template name="Kz68" />
			</xsl:if>
			<xsl:if test="elster:Kz69">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Beiträge zur Angestelltenkammer
					</th>
					<td class="alCenter">69</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz69"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz70">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<xsl:text>Beiträge zur Arbeitskammer</xsl:text>
					</th>
					<td class="alCenter">70</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz70"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz72">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Freie Religionsgemeinschaft Alzey
					</th>
					<td class="alCenter">72</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz72"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz73">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Kirchensteuer der Israelitischen Religionsgemeinschaft Württembergs
					</th>
					<td class="alCenter">73</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz73"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz74">
				<xsl:call-template name="Kz74" />
			</xsl:if>
			<xsl:if test="elster:Kz76">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Kirchensteuer-lt/rf (ev)
					</th>
					<td class="alCenter">76</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz76"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz77">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Kirchensteuer-rk/ak
					</th>
					<td class="alCenter">77</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz77"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz78">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						Kirchensteuer der Israelitischen Religionsgemeinschaft Baden
					</th>
					<td class="alCenter">78</td>
					<td class="alRight">
						<xsl:call-template name="formatiereGeldbetrag">
							<xsl:with-param name="betrag" select="//elster:Kz78"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="elster:Kz83">
				<tr>
					<th scope="row" class="alLeft">
						<br />
						<strong>Gesamtbetrag</strong>
					</th>
					<td class="alCenter">83</td>
					<td class="alRight">
						<strong>
							<xsl:call-template name="formatiereGeldbetrag">
								<xsl:with-param name="betrag" select="//elster:Kz83"/>
							</xsl:call-template>
						</strong>
					</td>
				</tr>
			</xsl:if>
		</table>
		<xsl:if test="elster:Kz29   |  elster:Kz26">
			<h2>Sonstige Angaben</h2>
			<table>
				<tr>
					<td style="width: 70%"></td>
					<th style="width: 5%" class="alCenter">
						<abbr title="Kennziffer" class="help">Kz</abbr>
					</th>
					<th style="width: 25%" class="alRight">Wert</th>
				</tr>
				<xsl:if test="elster:Kz29">
					<tr>
						<th scope="row" class="alLeft">
							<br />
							<xsl:text>Verrechnung des Erstattungsbetrages erwünscht/ Erstattungsbetrag ist abgetreten</xsl:text>
						</th>
						<td class="alCenter">29</td>
						<td class="alRight">
							<xsl:value-of select="elster:Kz29" />
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="elster:Kz26">
					<tr>
						<th scope="row" class="alLeft">
							<br />
							<xsl:text>Die Einzugsermächtigung wird ausnahmsweise (z.B. wegen Verrechnungswünschen) für diesen Anmeldungszeitraum widerrufen</xsl:text>
						</th>
						<td class="alCenter">26</td>
						<td class="alRight">
							<xsl:value-of select="elster:Kz26" />
						</td>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
	</xsl:template>

	<!-- **************** Kz64 ********************************* -->
	<xsl:template name="Kz64">
		<xsl:if test="elster:Steuernummer[starts-with(.,'9')]">
		<!-- Bayern -->		
			<tr>
				<th scope="row" class="alLeft">
					<br />
					Israelitische Bekenntnissteuer
				</th>
				<td class="alCenter">64</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz64"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'26')]">
		<!--Hessen  -->
			<tr>
				<th scope="row" class="alLeft">
					<br />
					Israelitische Kultussteuer Frankfurt
				</th>
				<td class="alCenter">64</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz64"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'10')]">
		<!-- Saarland -->
			<tr>
				<th scope="row" class="alLeft">
					<br />
					<xsl:text>Israelitische Kultussteuer</xsl:text>
				</th>
				<td class="alCenter">64</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz64"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'27')] | elster:Steuernummer[starts-with(.,'5')] | elster:Steuernummer[starts-with(.,'22')] | elster:Steuernummer[starts-with(.,'21')]">
		<!-- Rheinland-Pfalz, NRW,  HH,  Schleswig Holstein -->
			<tr>
				<th scope="row" class="alLeft">
					<br />
					Jüdische Kultussteuer
				</th>
				<td class="alCenter">64</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz64"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'30')]">
		<!-- Brandenburg -->
			<tr>
				<th scope="row" class="alLeft">
					<br />
					<xsl:text>Israelitische / Jüdische Kultussteuer</xsl:text>
				</th>
				<td class="alCenter">64</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz64"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- **************** Kz68 ********************************* -->
	<xsl:template name="Kz68">
		<xsl:if test="elster:Steuernummer[starts-with(.,'24')]">
			<tr>
				<th scope="row" class="alLeft">
					<br />
					Beiträge zur Arbeitnehmerkammer
				</th>
				<td class="alCenter">68</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz68"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="elster:Steuernummer[starts-with(.,'27')]">
			<tr>
				<th scope="row" class="alLeft">
					<br />
					Freireligiöse Landesgemeinde Pfalz
				</th>
				<td class="alCenter">68</td>
				<td class="alRight">
					<xsl:call-template name="formatiereGeldbetrag">
						<xsl:with-param name="betrag" select="//elster:Kz68"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- ****************** Kz74 ************************************* -->
	<xsl:template name="Kz74">
		<tr>
			<th scope="row" class="alLeft">
				<br />
				<xsl:if test="elster:Steuernummer[starts-with(.,'26')]">
					<!-- Hessen --> 				
					<xsl:choose>
						<xsl:when test="elster:Jahr[starts-with(.,'2004')] | elster:Jahr[starts-with(.,'2005')] | elster:Jahr[starts-with(.,'2006')] | elster:Jahr[starts-with(.,'2007')] | elster:Jahr[starts-with(.,'2008')] | elster:Jahr[starts-with(.,'2009')]	">
							<!-- bis einschließlich 2009 --> 
							Israelitische Kultussteuer der kultusberechtigten Gemeinden						
						</xsl:when>
						<xsl:otherwise>
							<!-- ab 2010 -->						
							Israelitische Kultussteuer der kultussteuerberechtigten Gemeinden
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="elster:Steuernummer[starts-with(.,'30')]">
					<!-- Brandenburg -->
					Israelitische Kultussteuer der kultussteuerberechtigten Gemeinden Hessen
				</xsl:if>
			</th>
			<td class="alCenter">74</td>
			<td class="alRight">
				<xsl:call-template name="formatiereGeldbetrag">
					<xsl:with-param name="betrag" select="//elster:Kz74"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Version 2.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:elster="http://www.elster.de/2002/XMLSchema"
  exclude-result-prefixes="elster">

  <!--
    Template zur Visualisierung der Beträge in Postfachnachrichten der Anmeldungssteuern
  -->

	<xsl:decimal-format name="geldformat" decimal-separator="," grouping-separator="." />

	<xsl:template name="formatiereGeldbetrag">
		<!-- formatiert eine "Geldbetrags-Zeichenkette" nach deutscher Norm
			 input  1234567.89
		     output 1.234.567,89 EuroZeichen
		oder wenn keine Nachkommastellen existieren
		     input  1234567
		     output 1.234.567 EuroZeichen-->
		     
		<xsl:param name="betrag"/>
		<xsl:if test="$betrag">

			<xsl:choose>			
				<xsl:when test=" contains($betrag,'.') ">
					<!-- der $betrag enthält einen Dezimalpunkt -->
					<xsl:value-of select="format-number($betrag, '#.##0,00', 'geldformat')" />	
				</xsl:when>	
				<xsl:otherwise>
					<!-- der $betrag enthält keinen Dezimalpunkt -->
					<xsl:value-of select="format-number($betrag, '#.##0', 'geldformat')" />
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- non-breaking-space und Euro-Zeichen hinzufügen -->
			<xsl:text>&#160;&#8364;</xsl:text>	
		
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

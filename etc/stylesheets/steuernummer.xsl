<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Version 2.0 -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:elster="http://www.elster.de/2002/XMLSchema"
  exclude-result-prefixes="elster">

  <!--
    Template zur Visualisierung der Steuernummer
  -->

	<xsl:template name="formatiereSteuernummer">
		<xsl:param name="steuernummer"/>
		<xsl:choose>
			<xsl:when test="starts-with($steuernummer,'10')">
				<xsl:call-template name="StNr335">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'11')">
				<xsl:call-template name="StNr235">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'21')">
				<xsl:call-template name="StNr235a">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'22')">
				<xsl:call-template name="StNr235">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'23')">
				<xsl:call-template name="StNr235">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'24')">
				<xsl:call-template name="StNr235a">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'26')">
				<xsl:call-template name="StNr0235">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'27')">
				<xsl:call-template name="StNr235">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'28')">
				<xsl:call-template name="StNr55">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'3')">
				<xsl:call-template name="StNr335">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'4')">
				<xsl:call-template name="StNr335">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'5')">
				<xsl:call-template name="StNr344">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($steuernummer,'9')">
				<xsl:call-template name="StNr335">
					<xsl:with-param name="steuernummer" select="$steuernummer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$steuernummer"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Steuernummern formatieren -->
	<xsl:template name="StNr0235">
		<xsl:param name="steuernummer"/>
		<xsl:text>0</xsl:text>
		<xsl:value-of select="substring($steuernummer,3,2)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr2341">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,3,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,9,4)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,13,1)"/>
	</xsl:template>
	<xsl:template name="StNr235">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,3,2)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr235a">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,3,2)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr344">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,2,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,6,4)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,10,4)"/>
	</xsl:template>
	<xsl:template name="StNr335">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,2,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,9,5)"/>
	</xsl:template>
	<xsl:template name="StNr55">
		<xsl:param name="steuernummer"/>
		<xsl:value-of select="substring($steuernummer,3,2)"/>
		<xsl:value-of select="substring($steuernummer,6,3)"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="substring($steuernummer,9,5)"/>
	</xsl:template>
</xsl:stylesheet>

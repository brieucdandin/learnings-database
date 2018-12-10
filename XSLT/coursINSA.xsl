<?xml version="1.0" encoding="UTF-8" ?>

<!-- l'élément racine -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- l'élément output -->
    <xsl:output 
        method="html"
        encoding="UTF-8"
        indent="yes" >
	</xsl:output>

    <!-- reste du document XSLT -->
	<xsl:template match="/">
		<html>
		    <head>
		        <title>Programme Informatique 4IR-I</title>
		    </head>
		    <body>
		        <h1> <xsl:value-of select="/formation/titre"/> </h1>
				<xsl:for-each select="formation/UF">
					<xsl:number count="UF" level="single"/>
					<h2> </h2>
					<xsl:value-of select="."/>
					<xsl:apply-templates select="formation/UF"/>
				</xsl:for-each>
		    </body>
    	</html> 
	</xsl:template>

	<xsl:template match="UF">
			<ul>
				<li><xsl:value-of select="titre"/></li>
				<li><xsl:value-of select="horaire"/></li>
				<li><xsl:value-of select="ects"/> crédits ECTS</li>
				<li>Responsable : <xsl:value-of select="enseignantResp"/></li>
				<li>Les UE :</li>
				<ul>
					<xsl:for-each select="UEs/UE"> 
						<li><xsl:value-of select="."/></li>
					</xsl:for-each>
				</ul>
			</ul>	
	</xsl:template>
</xsl:stylesheet>
<!--
<br/>
				<xsl:for-each select="/formation">
					<xsl:number count="//formation/UF" level="single"/>
						<h2> </h2>
						<xsl:value-of select="@apogee"/>

<br/>
				</xsl:for-each>
-->

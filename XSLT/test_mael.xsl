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
		        <title>Maquette INSA</title>
		    </head>
		    <body>
		        <h1>L'INSA compte 
					<xsl:value-of select="count(/maquette/personnels/personnel)"/> 
					personnes dans le personnel.
				</h1>
				<h2> Liste des personnes </h2>
				<ul>
					<xsl:for-each select="/maquette/personnels/personnel"> 
					<xsl:sort  select="nom"></xsl:sort>
							<xsl:choose>
								<xsl:when test="nom = nom[not(preceding::nom = .)]">
									<li>
										<xsl:value-of select="nom"/>
									</li>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
					</xsl:for-each>
				</ul>
		    </body>
    	</html> 
	</xsl:template>

</xsl:stylesheet>


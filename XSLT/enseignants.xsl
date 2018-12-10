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
		        <title>Mon premier document XSLT</title>
		    </head>
		    <body>
		        <h1>L'université contient 
					<xsl:value-of select="count(//enseignants/enseignant)"/>
					enseignants.
				</h1>
				<h2> Liste des personnes </h2>
				<ul>
					<xsl:for-each select="/enseignants/enseignant"> 
					<xsl:sort  select="departement"></xsl:sort>
							<xsl:choose>
								<xsl:when test="departement = departement[not(preceding::departement = .)]">
									<li>
										<xsl:value-of select="departement"/>
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


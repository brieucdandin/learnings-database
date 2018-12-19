<?xml version="1.0" encoding="UTF-8" ?>
<!--
Penser à référencer le fichier XSLT dans le fichier XML correspondant,
à l'aide de la balise suivante (au même endroit dans le XML) :
	<?xml-stylesheet type="text/xsl" href= "test.xsl" ?>
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output
		method="html"
		encoding="UTF-8"
		doctype-public="-//W3C//DTD HTML 4.01//EN"
		doctype-system="http://www.w3.org/TR/html4/strict.dtd"
		indent="yes" ></xsl:output>

	<xsl:template match="/" name="template1" >
		<html>

			<head>
				<style>
					table{
						border-collapse: collapse;
					}

					td, th /* Mettre une bordure sur les td ET les th */{
						border: 1px solid black;
					}
				</style>
				<title>test</title>
			</head>

			<body>


				<p>Hello world!</p>
				<p><xsl:value-of select="maquettes/personnels/personnel[nom='Flantier']/@idPersonnel" /></p>
				<p><xsl:value-of select="maquettes/personnels/personnel[nom='Flantier']/prenom" /></p>

				<xsl:for-each select="maquette/personnels/personnel">
					<p><xsl:value-of select="prenom" /></p>
				</xsl:for-each>


				<table>
					<caption>Un tableau (si, si...)</caption> <!-- Titre du tableau -->

					<thead> <!-- En-tête du tableau -->
						<tr>
							<th>Prénom</th>
							<th>Âge</th>
							<th>Pays</th>
						</tr>
					</thead>

					<tbody> <!-- Corps du tableau -->
						<tr>
							<td>Didier</td>
							<td>33 ans</td>
							<td>Canada</td>
						</tr>
						<tr>
							<td>Germaine</td>
							<td>126 ans</td>
							<td>Japon</td>
						</tr>
						<tr>
							<td rowspan="2">FUUUU...</td>
							<td colspan="2">... ZIOOOOON !!!</td>
						</tr>
						<tr>
							<td>Wouhaaa !</td>
							<td>Les bioumans !</td>
						</tr>
					</tbody>
				</table>


			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>


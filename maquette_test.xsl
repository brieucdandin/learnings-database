<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output
    method="html"
    encoding="UTF-8"
    indent="no" />

  <xsl:template match="/">
    <html>
      <head>
        <!-- CSS -->
        <style>
          table
          {
            border-collapse: collapse; }
          td, th
          {
            border: 1px solid black;
          }
        </style>
        <title>Maquettes INSA Toulouse</title>
      </head>
      <body>
        <!-- Affichage de chaque UF et des UEs qui la compose. -->
        <h1>Maquette Maël</h1>
        <xsl:for-each select="maquettes/maquette/ufs/uf">
          <xsl:variable name="codeUf" select="@codeUf"/>
          <h2><xsl:value-of select="intitule"/></h2>
          <xsl:for-each select="/maquettes/maquette/ues/ue">
            <xsl:if test="$codeUf = @uf">
              <p><xsl:value-of select="intitule"/></p>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>

        <!-- Création d'un tableau -->
        <table>
          <caption>Maquette Maël</caption>
          <!-- En-tête du tableau -->
          <thead>
            <tr>
              <th>UF puis UE</th>
              <th>Responsable</th>
              <th>Code Apogée</th>
              <th>CM</th>
              <th>TD</th>
              <th>TP</th>
              <th>Total</th>
              <th>ECTS</th>
            </tr>
          </thead>
          <!-- Pied ed page du tableau -->
          <tfoot>
            <tr>
              <th>UF puis UE</th>
              <th>Responsable</th>
              <th>Code Apogée</th>
              <th>CM</th>
              <th>TD</th>
              <th>TP</th>
              <th>Total</th>
              <th>ECTS</th>
            </tr>
          </tfoot>
          <!-- Corps du tableau -->
          <tbody>
            <tr>
              <td>UF puis UE</td>
              <td>Responsable</td>
              <td>Code Apogée</td>
              <td>CM</td>
              <td>TD</td>
              <td>TP</td>
              <td>Total</td>
              <td>ECTS</td>
            </tr>
          </tbody>
        </table>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

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
          caption
          {
            font-size: x-large;
            font-weight: bold;
            text-decoration: underline;
          }
        </style>
        <title>Maquettes INSA Toulouse</title>
      </head>
      <body>

        <xsl:call-template name="maquette"/>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="maquette">
    <!-- Création d'un tableau -->
    <table>
      <caption>Maquette Maël</caption>
      <!-- En-tête du tableau -->
      <thead>
        <tr>
          <th>UF / UE</th>
          <th>Responsable</th>
          <th>Code Apogée</th>
          <th>CM</th>
          <th>TD</th>
          <th>TP</th>
          <th>Total</th>
          <th>ECTS</th>
        </tr>
      </thead>
      <!-- Pied de page du tableau -->
      <tfoot>
        <tr>
          <th>UF / UE</th>
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
        <xsl:call-template name="corps_tableau"/>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="corps_tableau">
    <xsl:for-each select="maquettes/maquette/ufs/uf">
      <xsl:variable name="codeUf" select="@codeUf"/>
      <xsl:call-template name="uf">
        <xsl:with-param name="intitule" select="intitule"/>
        <xsl:with-param name="idresponsable" select="@responsable"/>
        <xsl:with-param name="code" select="@codeUf"/>
        <xsl:with-param name="ects" select="ects"/>
      </xsl:call-template>
      <xsl:for-each select="/maquettes/maquette/ues/ue">
        <xsl:if test="$codeUf = @uf">
          <xsl:call-template name="ue">
            <xsl:with-param name="intitule" select="intitule"/>
            <xsl:with-param name="idresponsable" select="@responsable"/>
            <xsl:with-param name="code" select="@codeUe"/>
            <xsl:with-param name="cm" select="cm"/>
            <xsl:with-param name="td" select="td"/>
            <xsl:with-param name="tp" select="tp"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="uf">
    <xsl:param name="intitule"/>
    <xsl:param name="idresponsable"/>
    <xsl:param name="code"/>
    <xsl:param name="ects"/>
    <tr>
      <td><strong><xsl:value-of select="$intitule"/></strong></td>
      <td>
        <xsl:call-template name="responsable">
          <xsl:with-param name="idresponsable" select="$idresponsable"/>
        </xsl:call-template>
      </td>
      <td><strong><xsl:value-of select="$code"/></strong></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td><xsl:value-of select="$ects"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="ue">
    <xsl:param name="intitule"/>
    <xsl:param name="idresponsable"/>
    <xsl:param name="code"/>
    <xsl:param name="cm"/>
    <xsl:param name="td"/>
    <xsl:param name="tp"/>
    <tr>
      <td><xsl:value-of select="$intitule"/></td>
      <td>
        <xsl:call-template name="responsable">
          <xsl:with-param name="idresponsable" select="$idresponsable"/>
        </xsl:call-template>
      </td>
      <td><xsl:value-of select="$code"/></td>
      <td><xsl:value-of select="$cm"/></td>
      <td><xsl:value-of select="$td"/></td>
      <td><xsl:value-of select="$tp"/></td>
      <td><xsl:value-of select="$cm+$td+$tp"/></td>
      <td></td>
    </tr>
  </xsl:template>

  <xsl:template name="responsable">
    <xsl:param name="idresponsable"/>
    <xsl:value-of select="$idresponsable"/>
    <!-- <xsl:value-of select="maquettes/maquette/personnels/personnel[@idPersonnel=idresponsable]/nom"/> -->
  </xsl:template>

</xsl:stylesheet>

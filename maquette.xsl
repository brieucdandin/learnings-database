<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output
    method="html"
    encoding="UTF-8"
    indent="no" />

<!-- Méthode Muench -->
<!-- On veut l'appliquer sur tous les attributs "responsable" -->
<xsl:key name="id" match="//@responsable" use="."/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Maquettes INSA Toulouse</title>
        <!-- Lien vers le CSS -->
        <link rel="stylesheet" href="maquette.css"/>
      </head>
      <body>
        <xsl:for-each select="maquettes/maquette">
          <table>
            <caption>
              <!-- Titre du tableau -->
              <h1>
                <xsl:value-of select="concat(promo/annee, 'A - ', promo/intitule,' - ',specialite/intitule)"/>
              </h1>
              <!-- Reponsable de la promo -->
              Responsable de la promo <em><xsl:value-of select="promo/intitule"/></em> :
              <xsl:call-template name="responsable">
                <xsl:with-param name="idresponsable" select="promo/@responsable"/>
              </xsl:call-template>
              <br/>
              <!-- Reponsable de la spécialité -->
              <!-- Puisque la spécialité est optionnelle, on définit un template spécifique. -->
              <xsl:call-template name="responsableSpe">
                <xsl:with-param name="idresponsable" select="specialite/@responsable"/>
                <xsl:with-param name="specialite" select="specialite/intitule"/>
              </xsl:call-template>
              <br/>
            </caption>

            <!-- En-tête du tableau -->
              <thead>
                <tr>
                  <th>UF / UE</th>
                  <th>Responsable</th>
                  <th>Département</th>
                  <th>Code Apogée</th>
                  <th>CM</th>
                  <th>TD</th>
                  <th>TP</th>
                  <th>Total</th>
                  <th>ECTS</th>
                </tr>
              </thead>
              <!-- Pied de page du tableau -->
              <!-- Sommes des colonnes -->
              <tfoot>
                <tr>
                  <th colspan="4">Total</th>
                  <!-- Somme CM -->
                  <th><xsl:value-of select="sum(ues/ue/cm)"/></th>
                  <!-- Somme TD -->
                  <th><xsl:value-of select="sum(ues/ue/td)"/></th>
                  <!-- Somme TP -->
                  <th><xsl:value-of select="sum(ues/ue/tp)"/></th>
                  <!-- Somme heures -->
                  <th><xsl:value-of select="sum(ues/ue/cm)+sum(ues/ue/td)+sum(ues/ue/tp)"/></th>
                  <!-- Somme ECTS -->
                  <th><xsl:value-of select="sum(ufs/uf/ects)"/></th>
                </tr>
              </tfoot>
              <!-- Corps du tableau -->
              <tbody>
                <xsl:for-each select="ufs/uf">
                  <xsl:variable name="codeUf" select="@codeUf"/>
                  <!-- Pour chaque UF, on affiche ses infos principales. -->
                  <tr>
                    <td><strong><xsl:value-of select="intitule"/></strong></td>
                    <td>
                      <xsl:call-template name="responsable">
                        <xsl:with-param name="idresponsable" select="@responsable"/>
                      </xsl:call-template>
                    </td>
                    <td>
                      <xsl:call-template name="departement">
                        <xsl:with-param name="idresponsable" select="@responsable"/>
                      </xsl:call-template>
                    </td>
                    <td><strong><xsl:value-of select="@codeUf"/></strong></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td><xsl:value-of select="ects"/></td>
                  </tr>
                  <!-- Pour chaque UE qui appartient à l'UF, on affiche ses infos principales -->
                  <xsl:for-each select="../../ues/ue">
                    <xsl:if test="$codeUf = @uf">
                      <tr>
                        <td><xsl:value-of select="intitule"/></td>
                        <td>
                          <xsl:call-template name="responsable">
                            <xsl:with-param name="idresponsable" select="@responsable"/>
                          </xsl:call-template>
                        </td>
                        <td>
                          <xsl:call-template name="departement">
                            <xsl:with-param name="idresponsable" select="@responsable"/>
                          </xsl:call-template>
                        </td>
                        <td><xsl:value-of select="@codeUe"/></td>
                        <td><xsl:value-of select="cm"/></td>
                        <td><xsl:value-of select="td"/></td>
                        <td><xsl:value-of select="tp"/></td>
                        <td><xsl:value-of select="cm+td+tp"/></td>
                        <td></td>
                      </tr>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
            </table>

            <!-- Informations sur le département d'appartenance -->
            <h3>Département</h3>
            <xsl:call-template name="departementMaquette">
              <xsl:with-param name="idresponsablepromo" select="promo/@responsable"/>
            </xsl:call-template>

            <!-- Informations sur les personnels impliqués -->
            <h3>Personnels</h3>
            <!-- Application de la méthode Muench -->
            <xsl:for-each select="//@responsable[generate-id(.)=generate-id(key('id', .)[1])]">
                <xsl:call-template name="infoPersonnel">
                  <xsl:with-param name="idpersonnel" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="responsable">
    <xsl:param name="idresponsable"/>
    <xsl:for-each select="/maquettes/personnels/personnel">
      <xsl:if test="$idresponsable = @idPersonnel">
        <xsl:value-of select="concat(nom,' ',prenom)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="responsableSpe">
    <xsl:param name="idresponsable"/>
    <xsl:param name="specialite"/>
    <xsl:for-each select="/maquettes/personnels/personnel">
      <xsl:if test="$idresponsable = @idPersonnel">
        Responsable de la spécialité
        <em><xsl:value-of select="$specialite"/></em>
        <xsl:value-of select="concat(' : ',nom,' ',prenom)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="departement">
    <xsl:param name="idresponsable"/>
    <xsl:variable name="iddepartement" select="/maquettes/personnels/personnel[@idPersonnel = $idresponsable]/@appDepartement"/>
    <xsl:value-of select="/maquettes/departements/departement[@idDepartement=$iddepartement]/acronyme"/>
  </xsl:template>

  <!-- On a l'id du responsable de la promo. -->
  <!-- Il faut récupérer l'id de son département d'appartenance. -->
  <!-- Puis afficher les infos de ce département -->

  <xsl:template name="departementMaquette">
    <xsl:param name="idresponsablepromo"/>
    <xsl:variable name="iddepartement" select="/maquettes/personnels/personnel[@idPersonnel = $idresponsablepromo]/@appDepartement"/>
    <xsl:for-each select="/maquettes/departements/departement">
      <xsl:if test="$iddepartement = @idDepartement">
        <xsl:value-of select="concat('Acronyme : ', acronyme)"/>
        <br/>
        <xsl:value-of select="concat('Nom : ', nom)"/>
        <br/>
        Directeur :
        <xsl:call-template name="responsable">
          <xsl:with-param name="idresponsable" select="@responsable"/>
        </xsl:call-template>
        <br/>
        <xsl:value-of select="concat('Date de création : ', dateCreation)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="infoPersonnel">
    <xsl:param name="idpersonnel"/>
    <xsl:for-each select="/maquettes/personnels/personnel">
      <xsl:if test="$idpersonnel = @idPersonnel">
        <h5><xsl:value-of select="concat(nom,' ',prenom)"/></h5>
        <xsl:value-of select="concat('Grade : ', grade)"/>
        <br/>
        <xsl:value-of select="concat('Bureau : ', bureau)"/>
        <br/>
        <xsl:value-of select="concat('Tel : ', tel)"/>
        <br/>
        <xsl:value-of select="concat('Mail : ', mail)"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

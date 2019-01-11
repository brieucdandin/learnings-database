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
        <!-- Affichage des informations de chaque maquette -->
        <xsl:apply-templates select="maquettes/maquette"/>
      </body>
    </html>
  </xsl:template>

  <!-- Affichage des informations de chaque maquette -->
  <xsl:template match="maquette">
    <xsl:variable name="idmaquette" select="@idMaquette"/>
    <table id="maquette">
      <caption>
        <!-- Titre du tableau -->
        <h1>
          <xsl:value-of select="concat(@annee, 'A S', @semestre,' - ', promo/intitule)"/>
          <xsl:if test="specialite = true()">
            <xsl:value-of select="concat(' - ',specialite/intitule)"/>
          </xsl:if>
        </h1>
        <!-- Reponsable de la promo -->
        Responsable de <em><xsl:value-of select="promo/acronyme"/></em> :
        <xsl:apply-templates select="promo/@responsable"/>
        <br/>
        <!-- Reponsable de la spécialité -->
        <!-- Si il/elle existe -->
        <xsl:if test="specialite/@responsable = true()">
          Responsable de <em><xsl:value-of select="specialite/acronyme"/></em> :
          <xsl:apply-templates select="specialite/@responsable"/>
        </xsl:if>
        <br/>
      </caption>

      <!-- En-tête du tableau -->
        <thead>
          <tr>
            <th rowspan="2">UF / UE</th>
            <th rowspan="2">Responsable</th>
            <th rowspan="2">Code Apogée</th>
            <th colspan="3">Spécificités</th>
            <th rowspan="2">CM</th>
            <th rowspan="2">TD</th>
            <th rowspan="2">TP</th>
            <th rowspan="2">Total</th>
            <th colspan="6">Controles</th>
            <th rowspan="2">ECTS</th>
            <th rowspan="2">Compétences</th>
          </tr>
          <tr>
            <!-- Spécificités : Obligation + Hétérogénéité + Compétences -->
            <th>Obligatoire</th>
            <th>Hétérogène</th>
            <th>Compétences</th>
            <!-- Contrôles : Intitulé + Nature + Durée + N° Apogée + Coeff -->
            <th>Durée</th>
            <th>Intitulé</th>
            <th>Nature</th>
            <th>N° Apogée</th>
            <th colspan="2">Coeff</th>
          </tr>
        </thead>

        <!-- Pied de page du tableau -->
        <!-- Sommes des colonnes -->
        <tfoot>
          <tr>
            <th colspan="6">Total</th>
            <!-- Somme CM -->
            <th><xsl:value-of select="sum(ues/ue/cm)"/></th>
            <!-- Somme TD -->
            <th><xsl:value-of select="sum(ues/ue/td)"/></th>
            <!-- Somme TP -->
            <th><xsl:value-of select="sum(ues/ue/tp)"/></th>
            <!-- Somme heures -->
            <th><xsl:value-of select="sum(ues/ue/cm)+sum(ues/ue/td)+sum(ues/ue/tp)"/></th>
            <!-- Contrôles -->
            <th>
              <xsl:variable name="sumDuree" select="sum(epreuves/epreuve/duree)"/>
              <xsl:if test="not($sumDuree = 0)">
                <xsl:value-of select="$sumDuree"/>
              </xsl:if>
            </th>
            <th colspan="5"></th>
            <!-- Somme ECTS -->
            <th><xsl:value-of select="sum(ufs/uf/ects)"/></th>
            <th/>
          </tr>
        </tfoot>
        <!-- Corps du tableau -->
        <tbody>
          <xsl:apply-templates select="ufs/uf"/>
        </tbody>
      </table>


      <!-- Informations sur le département d'appartenance et les personnels impliqués -->
      <br/>
      <table id="informations">
        <thead>
          <tr>
            <th><h3>Département</h3></th>
            <th><h3>Personnels</h3></th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <xsl:call-template name="departementMaquette">
                <xsl:with-param name="idresponsablepromo" select="promo/@responsable"/>
              </xsl:call-template>
            </td>
            <!-- Application de la méthode Muench -->
            <xsl:for-each select=".//@responsable">
              <xsl:variable name="idresponsable" select="."/>
              <xsl:variable name="nbKey" select="1+count(/maquettes/maquette[@idMaquette=$idmaquette]/preceding::*/@responsable[. = $idresponsable])"/>
              <xsl:if test="generate-id(.)=generate-id(key('id', .)[$nbKey])">
                <td>
                  <xsl:call-template name="infoPersonnel">
                    <xsl:with-param name="idpersonnel" select="."/>
                  </xsl:call-template>
                </td>
              </xsl:if>
            </xsl:for-each>
          </tr>
        </tbody>
      </table>
      <br/>
  </xsl:template>

  <xsl:template match="@responsable">
    <xsl:variable name="idresponsable" select="."/>
    <xsl:value-of select="concat(/maquettes/personnels/personnel[@idPersonnel = $idresponsable]/nom, ' ', /maquettes/personnels/personnel[@idPersonnel = $idresponsable]/prenom)"/>
  </xsl:template>

  <xsl:template match="uf">
    <xsl:variable name="idUf" select="@idUf"/>
    <!-- Pour chaque UF, on affiche ses infos principales. -->
    <tr class="uf">
      <!-- Intitulé -->
      <td><xsl:value-of select="intitule"/></td>
      <!-- Responsable -->
      <td>
        <xsl:apply-templates select="@responsable"/>
      </td>
      <!-- Code Apogée -->
      <td><xsl:value-of select="codeApogee"/></td>
      <!-- Spécificités : Obligation + Hétérogénéité + Compétences -->
      <td>
        <xsl:if test="obligation='true'">
          X
        </xsl:if>
      </td>
      <td>
        <xsl:if test="heterogene='true'">
          X
        </xsl:if>
      </td>
      <td>
        <xsl:if test="competences='true'">
          X
        </xsl:if>
      </td>
      <!-- CM/TD/TP/Total -->
      <xsl:variable name="cm" select="sum(/maquettes/maquette/ues/ue[@uf=$idUf]/cm)"/>
      <xsl:variable name="td" select="sum(/maquettes/maquette/ues/ue[@uf=$idUf]/td)"/>
      <xsl:variable name="tp" select="sum(/maquettes/maquette/ues/ue[@uf=$idUf]/tp)"/>

      <td>
        <xsl:if test="not($cm = 0)">
          <xsl:value-of select="$cm"/>
        </xsl:if>
      </td>
      <td>
        <xsl:if test="not($td = 0)">
          <xsl:value-of select="$td"/>
        </xsl:if>
      </td>
      <td>
        <xsl:if test="not($tp = 0)">
          <xsl:value-of select="$tp"/>
        </xsl:if>
      </td>
      <td>
        <xsl:if test="not($cm + $td + $tp = 0)">
          <xsl:value-of select="$cm + $td + $tp"/>
        </xsl:if>
      </td>

      <!-- Contrôles : Durée + Intitulé + Nature + N° Apogée + Coeff -->
      <td>
        <!-- Somme des durées des épreuves des UEs de l'UF -->
        <xsl:variable name="duree" select="sum(/maquettes/maquette/epreuves/epreuve[@ue = /maquettes/maquette/ues/ue[@uf=$idUf]/@idUe]/duree)"/>
        <xsl:if test="not($duree = 0)">
          <xsl:value-of select="duree"/>
        </xsl:if>
      </td>
      <td colspan="5"/>
      <!-- ECTS -->
      <td><xsl:value-of select="ects"/></td>
      <td/>
    </tr>
    <!-- Pour chaque UE qui appartient à l'UF, on affiche ses infos principales -->
    <xsl:apply-templates select="/maquettes/maquette/ues/ue[@uf=$idUf]"/>
  </xsl:template>

  <!-- Affichage des informations de l'UE -->
  <xsl:template match="ue">
      <xsl:variable name="idUe" select="@idUe"/>
      <xsl:variable name="idUf" select="@uf"/>
      <xsl:variable name="nbUe" select="count(maquettes/maquette/ues/ue[@uf=$idUf])"/>
        <!-- Affichage des informations des épreuves de l'UE -->
        <xsl:choose>
          <!-- Si l'UE n'a pas d'épreuves -->
          <xsl:when test="/maquettes/maquette/epreuves/epreuve[@ue = $idUe] = false()">
            <tr>
              <!-- Intitulé de l'UE -->
              <td >
                <xsl:value-of select="/maquettes/maquette/ues/ue[@idUe=$idUe]/intitule"/>
              </td>
              <!-- Responsable de l'UE -->
              <td>
                <xsl:apply-templates select="/maquettes/maquette/ues/ue[@idUe=$idUe]/@responsable"/>
              </td>
              <!-- Code Apogée de l'UE -->
              <td>
                <xsl:value-of select="/maquettes/maquette/ues/ue[@idUe=$idUe]/codeApogee"/>
              </td>
              <!-- Spécificités -->
              <td colspan="3"/>
              <!-- CM / TD / TP -->
              <xsl:variable name="cm" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/cm)"/>
              <xsl:variable name="td" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/td)"/>
              <xsl:variable name="tp" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/tp)"/>
              <td>
                <xsl:if test="not($cm = 0)">
                  <xsl:value-of select="$cm"/>
                </xsl:if>
              </td>
              <td>
                <xsl:if test="not($td = 0)">
                  <xsl:value-of select="$td"/>
                </xsl:if>
              </td>
              <td>
                <xsl:if test="not($tp = 0)">
                  <xsl:value-of select="$tp"/>
                </xsl:if>
              </td>
              <td>
                <xsl:if test="not($cm + $td + $tp = 0)">
                  <xsl:value-of select="$cm + $td + $tp"/>
                </xsl:if>
              </td>
              <!-- Contrôles + ECTS -->
              <td colspan="7"/>
              <!-- Affiche la compétence si elle existe. -->
              <td><xsl:value-of select="/maquettes/maquette/competences/competence[@idCompetence = /maquettes/maquette/ues_competences/ue_competence[@ue=$idUe]/@competence]/intitule"/></td>
            </tr>
          </xsl:when>
          <!-- Si l'UE a au moins 2 épreuves -->
          <xsl:otherwise>
            <xsl:variable name="nbEpreuves" select="count(/maquettes/maquette/epreuves/epreuve[@ue=$idUe])"/>
            <xsl:apply-templates select="/maquettes/maquette/epreuves/epreuve[@ue = $idUe]">
              <xsl:with-param name="nbEpreuves" select="$nbEpreuves"/>
            </xsl:apply-templates>
          </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="epreuve">
    <xsl:param name="nbEpreuves"/>
    <xsl:variable name="idUe" select="@ue"/>
    <xsl:choose>
      <xsl:when test="position()=1">
        <tr>
          <td rowspan="{$nbEpreuves}"><xsl:value-of select="/maquettes/maquette/ues/ue[@idUe=$idUe]/intitule"/></td>
          <td rowspan="{$nbEpreuves}">
            <xsl:apply-templates select="/maquettes/maquette/ues/ue[@idUe=$idUe]/@responsable"/>
          </td>
          <td rowspan="{$nbEpreuves}"><xsl:value-of select="/maquettes/maquette/ues/ue[@idUe=$idUe]/codeApogee"/></td>
          <td colspan="3" rowspan="{$nbEpreuves}"></td>
          <xsl:variable name="cm" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/cm)"/>
          <xsl:variable name="td" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/td)"/>
          <xsl:variable name="tp" select="sum(/maquettes/maquette/ues/ue[@idUe=$idUe]/tp)"/>
          <td rowspan="{$nbEpreuves}">
            <xsl:if test="not($cm = 0)">
              <xsl:value-of select="$cm"/>
            </xsl:if>
          </td>
          <td rowspan="{$nbEpreuves}">
            <xsl:if test="not($td = 0)">
              <xsl:value-of select="$td"/>
            </xsl:if>
          </td>
          <td rowspan="{$nbEpreuves}">
            <xsl:if test="not($tp = 0)">
              <xsl:value-of select="$tp"/>
            </xsl:if>
          </td>
          <td rowspan="{$nbEpreuves}">
            <xsl:if test="not($cm + $td + $tp = 0)">
              <xsl:value-of select="$cm + $td + $tp"/>
            </xsl:if>
          </td>
          <!-- Contrôles : Durée + Intitulé + Nature + N° Apogée + Coeff -->
          <!-- Pour chaque épreuve de l'UF, on affiche ses infos. -->
          <td><xsl:value-of select="duree"/></td>
          <td><xsl:value-of select="intitule"/></td>
          <td><xsl:value-of select="nature"/></td>
          <td><xsl:value-of select="nApogee"/></td>
          <td><xsl:value-of select="coeff[not(.='1')]"/></td>
          <td rowspan="{$nbEpreuves}"><xsl:value-of select="/maquettes/maquette/ues/ue[@idUe=$idUe]/coefficient[not(.='1')]"/></td>
          <!-- ECTS -->
          <td rowspan="{$nbEpreuves}"/>
          <!-- Affiche la compétence si elle existe. -->
          <td rowspan="{$nbEpreuves}"><xsl:value-of select="/maquettes/maquette/competences/competence[@idCompetence = /maquettes/maquette/ues_competences/ue_competence[@ue=$idUe]/@competence]/intitule"/></td>
        </tr>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td><xsl:value-of select="duree"/></td>
          <td><xsl:value-of select="intitule"/></td>
          <td><xsl:value-of select="nature"/></td>
          <td><xsl:value-of select="nApogee"/></td>
          <td><xsl:value-of select="coeff[not(.='1')]"/></td>
        </tr>
      </xsl:otherwise>
</xsl:choose>
  </xsl:template>

  <!-- On a l'id du responsable de la promo. -->
  <!-- Il faut récupérer l'id de son département d'appartenance. -->
  <!-- Puis afficher les infos de ce département -->

  <xsl:template name="departementMaquette">
    <xsl:param name="idresponsablepromo"/>
    <xsl:variable name="iddepartement" select="/maquettes/personnels/personnel[@idPersonnel = $idresponsablepromo]/@appDepartement"/>
    <xsl:apply-templates select="/maquettes/departements/departement[@idDepartement = $iddepartement]"/>
  </xsl:template>

  <xsl:template match="departement">
    <em>Acronyme : </em>
    <xsl:value-of select="acronyme"/>
    <br/>
    <em>Nom : </em>
    <xsl:value-of select="nom"/>
    <br/>
    <em>Directeur : </em>
    <xsl:apply-templates select="@responsable"/>
    <br/>
    <em>Date de création : </em>
    <xsl:value-of select="dateCreation"/>
  </xsl:template>

  <xsl:template name="infoPersonnel">
    <xsl:param name="idpersonnel"/>
    <xsl:for-each select="/maquettes/personnels/personnel[$idpersonnel = @idPersonnel]">
      <h4><xsl:value-of select="concat(nom,' ',prenom)"/></h4>
      <em>Grade : </em>
      <xsl:value-of select="grade"/>
      <br/>
      <em>Département : </em>
      <xsl:value-of select="/maquettes/departements/departement[@idDepartement = /maquettes/personnels/personnel[@idPersonnel=$idpersonnel]/@appDepartement]/acronyme"/>
      <br/>
      <em>Bureau : </em>
      <xsl:value-of select="bureau"/>
      <br/>
      <em>Tel : </em>
      <xsl:value-of select="tel"/>
      <br/>
      <em>Mail : </em>
      <xsl:value-of select="mail"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

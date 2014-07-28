<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:geonet="http://www.fao.org/geonetwork" exclude-result-prefixes="#all" version="2.0">

  <!-- Thumbnail base url (mandatory) -->
  <xsl:param name="prefix" select="'http://geosource.grandlyon.fr/geosource/srv/fre/resources.get'"/>

  <xsl:template match="gmd:MD_DataIdentification|*[contains(@gco:isoType, 'MD_DataIdentification')]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="gmd:citation"/>
      <xsl:apply-templates select="gmd:abstract"/>
      <xsl:apply-templates select="gmd:purpose"/>
      <xsl:apply-templates select="gmd:credit"/>
      <xsl:apply-templates select="gmd:status"/>
      <xsl:apply-templates select="gmd:pointOfContact"/>
      <xsl:apply-templates select="gmd:resourceMaintenance"/>

      <xsl:for-each select="gmd:graphicOverview">
        <xsl:copy>
          <gmd:MD_BrowseGraphic>
            <xsl:variable name="fileName" select="gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
            <xsl:variable name="fileType" select="gmd:MD_BrowseGraphic/gmd:fileType/gco:CharacterString"/>
            <xsl:choose>
              <xsl:when test="not(starts-with($fileName, 'http://'))">
                <xsl:variable name="identifer" select="/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
                <xsl:message>#<xsl:value-of select="$identifer"/> </xsl:message>

                <gmd:fileName>
                  <gco:CharacterString>
                    <xsl:value-of
                        select="concat($prefix, '?uuid=',
                              $identifer, '&amp;fname=', $fileName)"/>
                  </gco:CharacterString>
                </gmd:fileName>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileName"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileDescription"/>
            <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileType"/>
          </gmd:MD_BrowseGraphic>
        </xsl:copy>
      </xsl:for-each>

      <xsl:apply-templates select="gmd:resourceFormat"/>
      <xsl:apply-templates select="gmd:descriptiveKeywords"/>
      <xsl:apply-templates select="gmd:resourceSpecificUsage"/>
      <xsl:apply-templates select="gmd:resourceConstraints"/>
      <xsl:apply-templates select="gmd:aggregationInfo"/>
      <xsl:apply-templates select="gmd:spatialRepresentationType"/>
      <xsl:apply-templates select="gmd:spatialResolution"/>
      <xsl:apply-templates select="gmd:language"/>
      <xsl:apply-templates select="gmd:characterSet"/>
      <xsl:apply-templates select="gmd:topicCategory"/>
      <xsl:apply-templates select="gmd:environmentDescription"/>
      <xsl:apply-templates select="gmd:extent"/>
      <xsl:apply-templates select="gmd:supplementalInformation"/>

    </xsl:copy>
  </xsl:template>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Always remove geonet:* elements. -->
  <xsl:template match="geonet:*|gmd:graphicOverview" priority="2"/>

</xsl:stylesheet>

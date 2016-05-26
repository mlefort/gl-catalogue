<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet used to update metadata adding a reference to a parent record.
-->
<xsl:stylesheet version="2.0"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="opendataKeyword"
        select="'données ouvertes'"/>

  <xsl:variable name="opendataLicence"
        select="'Licence Ouverte'"/>

  <xsl:template match="/simpledc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="dc:*|dct:*"/>
      <xsl:if test="(dc:rights = $opendataLicence) and not(dc:subject = $opendataKeyword)">
        <dc:subject><xsl:value-of select="$opendataKeyword"/></dc:subject>
     </xsl:if>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dct="http://purl.org/dc/terms/"
  xmlns:gn="http://www.fao.org/geonetwork" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <!-- dublin-core brief and superBrief formatting -->
  <!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
  <xsl:template mode="superBrief" match="simpledc">
    <id>
      <xsl:value-of select="gn:info/id"/>
    </id>
    <uuid>
      <xsl:value-of select="gn:info/uuid"/>
    </uuid>
    <xsl:if test="dc:title">
      <title>
        <xsl:value-of select="dc:title"/>
      </title>
    </xsl:if>
    <xsl:if test="dc:description">
      <abstract>
        <xsl:value-of select="dc:description"/>
      </abstract>
    </xsl:if>
  </xsl:template>

  <xsl:template name="dublin-coreBrief">
    <metadata>
      <xsl:if test="dc:title">
        <title>
          <xsl:value-of select="dc:title"/>
        </title>
      </xsl:if>
      <xsl:if test="dc:description">
        <abstract>
          <xsl:value-of select="dc:description"/>
        </abstract>
      </xsl:if>
      
      <!-- NEOGEO 2015 : quelques champs ajoutés pour l'export CSV du GrandLyon -->
      <xsl:if test="dc:source">
        <lineage>
          <xsl:value-of select="dc:source"/>
        </lineage>
      </xsl:if>
      <xsl:if test="dct:isPartOf">
        <parentId>
          <xsl:value-of select="dct:isPartOf"/>
        </parentId>
      </xsl:if>
      <xsl:for-each select="dc:subject[text()]">
        <xsl:if test="position()=1">
          <category>
            <xsl:value-of select="."/>
          </category>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="dct:dateSubmitted">
        <dateSubmitted>
          <xsl:value-of select="dct:dateSubmitted"/>
        </dateSubmitted>
      </xsl:if>
      <xsl:if test="dct:accrualPeriodicity">
        <maintenanceAndUpdateFrequency>
          <xsl:value-of select="dct:accrualPeriodicity"/>
        </maintenanceAndUpdateFrequency>
      </xsl:if>
      <xsl:if test="dc:type">
        <type>
          <xsl:value-of select="dc:type"/>
        </type>
      </xsl:if>
      <xsl:if test="dc:publisher">
        <publisher>
          <xsl:value-of select="dc:publisher"/>
        </publisher>
      </xsl:if>
      <xsl:for-each select="dc:rights">
        <xsl:if test="position()=1">
          <legalConstraints>
            <xsl:value-of select="."/>
          </legalConstraints>
        </xsl:if>
      </xsl:for-each>
      <!-- fin ajout NEOGEO-->
      
      <xsl:for-each select="dc:subject[text()]">
        <keyword>
          <xsl:value-of select="."/>
        </keyword>
      </xsl:for-each>
      <xsl:for-each select="dc:identifier[text()]">
        <link type="url">
          <xsl:value-of select="."/>
        </link>
      </xsl:for-each>
      <!-- FIXME
      <image>IMAGE</image>
      -->
      <!-- TODO : ows:BoundingBox -->
      <xsl:variable name="coverage" select="dc:coverage"/>
      <xsl:variable name="n" select="substring-after($coverage,'North ')"/>
      <xsl:variable name="north" select="substring-before($n,',')"/>
      <xsl:variable name="s" select="substring-after($coverage,'South ')"/>
      <xsl:variable name="south" select="substring-before($s,',')"/>
      <xsl:variable name="e" select="substring-after($coverage,'East ')"/>
      <xsl:variable name="east" select="substring-before($e,',')"/>
      <xsl:variable name="w" select="substring-after($coverage,'West ')"/>
      <xsl:variable name="west" select="substring-before($w,'. ')"/>
      <xsl:variable name="p" select="substring-after($coverage,'(')"/>
      <xsl:variable name="place" select="substring-before($p,')')"/>
      <xsl:if test="$n!=''">
        <geoBox>
          <westBL>
            <xsl:value-of select="$west"/>
          </westBL>
          <eastBL>
            <xsl:value-of select="$east"/>
          </eastBL>
          <southBL>
            <xsl:value-of select="$south"/>
          </southBL>
          <northBL>
            <xsl:value-of select="$north"/>
          </northBL>
        </geoBox>
      </xsl:if>

      <xsl:copy-of select="gn:*"/>
    </metadata>
  </xsl:template>
</xsl:stylesheet>

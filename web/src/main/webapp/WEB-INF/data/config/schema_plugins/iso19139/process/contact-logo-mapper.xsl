<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exslt="http://exslt.org/common" xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                version="2.0" exclude-result-prefixes="exslt">
  <xsl:output indent="yes"/>

  <!-- The keyword separator -->
  <xsl:param name="separator">;</xsl:param>
  <!-- The keyword to search for -->
  <xsl:param name="search">GRAND LYON;VILLE DE LYON;Air Rhône-Alpes</xsl:param>
  <!-- The keyword to put in -->
  <xsl:param name="replace">http://localhost:8080/geonetwork/images/harvesting/grandlyon.gif;http://localhost:8080/geonetwork/images/harvesting/VilledeLyon.gif;http://localhost:8080/geonetwork/images/harvesting/AirRhoneAlpes.gif</xsl:param>

  <!-- Do a copy of every nodes and attributes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*" priority="2"/>

  <!-- Build a map from the inputs parameters -->
  <xsl:variable name="map">
    <xsl:for-each select="tokenize($search, $separator)">
      <xsl:variable name="pos" select="position()"/>
      <map key="{.}" value="{tokenize($replace, $separator)[position() = $pos]}"/>
    </xsl:for-each>
  </xsl:variable>

  <!--

                   <gmd:contactInstructions>
                      <gmx:FileName src="http://localhost:8080/geonetwork/images/harvesting/aodc.png"/>
                   </gmd:contactInstructions>
                </gmd:CI_Contact>
             </gmd:contactInfo>

   -->
  <xsl:template match="gmd:CI_ResponsibleParty" priority="2">
    <xsl:message>Update contact <xsl:value-of select="gmd:organisationName/gco:CharacterString"/> </xsl:message>
    <xsl:variable name="currentValue" 
      select="gmd:organisationName/gco:CharacterString"/>
    <xsl:variable name="logoUrl" 
      select="$map/map[contains($currentValue, @key)]/@value"/>
    
    <xsl:choose>
      <xsl:when test="$logoUrl != ''">
        <xsl:message> - Updating logo in contact instruction</xsl:message>
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          
          
          <xsl:message>Mapping '<xsl:value-of select="$currentValue"/>' with logo '<xsl:value-of select="$logoUrl"/>'</xsl:message>
          <xsl:copy-of select="gmd:individualName"/>
          <xsl:copy-of select="gmd:organisationName"/>
          <xsl:copy-of select="gmd:positionName"/>
          
          <xsl:choose>
            <xsl:when test="gmd:contactInfo">
              <gmd:contactInfo>
                <gmd:CI_Contact>
                  <xsl:copy-of select="gmd:contactInfo/gmd:CI_Contact/gmd:phone"/>
                  <xsl:copy-of select="gmd:contactInfo/gmd:CI_Contact/gmd:address"/>
                  <xsl:copy-of select="gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource"/>
                  <xsl:copy-of select="gmd:contactInfo/gmd:CI_Contact/gmd:hoursOfService"/>
                  <xsl:choose>
                    <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:contactInstructions">
                      <gmd:contactInstructions>
                        <gmx:FileName src="{$logoUrl}">
                          <xsl:value-of select="gmd:contactInfo/gmd:CI_Contact/gmd:contactInstructions/gco:CharacterString"/>
                        </gmx:FileName>
                      </gmd:contactInstructions>
                    </xsl:when>
                    <xsl:otherwise>
                      <gmd:contactInstructions>
                        <gmx:FileName src="{$logoUrl}"/>
                      </gmd:contactInstructions>
                    </xsl:otherwise>
                  </xsl:choose>
                </gmd:CI_Contact>
              </gmd:contactInfo>
            </xsl:when>
            <xsl:otherwise>
              <gmd:contactInfo>
                <gmd:CI_Contact>
                  <gmd:contactInstructions>
                    <gmx:FileName src="{$logoUrl}"/>
                  </gmd:contactInstructions>
                </gmd:CI_Contact>
              </gmd:contactInfo>
            </xsl:otherwise>
          </xsl:choose>
          
          <xsl:copy-of select="gmd:role"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message> - Contact not modified.</xsl:message>
        <xsl:copy>
          <xsl:apply-templates select="@*|*"/>  
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

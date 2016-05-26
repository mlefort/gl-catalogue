<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet used to add "données ouverte" keyword when "Licence ouverte" in MD_LegalConstraints
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmd="http://www.isotc211.org/2005/gmd"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:geonet="http://www.fao.org/geonetwork">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="geonet:*" priority="2"/>

    <xsl:variable name="opendataKeyword"
        select="'données ouvertes'"/>

    <xsl:variable name="opendataLicence"
        select="'Licence Ouverte'"/>

    <xsl:template match="gmd:resourceConstraints[gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString = $opendataLicence]">
       <xsl:if test="not(../gmd:descriptiveKeywords[normalize-space(string-join(gmd:MD_Keywords/gmd:keyword/gco:CharacterString, '')) = $opendataKeyword])">
            <gmd:descriptiveKeywords>
                <gmd:MD_Keywords>
                    <gmd:keyword>
                        <gco:CharacterString>données ouvertes</gco:CharacterString>
                    </gmd:keyword>
                </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
        </xsl:if>
        <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
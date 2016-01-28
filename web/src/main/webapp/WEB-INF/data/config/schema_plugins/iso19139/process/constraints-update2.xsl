<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet used to add gmd:accessConstraints with otherRestriction code in MD_LegalConstraints
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

   <xsl:template match="gmd:useConstraints[gmd:MD_RestrictionCode[@codeListValue = 'license']]">
        <xsl:if test="not(../gmd:accessConstraints[gmd:MD_RestrictionCode[@codeListValue = 'otherRestrictions']])">
            <gmd:accessConstraints>
                <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode" 
                    codeListValue="otherRestrictions"/>
            </gmd:accessConstraints>
        </xsl:if>
        <xsl:copy>
           <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="gmd:otherConstraints[not(@*|*)]"/>
</xsl:stylesheet>

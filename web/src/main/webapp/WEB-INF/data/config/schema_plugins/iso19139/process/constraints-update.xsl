<?xml version="1.0" encoding="UTF-8"?>
<!--
Stylesheet used to move INSPIRE useLimitation from MD_Constraints to MD_LegalConstraints
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

    <xsl:variable name="inspireNoRestriction" 
        select="'Pas de restriction d''accès public selon INSPIRE'"/>

    <xsl:template match="gmd:MD_LegalConstraints">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!-- Transfert and rename the first (in case you've duplicates) INSPIRE restriction -->
            <gmd:otherConstraints>
                <xsl:copy-of select="../../gmd:resourceConstraints/gmd:MD_Constraints/
                    gmd:useLimitation[1]/gco:CharacterString[
                    normalize-space(.) = $inspireNoRestriction]"/>
            </gmd:otherConstraints>
        </xsl:copy>
    </xsl:template>

    <!-- Remove MD_Constraints having only a use limitation regarding INSPIRE restriction -->
    <xsl:template match="gmd:resourceConstraints[
        count(gmd:MD_Constraints/gmd:useLimitation) = 1 and
        normalize-space(gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString) = $inspireNoRestriction
        ]"/>

    <!-- Remove MD_Constraints use limitation child only if it contains other siblings. -->
    <xsl:template match="gmd:useLimitation[normalize-space(gco:CharacterString) = $inspireNoRestriction]"/>

    <!-- Remove empty MD_Constraints -->
    <xsl:template match="gmd:resourceConstraints[
        count(gmd:MD_Constraints/*) =
        count(gmd:MD_Constraints/gmd:useLimitation[gco:CharacterString = $inspireNoRestriction])
        and count(gmd:MD_Constraints/*) > 0
        ]"/>

</xsl:stylesheet>
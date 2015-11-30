<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">

  <xsl:template mode="mode-iso19139" priority="20000"
                match="gmd:extent/gmd:EX_Extent/gmd:description">
    <div class="form-group gn-field">
      <label class="col-sm-2 control-label">
        <xsl:value-of select="gn-fn-metadata:getLabel($schema, name(), $labels)"/>
      </label>
      <div class="col-sm-9 gn-value">
        <input class="form-control" value="{gco:CharacterString}"
               name="_{gco:CharacterString/gn:element/@ref}"
               data-gn-keyword-picker=""
               data-thesaurus-key="local.place.EmprisesGL"
               type="text"/>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>

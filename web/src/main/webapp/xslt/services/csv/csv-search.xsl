<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" exclude-result-prefixes="#all">
  <!-- 
		CSV search results export.
		
		Default formatting will be column header + all tags.
		Sort order is schema based due to formatting which 
		could be different according to schema.
		
		In order to override default formatting, create a template
		with mode="csv" in the layout/tpl-csv.xsl matching the root
		element in order to create a one level tree structure :

		Example to export only title from ISO19139 records.		
		<pre>
				<xsl:template match="gmd:MD_Metadata" mode="csv">
					<xsl:param name="internalSep"/>
					
					<metadata>
						<xsl:copy-of select="geonet:info"/>
						
						<xsl:copy-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title"/>
						...
					</metadata>
				</xsl:template>
					
		</pre>
		
		The internal separator is used to join multiple objects in one
		columns (eg. keywords will be keyword1###keyword2... and could be explode 
		if needed in a spreadsheet).
	 -->
  <xsl:output method="text" version="1.0" encoding="utf-8" indent="no"/>

  <xsl:strip-space elements="*"/>

  <!-- Field separator:
		To use tab instead of semicolon, use "&#009;".
		Default is comma.
	
  <xsl:variable name="sep" select="','"/>
  <xsl:variable name="sep" select="'&#124;'"/>
  -->
  <xsl:variable name="sep" select="';'"/>
  
  <!-- Intra field separator -->
  <xsl:variable name="internalSep" select="'###'"/>

  <xsl:include href="../../common/profiles-loader-tpl-brief.xsl"/>
  <xsl:include href="../../common/profiles-loader-tpl-csv.xsl"/>

  <!-- A template to add a new line \n with no extra space. -->
  <xsl:template name="newLine">
    <xsl:text>
</xsl:text>
  </xsl:template>


  <!-- Main template -->
  <xsl:template name="content" match="/">

    <!-- Sort results first as csv output could be different from one schema to another. 
		Create the sorted set based on the search response. Use the brief mode or the csv mode if 
		available.
		-->
    <xsl:variable name="sortedResults">
      <xsl:for-each
        select="/root/csw:GetRecordsResponse/csw:SearchResults/*|
						/root/response/*[name(.)!='summary']">
        <xsl:sort select="geonet:info/schema" order="descending"/>

        <!-- Try to apply csv mode template to current metadata record -->
        <xsl:variable name="mdcsv">
          <xsl:apply-templates mode="csv" select=".">
            <xsl:with-param name="internalSep" select="$internalSep"/>
          </xsl:apply-templates>
        </xsl:variable>

        <!-- If not define just use the brief format -->
        <xsl:variable name="md">
          <xsl:choose>
            <xsl:when test=". != $mdcsv">
              <xsl:copy-of select="$mdcsv"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="brief" select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:copy-of select="exslt:node-set($md)/*[1]"/>
      </xsl:for-each>
    </xsl:variable>

    <!-- CODE ORIGINE
    <xsl:variable name="columns">
      <xsl:for-each-group select="$sortedResults/*" group-by="geonet:info/schema">
        <schema name="{current-grouping-key()}">
          <xsl:for-each-group select="current-group()/*[name(.)!='geonet:info']" group-by="name(.)">
            <column name="{name(.)}">"<xsl:value-of select="name(.)"/>"</column>
          </xsl:for-each-group>
        </schema>
      </xsl:for-each-group>
    </xsl:variable>
	-->
	
	<!-- CODE NEOGEO
    <xsl:variable name="columns">
	  <xsl:for-each-group select="$sortedResults/*" group-by="name(.)">
          <xsl:for-each-group select="current-group()/*[name(.)!='geonet:info']" group-by="name(.)">
              <column name="{name(.)}">"<xsl:value-of select="name(.)"/>"</column>
          </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:variable>
    -->
	<xsl:variable name="columns">
	  <column name="title">"Titre/Title"</column>
	  <column name="abstract">"Description"</column>
	  <column name="lineage">"Provenance/Lineage"</column>
	  <column name="parentId">"Parent"</column>
	  <column name="category">"Catégorie/Category"</column>
	  <column name="keyword">"Mot-clé/Keyword"</column>
	  <column name="dateSubmitted">"Date de publication/Date submitted"</column>
	  <column name="maintenanceAndUpdateFrequency">"Fréquence de mise à jour/Update frequency"</column>
	  <column name="geoBox">"Couverture territoriale/Geo Box"</column>
	  <column name="type">"Type"</column>
	  <column name="publisher">"Organisation/Responsible Party"</column>
	  <column name="legalConstraints">"Licence/Legal constraints"</column>
	</xsl:variable>
	
	
    <!-- Display results
				* header first (once)
				* content then.
		-->
    <xsl:for-each select="$sortedResults/*">
      <xsl:variable name="currentSchema" select="geonet:info/schema"/>
      <xsl:choose>
        <xsl:when
          test="position()!=1" /> <!-- and $currentSchema=preceding-sibling::node()/geonet:info/schema"/>-->
        <xsl:otherwise>
          <!-- CSV header, schema and id first, then from schema column list -->
          <xsl:text>"Norme/Schema"</xsl:text>
          <xsl:value-of select="$sep"/>
          <xsl:text>"Identifiant unique/UUID"</xsl:text>
          <xsl:value-of select="$sep"/>
          <!--<xsl:text>"id"</xsl:text>
          <xsl:value-of select="$sep"/>
                                                                 -->
          <!--
		  <xsl:value-of
            select="string-join($columns/schema[@name=$currentSchema]/column, 
														$sep)"/>
		  -->
		  <xsl:value-of
            select="string-join($columns/column, $sep)"/>
		  
          <xsl:call-template name="newLine"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="csvLine">
        <!--<xsl:with-param name="columns" select="$columns/schema[@name=$currentSchema]/column"/>-->
		<xsl:with-param name="columns" select="$columns/column"/>
        <xsl:with-param name="metadata" select="."/>
      </xsl:call-template>
    </xsl:for-each>

  </xsl:template>

  <!-- Dump line -->
  <xsl:template name="csvLine">
    <xsl:param name="columns"/>
    <xsl:param name="metadata"/>

    <xsl:value-of
      select="concat('&quot;', $metadata/geonet:info/schema, '&quot;', $sep, 
					 '&quot;', $metadata/geonet:info/uuid, '&quot;', $sep)"/> 
<!--				 '&quot;', $metadata/geonet:info/id, '&quot;', $sep)"/>
-->
    <xsl:for-each select="$columns">
      <xsl:variable name="currentColumn" select="@name"/>
      <xsl:text>"</xsl:text>
      <xsl:choose>
        <xsl:when test="@name='geoBox'">
          <xsl:value-of
            select="replace(replace(string-join($metadata/*[name(.)=$currentColumn]/*, $internalSep), '\n|\r\n', ''), '&quot;', '\\&quot;')"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of
            select="replace(replace(string-join($metadata/*[name(.)=$currentColumn], $internalSep), '\n|\r\n', ''), '&quot;', '\\&quot;')"
          />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>"</xsl:text>
      <xsl:value-of select="$sep"/>
    </xsl:for-each>

    <xsl:call-template name="newLine"/>
  </xsl:template>
</xsl:stylesheet>

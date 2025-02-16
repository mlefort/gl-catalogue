<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

  <xsl:include href="utility-fn.xsl"/>
  <xsl:include href="utility-tpl.xsl"/>
  
  <!-- ===================================================================== -->
  <!-- === iso19139 brief formatting === -->
  <!-- ===================================================================== -->
  <xsl:template mode="superBrief" match="gmd:MD_Metadata|*[@gco:isoType='gmd:MD_Metadata']"
    priority="2">
    <xsl:variable name="langId" select="gn-fn-iso19139:getLangId(., $lang)"/>

    <id>
      <xsl:value-of select="gn:info/id"/>
    </id>
    <uuid>
      <xsl:value-of select="gn:info/uuid"/>
    </uuid>
    <title>
      <xsl:apply-templates mode="localised"
        select="gmd:identificationInfo/*/gmd:citation/*/gmd:title">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </title>
    <abstract>
      <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
        <xsl:with-param name="langId" select="$langId"/>
      </xsl:apply-templates>
    </abstract>
  </xsl:template>

  <xsl:template name="iso19139Brief">
    <metadata>
      <xsl:call-template name="iso19139-brief"/>
    </metadata>
  </xsl:template>

  <xsl:template name="iso19139-brief">
    <xsl:variable name="download_check">
      <xsl:text>&amp;fname=&amp;access</xsl:text>
    </xsl:variable>
    <xsl:variable name="info" select="gn:info"/>
    <xsl:variable name="id" select="$info/id"/>
    <xsl:variable name="uuid" select="$info/uuid"/>

    <xsl:if test="normalize-space(gmd:parentIdentifier/*)!=''">
      <parentId>
        <xsl:value-of select="gmd:parentIdentifier/*"/>
      </parentId>
    </xsl:if>

    <xsl:variable name="langId" select="gn-fn-iso19139:getLangId(., $lang)"/>
    
    <xsl:apply-templates mode="briefster" select="gmd:identificationInfo/*">
      <xsl:with-param name="id" select="$id"/>
      <xsl:with-param name="langId" select="$langId"/>
      <xsl:with-param name="info" select="$info"/>
    </xsl:apply-templates>

    <xsl:for-each
      select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
      <xsl:variable name="protocol" select="gmd:protocol[1]/gco:CharacterString"/>
      <xsl:variable name="linkage" select="normalize-space(gmd:linkage/gmd:URL)"/>
      <xsl:variable name="name">
        <xsl:for-each select="gmd:name">
          <xsl:call-template name="localised">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="mimeType" select="normalize-space(gmd:name/gmx:MimeFileType/@type)"/>

      <xsl:variable name="desc">
        <xsl:for-each select="gmd:description">
          <xsl:call-template name="localised">
            <xsl:with-param name="langId" select="$langId"/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:variable>

      <xsl:if test="string($linkage)!=''">
        <xsl:element name="link">
          <xsl:attribute name="title" select="$desc"/>
          <xsl:attribute name="href" select="$linkage"/>
          <xsl:attribute name="name" select="$name"/>
          <xsl:attribute name="protocol" select="$protocol"/>
          <xsl:attribute name="type"
            select="gn-fn-core:protocolMimeType($linkage, $protocol, $mimeType)"/>
        </xsl:element>

      </xsl:if>

      <!-- Generate a KML output link for a WMS service -->
      <xsl:if
        test="string($linkage)!='' and starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-map') and string($linkage)!='' and string($name)!=''">

        <xsl:element name="link">
          <xsl:attribute name="title">
            <xsl:value-of select="$desc"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of
              select="concat('http://',$env/system/server/host,':',$env/system/server/port,
              /root/gui/locService, '/google.kml?uuid=', $uuid, '&amp;layers=', $name)"
            />
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$name"/>
          </xsl:attribute>
          <xsl:attribute name="type">application/vnd.google-earth.kml+xml</xsl:attribute>
        </xsl:element>
      </xsl:if>

      <!-- The old links still in use by some systems. Deprecated -->
      <xsl:choose>
        <xsl:when
          test="matches($protocol,'^WWW:DOWNLOAD-.*-http--download.*') and not(contains($linkage,$download_check))">
          <link type="download">
            <xsl:value-of select="$linkage"/>
          </link>
        </xsl:when>
        <xsl:when
          test="starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-map') and string($linkage)!='' and string($name)!=''">
          <link type="wms">
            <xsl:value-of
              select="concat('javascript:addWMSLayer([[&#34;' , $name , '&#34;,&#34;' ,  $linkage  ,  '&#34;, &#34;', $name  ,'&#34;,&#34;',$id,'&#34;]])')"
            />
          </link>
          <link type="googleearth">
            <xsl:value-of
              select="concat(/root/gui/locService,'/google.kml?uuid=',$uuid,'&amp;layers=',$name)"/>
          </link>
        </xsl:when>
        <xsl:when
          test="starts-with($protocol,'OGC:WMS-') and contains($protocol,'-get-capabilities') and string($linkage)!=''">
          <link type="wms">
            <!--xsl:value-of select="concat('javascript:runIM_selectService(&#34;'  ,  $linkage  ,  '&#34;, 2,',$id,')' )"/-->
            <xsl:value-of
              select="concat('javascript:addWMSLayer([[&#34;' , $name , '&#34;,&#34;' ,  $linkage  ,  '&#34;, &#34;', $name  ,'&#34;,&#34;',$id,'&#34;]])')"
            />
          </link>
        </xsl:when>
        <xsl:when test="string($linkage)!=''">
          <link type="url">
            <xsl:value-of select="$linkage"/>
          </link>
        </xsl:when>

      </xsl:choose>
    </xsl:for-each>

    <xsl:for-each select="gmd:contact/*">
      <xsl:variable name="role" select="gmd:role/*/@codeListValue"/>
      <xsl:if test="normalize-space($role)!=''">
        <responsibleParty role="{$role}" appliesTo="metadata">
          <xsl:apply-templates mode="responsiblepartysimple" select="."/>
        </responsibleParty>
      </xsl:if>
    </xsl:for-each>
    
    <xsl:for-each select="gmd:dataQualityInfo/*/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString">
      <lineage>
        <xsl:value-of select="."/>
      </lineage>
    </xsl:for-each>
        
    <metadatacreationdate>
      <xsl:value-of select="gmd:dateStamp/*"/>
    </metadatacreationdate>
    
    <type>
      <xsl:value-of select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
    </type>
    
    <gn:info>
      <xsl:copy-of select="gn:info/*[name(.)!='edit']"/>
      <xsl:choose>
        <xsl:when
          test="$env/harvester/enableEditing='false' and gn:info/isHarvested='y' and gn:info/edit='true'">
          <edit>false</edit>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="gn:info/edit"/>
        </xsl:otherwise>
      </xsl:choose>


      <!-- 
          Internal category could be define using different informations
        in a metadata record (according to standard). This could be improved.
        This type of categories could be added to Lucene index also in order
        to be queriable. 
        Services and datasets are at least the required internal categories
        to be distinguished for INSPIRE requirements (hierarchyLevel could be
        use also). TODO
        -->
      <category internal="true">
        <xsl:choose>
          <xsl:when test="gmd:identificationInfo/srv:SV_ServiceIdentification">service</xsl:when>
          <xsl:otherwise>dataset</xsl:otherwise>
        </xsl:choose>
      </category>
    </gn:info>
  </xsl:template>

  <xsl:template mode="briefster" match="*">
    <xsl:param name="id"/>
    <xsl:param name="langId"/>
    <xsl:param name="info"/>

    <xsl:if test="gmd:citation/gmd:CI_Citation/gmd:title">
      <title>
        <xsl:apply-templates mode="localised" select="gmd:citation/gmd:CI_Citation/gmd:title">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </title>
    </xsl:if>

    <xsl:if test="gmd:citation/*/gmd:date/*/gmd:dateType/*[@codeListValue='creation']">
      <datasetcreationdate>
        <xsl:value-of select="gmd:citation/*/gmd:date/*/gmd:date/gco:DateTime"/>
      </datasetcreationdate>
    </xsl:if>

    <xsl:if test="gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue[. = 'publication']">
      <dateSubmitted>
        <xsl:value-of select="gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date"/>
      </dateSubmitted>
    </xsl:if>
    
    <xsl:if test="gmd:abstract">
      <abstract>
        <xsl:apply-templates mode="localised" select="gmd:abstract">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </abstract>
    </xsl:if>

    <xsl:for-each select="gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/
                          gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue[. != '']">
      <maintenanceAndUpdateFrequency>
          <xsl:value-of select="."/>
      </maintenanceAndUpdateFrequency>
    </xsl:for-each>
    <xsl:if test="gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/
                  gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue[. = 'continual']">
      <maintenanceAndUpdateFrequency>      
        <xsl:value-of select="gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:userDefinedMaintenanceFrequency/gts:TM_PeriodDuration"/>
      </maintenanceAndUpdateFrequency>
    </xsl:if>
    
    <xsl:for-each select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
      <publisher>
          <xsl:value-of select="."/>
      </publisher>
    </xsl:for-each>
        
    <xsl:for-each select="gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useLimitation/gco:CharacterString">
      <xsl:if test="position()=1">
        <legalConstraints>
          <xsl:value-of select="."/>
        </legalConstraints>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select=".//gmd:keyword[not(@gco:nilReason)]">
      <xsl:if test="position()=1">
        <category>
          <xsl:value-of select="gco:CharacterString"/>
        </category>
      </xsl:if>
      <keyword>
        <xsl:apply-templates mode="localised" select=".">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </keyword>
    </xsl:for-each>

    <xsl:for-each select="gmd:extent/*/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
      <geoBox>
        <westBL>
          <xsl:value-of select="gmd:westBoundLongitude"/>
        </westBL>
        <eastBL>
          <xsl:value-of select="gmd:eastBoundLongitude"/>
        </eastBL>
        <southBL>
          <xsl:value-of select="gmd:southBoundLatitude"/>
        </southBL>
        <northBL>
          <xsl:value-of select="gmd:northBoundLatitude"/>
        </northBL>
      </geoBox>
    </xsl:for-each>

    <xsl:for-each select="*/gmd:MD_Constraints/*">
      <Constraints preformatted="true">
        <xsl:apply-templates mode="iso19139" select=".">
          <xsl:with-param name="schema" select="$info/schema"/>
          <xsl:with-param name="edit" select="false()"/>
        </xsl:apply-templates>
      </Constraints>
      <Constraints preformatted="false">
        <xsl:copy-of select="."/>
      </Constraints>
    </xsl:for-each>

    <xsl:for-each select="*/gmd:MD_SecurityConstraints/*">
      <SecurityConstraints preformatted="true">
        <xsl:apply-templates mode="iso19139" select=".">
          <xsl:with-param name="schema" select="$info/schema"/>
          <xsl:with-param name="edit" select="false()"/>
        </xsl:apply-templates>
      </SecurityConstraints>
      <SecurityConstraints preformatted="false">
        <xsl:copy-of select="."/>
      </SecurityConstraints>
    </xsl:for-each>

    <xsl:for-each select="*/gmd:MD_LegalConstraints/*">
      <LegalConstraints preformatted="true">
        <xsl:apply-templates mode="iso19139" select=".">
          <xsl:with-param name="schema" select="$info/schema"/>
          <xsl:with-param name="edit" select="false()"/>
        </xsl:apply-templates>
      </LegalConstraints>
      <LegalConstraints preformatted="false">
        <xsl:copy-of select="."/>
      </LegalConstraints>
    </xsl:for-each>

    <xsl:for-each select="gmd:extent/*/gmd:temporalElement/*/gmd:extent/gml:TimePeriod">
      <temporalExtent>
        <begin>
          <xsl:apply-templates mode="brieftime"
            select="gml:beginPosition|gml:begin/gml:TimeInstant/gml:timePosition"/>
        </begin>
        <end>
          <xsl:apply-templates mode="brieftime"
            select="gml:endPosition|gml:end/gml:TimeInstant/gml:timePosition"/>
        </end>
      </temporalExtent>
    </xsl:for-each>

    <xsl:if test="not($info/server)">
      <xsl:for-each select="gmd:graphicOverview/gmd:MD_BrowseGraphic">
        <xsl:variable name="fileName" select="gmd:fileName/gco:CharacterString"/>
        <xsl:if test="$fileName != ''">
          <xsl:variable name="fileDescr" select="gmd:fileDescription/gco:CharacterString"/>
          <xsl:choose>

            <!-- the thumbnail is an url -->

            <xsl:when test="contains($fileName ,'://')">
              <image type="unknown">
                <xsl:value-of select="$fileName"/>
              </image>
            </xsl:when>

            <!-- small thumbnail -->

            <xsl:when test="string($fileDescr)='thumbnail'">
              <xsl:choose>
                <xsl:when test="$info/isHarvested = 'y'">
                  <xsl:choose>
                    <xsl:when test="$info/harvestInfo/smallThumbnail">
                      <image type="thumbnail">
                        <xsl:value-of select="concat($info/harvestInfo/smallThumbnail, $fileName)"/>
                      </image>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- When harvested, thumbnail is stored in local node (eg. ogcwxs). 
                        Only GeoNetHarvester set smallThumbnail elements.
                        -->
                      <image type="thumbnail">
                        <xsl:value-of
                          select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"
                        />
                      </image>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                  <image type="thumbnail">
                    <xsl:value-of
                      select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"
                    />
                  </image>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>

            <!-- large thumbnail -->

            <xsl:when test="string($fileDescr)='large_thumbnail'">
              <xsl:choose>
                <xsl:when test="$info/isHarvested = 'y'">
                  <xsl:if test="$info/harvestInfo/largeThumbnail">
                    <image type="overview">
                      <xsl:value-of select="concat($info/harvestInfo/largeThumbnail, $fileName)"/>
                    </image>
                  </xsl:if>
                </xsl:when>

                <xsl:otherwise>
                  <image type="overview">
                    <xsl:value-of
                      select="concat(/root/gui/locService,'/resources.get?id=',$id,'&amp;fname=',$fileName,'&amp;access=public')"
                    />
                  </image>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>

          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>

    <xsl:for-each select="gmd:pointOfContact/*">
      <xsl:variable name="role" select="gmd:role/*/@codeListValue"/>
      <xsl:if test="normalize-space($role)!=''">
        <responsibleParty role="{$role}" appliesTo="resource">
          <xsl:if test="descendant::*/gmx:FileName">
            <xsl:attribute name="logo">
              <xsl:value-of select="descendant::*/gmx:FileName/@src"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates mode="responsiblepartysimple" select="."/>
        </responsibleParty>
      </xsl:if>
    </xsl:for-each>
    
  </xsl:template>
</xsl:stylesheet>

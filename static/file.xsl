<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
  <xsl:output method="text" omit-xml-declaration="yes" />
  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:variable name="contents" select="document('file.xsd')" />
  <xsl:variable name="complexTypes" select="$contents//xs:complexType[@name]" />
  <xsl:template match="/" >
    <xsl:for-each select="$contents" >
      <xsl:apply-templates select=".//xs:element" />
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="xs:element">
    <xsl:variable name="complexType" select="xs:complexType[not(@name)]|$complexTypes[@name=current()/@type]" />
    <xsl:if test="$complexType">
     <xsl:variable name="fields"
       select="$complexType/xs:sequence/xs:element[not(@type=$complexTypes/@name)]|$complexType/xs:all/xs:element[not(@type=$complexTypes/@name)]|$complexType/xs:attribute|$complexType/xs:simpleContent|$complexType/xs:simpleContent/xs:extension/xs:attribute | $complexType/xs:choice/xs:element[not(@type=$complexTypes/@name)]"/>
      <xsl:if test="$fields">
        <xsl:variable name="tableName" select="@name" />
        <xsl:variable name="generatedKey" select="concat($tableName, '_id')" />
        <xsl:text>##CREATE TABLE </xsl:text>
        <xsl:value-of select="$tableName" />
        <xsl:text> &#10;( &#10;</xsl:text>
        <xsl:variable name="primaryKey"
         select="//xs:key[@msdata:PrimaryKey='true'][xs:selector[@xpath=concat('.//mstns:',$tableName)]]" />
        <xsl:if test="not($primaryKey)" >
          <xsl:text>&#9;</xsl:text>
          <xsl:value-of select="$generatedKey"/>
          <xsl:text> int ,&#10;</xsl:text>
        </xsl:if>
        <xsl:variable name="fk" select="$fields[@type='xs:complexType']/@name"/>
        <xsl:variable name="ancestorTables" select="ancestor::xs:element[@name][not(@msdata:IsDataSet)][xs:complexType[xs:sequence[xs:element[@type]] or xs:attribute[@type] or xs:simpleContent]]|$contents//xs:element[@type=current()/ancestor::*/@name]" />
        <xsl:if test="$fk">
          <xsl:variable name="foreignKey" select="concat( $fk, '_id' )" />
          <xsl:text>&#9;</xsl:text>
          <xsl:value-of select="$foreignKey" />
          <xsl:text> int,&#10;&#10;</xsl:text>
          <xsl:text> CONSTRAINT FK_</xsl:text>
          <xsl:value-of select="$tableName"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="$fk" />
          <xsl:text> FOREIGN KEY (</xsl:text>
          <xsl:value-of select="$foreignKey" />
          <xsl:text>) REFERENCES </xsl:text>
          <xsl:value-of select="$fk" />
          <xsl:text> ( </xsl:text>
          <xsl:value-of select="$foreignKey" />
          <xsl:text> )&#10;</xsl:text>
        </xsl:if>
        <xsl:if test="$ancestorTables/..='xs:complexType' and not($fk)">
          <xsl:variable name="foreignKey" select="concat( $ancestorTables[1]/@name, '_id' )" />
          <xsl:text>&#9;</xsl:text>
          <xsl:value-of select="$foreignKey" />
          <xsl:text> int,&#10;&#10;</xsl:text>
          <xsl:text> CONSTRAINT FK_</xsl:text>
          <xsl:value-of select="$tableName"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="$ancestorTables[1]/@name" />
          <xsl:text> FOREIGN KEY REFERENCES </xsl:text>
          <xsl:value-of select="$ancestorTables[1]/@name" />
          <xsl:text> </xsl:text>
          <xsl:text> ( </xsl:text>
          <xsl:value-of select="$foreignKey" />
          <xsl:text> ),&#10;</xsl:text>
        </xsl:if>
        <xsl:for-each select="$fields[not(@type=$complexTypes/@name)]">
          <xsl:text>&#9;</xsl:text>
          <xsl:if test="not($fields[@type=xs:complexType])">
            <xsl:choose>
              <xsl:when test="@msdata:ColumnName">
                <xsl:value-of select="@msdata:ColumnName" />
              </xsl:when>
              <xsl:when test="@name">
                <xsl:value-of select="@name" />
              </xsl:when>
              <xsl:when test="local-name()='simpleContent'">
                <xsl:value-of select="concat(parent::*/@name,'_Text')" />
              </xsl:when>
            </xsl:choose>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="@type">
              <xsl:call-template name="Types">
                <xsl:with-param name="type" select="@type" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="Types">
                <xsl:with-param name="type" select="xs:extension/@base" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="@msdata:AutoIncrement='true'">
            <xsl:text> </xsl:text>
            <xsl:choose>
              <xsl:when test="@msdata:AutoIncrementSeed">
                <xsl:value-of select="@msdata:AutoIncrementSeed"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text></xsl:text>
            <xsl:choose>
              <xsl:when test="@msdata:AutoIncrementStep">
                <xsl:value-of select="@msdata:AutoIncrementStep" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text></xsl:text>
          </xsl:if>
          <xsl:if test="@minOccurs=0"> NULL</xsl:if>
          <xsl:if test="position()&lt;last()">,</xsl:if>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="$primaryKey">
            <xsl:text>&#10;&#9;,PRIMARY KEY ( </xsl:text>
            <xsl:for-each select="$primaryKey/xs:field">
              <xsl:text></xsl:text>
              <xsl:value-of select="substring-after(@xpath, 'mstns:')" />
              <xsl:text></xsl:text>
              <xsl:if test="position()&lt;last()">, </xsl:if>
            </xsl:for-each>
            <xsl:text> )</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>&#10;&#9;,PRIMARY KEY ( </xsl:text>
            <xsl:value-of select="$generatedKey" />
            <xsl:text> )</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#10;);</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>
  <xsl:template name="Types">
    <xsl:param name="type" />
    <xsl:choose>
      <xsl:when test="substring-after($type,':')='int'">&#9;int</xsl:when>
      <xsl:when test="substring-after($type, ':')='string'">&#9;varchar<xsl:if test="local-name()!='restriction'">(255)</xsl:if></xsl:when>
      <xsl:when test="$type='money_type'">money</xsl:when>
      <xsl:when test="substring-after($type,':')='nonNegativeInteger'">int</xsl:when>
      <xsl:when test="substring-after($type,':')='date'">datetime</xsl:when>
      <xsl:when test="substring-after($type,':')='boolean'">bit</xsl:when>
      <xsl:when test="substring-after($type,':')='decimal'">decimal(19,9)</xsl:when>
      <xsl:when test="substring-after($type,':')='gYearMonth'">datetime</xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$contents//xs:simpleType[@name=$type]" mode="derivedType" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="xs:restriction" mode="derivedType" >
    <xsl:call-template name="Types">
      <xsl:with-param name="type">
        <xsl:value-of select="@base"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates mode="derivedType" />
  </xsl:template>
  <xsl:template match="xs:maxLength" mode="derivedType" >
    (<xsl:value-of select="@value" />)
  </xsl:template>
</xsl:stylesheet>
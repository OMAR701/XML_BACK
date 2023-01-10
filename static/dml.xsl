<?xml version="1.0" encoding="UTF-8" ?>

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text" encoding="UTF-8"/>

    <xsl:template match="/">
      <xsl:variable name="root" select="."/>
      <xsl:text>"INSERT INTO </xsl:text>
      <xsl:value-of select="name(*)"/>
      <xsl:text>(</xsl:text>
      <xsl:for-each select="*/@*">
        <xsl:value-of select="name()"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="count(*/@*) > 0">
        <xsl:text>, </xsl:text>
      </xsl:if>



      <xsl:for-each select="*/*">
        <xsl:value-of select="name()"/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <xsl:text> values(</xsl:text>
      <xsl:for-each select="*/@*">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="count(*/@*) > 0">
        <xsl:text>, </xsl:text>
      </xsl:if>

      <xsl:for-each select="*/*">
          <xsl:value-of select="."/>
          <xsl:if test="position() != last()">
              <xsl:text>, </xsl:text>
          </xsl:if>
      </xsl:for-each>
      <xsl:text>);"</xsl:text>
    </xsl:template>

</xsl:transform>





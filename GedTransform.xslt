<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes"/>

  <!--
  Main root 
  -->
  <xsl:template match="/">
    <xsl:element name="FamilyTree">
      <xsl:element name="Individuals">
        <xsl:attribute name="count">
          <xsl:value-of select="count(/INDI)"/>
        </xsl:attribute>
        <xsl:apply-templates select="*/INDI"/>
      </xsl:element>
      <xsl:element name="Families">
        <xsl:apply-templates select="*/FAM"/>
      </xsl:element>
      <xsl:element name="Sources">
        <xsl:apply-templates select="*/SOUR"/>
      </xsl:element>
      <xsl:element name="Repositories">
        <xsl:apply-templates select="*/REPO"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Level 0 Items -->
  <xsl:template match="INDI">
    <xsl:element name="Individual">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="gender">
        <xsl:value-of select="SEX"/>
      </xsl:attribute>
      <xsl:element name="Names">
        <xsl:apply-templates select="NAME"/>
      </xsl:element>
      <xsl:element name="Residences">
        <xsl:apply-templates select="RESI"/>
      </xsl:element>
      <xsl:element name="Events">
        <xsl:apply-templates select="BIRT | DEAT | EVEN"/>
      </xsl:element>
      <xsl:element name="Families">
        <xsl:element name ="AsSpouse">
          <xsl:apply-templates select="FAMS"/>
        </xsl:element>
        <xsl:element name ="AsChild">
          <xsl:apply-templates select="FAMC"/>
        </xsl:element>
      </xsl:element>
      <!--<xsl:apply-templates select="*"/>-->
    </xsl:element>
  </xsl:template>

  <xsl:template match="FAM">
    <xsl:element name="Family">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="HUSB"/>
      <xsl:apply-templates select="WIFE"/>
      <xsl:element name="Children">
        <xsl:for-each select="CHIL">
          <xsl:element name="Child">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="father_relation">
              <xsl:value-of select="_FREL"/>
            </xsl:attribute>
            <xsl:attribute name="mother_relation">
              <xsl:value-of select="_MREL"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name="Events">
        <xsl:apply-templates select=" MARR | EVEN"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="HUSB">
    <xsl:element name="Husband">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="WIFE">
    <xsl:element name="Wife">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="SOUR">
    <xsl:element name="Source">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <!-- Level 2 items -->
  <xsl:template match="FAMC | FAMS">
    <xsl:element name="FamilyLink">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="RESI">
    <xsl:element name="Residence">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="NAME">
    <xsl:element name="Name">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BIRT">
    <xsl:element name="Birth">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="DEAT">
    <xsl:element name="Death">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="MARR">
    <xsl:element name="Marriage">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CONT">
    <xsl:element name="Cont">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CONC">
    <xsl:element name="Conc">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="year-only">
    <xsl:param name="date" />
    <xsl:choose>
      <xsl:when test="contains($date, ' ')">
        <xsl:call-template name="year-only">
          <xsl:with-param name="date" select="substring-after($date, ' ')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$date" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="DATE">
    <xsl:element name="Date">
      <xsl:attribute name="year">
        <xsl:call-template name="year-only">
          <xsl:with-param name="date" select="node()" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="NOTE">
    <xsl:element name="Notes">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="TEXT">
    <xsl:element name="Text">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PAGE">
    <xsl:element name="Page">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PLAC">
    <xsl:element name="Place">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="DATA">
    <xsl:element name="Data">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="REPO">
    <xsl:element name="Repository">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ADDR">
    <xsl:element name="Address">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="TITL">
    <xsl:element name="Title">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="AUTH">
    <xsl:element name="Author">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PUBL">
    <xsl:element name="Publication">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="node()"/>
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>

  <!-- Special case items -->
  <xsl:template match="_APID | SEX"/>

  <xsl:template match="*">
    <UNKNOWN_TAG>
      <xsl:copy/>
    </UNKNOWN_TAG>
  </xsl:template>

</xsl:stylesheet>

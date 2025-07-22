<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="tei:div">
        <div><xsl:apply-templates/></div>
    </xsl:template>
   
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:lb[@rend='line']">
        <hr />
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit='hr']">
        <hr />
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit='asterism']">
        <div class="text-center"> * * * </div>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit='asterisk']">
        <div class="text-center"> * </div>
    </xsl:template>
    
    <xsl:template match="tei:milestone[@unit='3dots']">...</xsl:template>

    <xsl:template match="tei:list[@type='unordered']">
        <xsl:choose>
            <xsl:when test="ancestor::tei:body">
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:item">
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type='unordered']|ancestor::tei:body">
                <li><xsl:apply-templates/></li>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <span id="{./@xml:id}" class="w"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:fw">
        <div class="tei-fw">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:hi">
        <span class="{./@rend}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:ref[@target]">
        <a>
            <xsl:choose>
                <xsl:when test="contains(./@target, '.xml')">
                    <xsl:attribute name="href">
                        <xsl:value-of select="replace(./@target, '.xml', '.html')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="href">
                        <xsl:value-of select="./@target"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="tei:lg">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:l">
        <xsl:apply-templates/><br/>
    </xsl:template>
    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test=".[@rend]">
                <p class="{@rend}"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <p class="tei-p"><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:listOrg">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:div//tei:title">
        <div class="tei-title"><xsl:apply-templates/></div>
    </xsl:template>
   
</xsl:stylesheet>

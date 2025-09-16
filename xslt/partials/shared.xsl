<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:template match="tei:head">
        <h2 class="fs-5 text-center"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:fw[@type='header']">
        <div class="row">
            <div class="col-md-4">
                <xsl:apply-templates select="./tei:fw[@place='top_left']"/>
            </div>
            <div class="col-md-4">
                <xsl:apply-templates select="./tei:fw[@place='top_center']"/>
            </div>
            <div class="col-md-4">
                <xsl:apply-templates select="./tei:fw[@place='top_right']"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:seg[@rend='italicised']">
        <span class="dse-italics"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="tei:seg[@rend='spaced']">
        <span class="dse-spaced"><xsl:apply-templates/></span>
    </xsl:template>

    <xsl:template match="tei:seg[@rend='bold']">
        <span class="dse-bold"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div><xsl:apply-templates/></div>
    </xsl:template>
   
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:lb[@break='no']">-<br/></xsl:template>
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
    
    <xsl:template match="tei:w"><span id="{./@xml:id}" class="w"><xsl:apply-templates/></span></xsl:template>
    <xsl:template match="tei:pc"><span class="dse-pc"><xsl:apply-templates/></span></xsl:template>
    
    <xsl:template match="tei:fw">
        <div class="dse-fw">
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
                <p class="dse-{@rend}"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <p class="dse-p"><xsl:apply-templates/></p>
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
        <div class="dse-title"><xsl:apply-templates/></div>
    </xsl:template>
   
</xsl:stylesheet>

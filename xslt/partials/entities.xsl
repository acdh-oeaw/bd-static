<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./person.xsl"/>
    <xsl:import href="./place.xsl"/>

    <xsl:template match="tei:rs[starts-with(@ref, '#') and @type]">
        <xsl:variable name="entType" select="@type"/>
        <xsl:variable name="entId" select="./@ref"/>
        <xsl:variable name="entityXmlId" select="substring-after($entId, '#')"/>

        <!-- Only create button if there's a matching entity with the same @xml:id -->
        <xsl:choose>
            <xsl:when test="//tei:person[@xml:id = $entityXmlId] or //tei:place[@xml:id = $entityXmlId]">
                <button class="{$entType} entity" data-bs-toggle="modal" data-bs-target="{@ref}">
                    <xsl:apply-templates/>
                </button>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:listPlace">
        <xsl:apply-templates/>
    </xsl:template>



    <xsl:template match="tei:person">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./@n"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}">
                                <xsl:value-of select="$label"/>
                            </a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="person_detail"/>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:place">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:placeName[1]"/>
        </xsl:variable>
        <div class="modal modal fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-label="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">
                            <a href="{$selfLink}">
                                <xsl:value-of select="$label"/>
                            </a>
                        </h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="place_detail"/>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>



</xsl:stylesheet>
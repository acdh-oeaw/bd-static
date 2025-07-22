<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Hefte'"/>
        <xsl:variable name="schaubuehne-url" select="'https://schaubuehne.oeaw.ac.at/php/getPage.php?keyString='"/>

        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">
                                    <xsl:value-of select="$project_short_title"/>
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                <xsl:value-of select="$doc_title"/>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="text-center">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div class="row">
                            <xsl:for-each select="collection('../data/editions?select=*a0001.xml')//tei:TEI[.//tei:titleStmt/tei:title[@level='a']/text()]">
                                <xsl:sort select="data(@xml)"></xsl:sort>
                                <xsl:variable name="id">
                                    <xsl:value-of select="replace(./@xml:id, '.xml', '.html')"/>
                                </xsl:variable>
                                <xsl:variable name="title">
                                    <xsl:value-of select=".//tei:titleStmt/tei:title[@level='a']"/>
                                </xsl:variable>
                                <xsl:variable name="teiSource">
                                    <xsl:value-of select="data(./@xml:id)"/>
                                </xsl:variable>
                                <xsl:variable name="facs-url">
                                    <xsl:value-of select=".//tei:pb[1]/@facs"/>
                                </xsl:variable>
                                <div class="col">
                                    <div class="card p-2" style="width: 18rem;">
                                        <a href="{$id}">
                                            <img src="{$facs-url}" class="card-img-top" alt="Titelbild von: {$title}" loading="lazy"/>
                                        </a>
                                        <div class="card-body">
                                            <p class="card-text">
                                                <a href="{$id}">
                                                    <xsl:value-of select="$title"/>
                                                </a>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </xsl:for-each>

                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
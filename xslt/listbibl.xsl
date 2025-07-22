<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Textverzeichnis'"/>
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
                                <a href="index.html"><xsl:value-of select="$project_short_title"/></a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$doc_title"/></li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1"><span id="counter1"></span> of <span id="counter2"></span> Texte</div>
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input">Autor*In</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="300">Titel</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false" tabulator-download="true">Titel_</th>
                                    <th scope="col" tabulator-headerFilter="input" >Stelle</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false" tabulator-download="true">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:bibl[@xml:id]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="concat(./@xml:id, '.html')"/>
                                    </xsl:variable>
                                    <xsl:variable name="title">
                                        <xsl:value-of select="./tei:title[@level='a']"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="./tei:author"/>
                                        </td>
                                        <td>
                                            <a href="{$id}">
                                                <xsl:value-of select="$title"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$title"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="replace(./tei:title[@level='j'], 'Die Schaubühne, ', '')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote">
                                <xsl:with-param name="pageId" select="'toc.html'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
        <xsl:for-each select=".//tei:bibl[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:title[1]//text()))"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="{$default_lang}">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>
                    
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="index.html"><xsl:value-of select="$project_title"/></a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="listbibl.html">Textverzeichnis</a>
                                </li>
                                <xsl:choose>
                                    <xsl:when test="./tei:author/@key">
                                        <li class="breadcrumb-item">
                                            <a href="{replace(./tei:author/@key, '#', '')||'.html'}"><xsl:value-of select="./tei:author"/></a>
                                        </li>
                                    </xsl:when>
                                </xsl:choose>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <dl>
                                    <dt>Autor*In</dt>
                                    <dd>
                                        <xsl:choose>
                                            <xsl:when test="./tei:author/@key">
                                                <a href="{replace(./tei:author/@key, '#', '')||'.html'}">
                                                    <xsl:value-of select="./tei:author"/>
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./tei:author"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </dd>
                                    <dt>Stelle</dt>
                                    <dd>
                                        <a href="{replace(./tei:idno, '.xml', '.html')}">
                                            <xsl:value-of select="./tei:title[@level='j']"/>, <xsl:value-of select="./tei:biblScope"/>
                                        </a>
                                    </dd>
                                </dl>
                                <div class="text-center p-4">
                                    <xsl:call-template name="blockquote">
                                        <xsl:with-param name="pageId" select="$filename"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
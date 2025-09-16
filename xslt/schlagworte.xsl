<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:bdk="https://vocabs.acdh.oeaw.ac.at/traveldigital/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/> 
   
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/org.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Schlagwortverzeichnis'" />
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
                                <li class="breadcrumb-item active">
                                    <xsl:value-of select="$doc_title"/>
                                </li>
                            </ol>
                        </nav>
                        <div class="container">                        
                            <h1 class="text-center">
                                <xsl:value-of select="$doc_title"/>
                            </h1>
                            <div class="text-center p-1"><span id="counter1"></span> of <span id="counter2"></span> Schlagwörter</div>
                            
                            <table id="myTable">
                                <thead>
                                    <tr>
                                        <th scope="col" width="20" tabulator-formatter="html" tabulator-headerSort="false" tabulator-download="false">#</th>
                                        <th scope="col" tabulator-headerFilter="input">Name</th>
                                        <th scope="col" tabulator-headerFilter="input">ID</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select=".//tei:item[@corresp]">
                                        <xsl:variable name="id" select="concat(replace(replace(@corresp, 't:', ''), '\.', '-'), '.html')"/>
                                        <tr>
                                            <td>
                                                <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$id"/>
                                                  </xsl:attribute>
                                                  <i class="bi bi-link-45deg"/>
                                                </a>
                                            </td>
                                            <td>
                                                <xsl:value-of select="data(@n)"/>
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
                                    <xsl:with-param name="pageId" select="'listorg.html'"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </main>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
        <xsl:for-each select=".//tei:item[@corresp]">
            <xsl:variable name="id" select="concat(replace(replace(@corresp, 't:', ''), '\.', '-'), '.html')"/>
            <xsl:variable name="name" select="@n"></xsl:variable>
            <xsl:result-document href="{$id}">
                <html class="h-100" lang="{$default_lang}">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
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
                                    <li class="breadcrumb-item">
                                        <a href="schlagworte.html">Schlagwörter</a>
                                    </li>
                                    <li class="breadcrumb-item active">
                                        <xsl:value-of select="$name"/>
                                    </li>
                                </ol>
                            </nav>
                            <div class="container">
                                <h1 class="text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="org_detail"/>
                                <div class="text-center p-4">
                                    <xsl:call-template name="blockquote">
                                        <xsl:with-param name="pageId" select="$id"/>
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
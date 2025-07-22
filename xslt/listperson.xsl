<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    
        
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Personenregister'"/>
        </xsl:variable>
        <xsl:variable name="listperson" select="document('../data/indices/listperson.xml')" as="document-node()"/>
        <html class="h-100" lang="de">
            
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
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1"><span id="counter1"></span> von <span id="counter2"></span> Personen</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="350">Name</th>
                                    <th scope="col" tabulator-visible="false" tabulator-download="true">name_</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="textarea">Beruf</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-maxWidth="200">Texte</th>
                                    <th scope="col" tabulator-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:person[@xml:id]">
                                    <xsl:sort select="data(@n)"></xsl:sort>
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <xsl:variable name="label">
                                        <xsl:value-of select="data(@n)"/>
                                    </xsl:variable>

                                    <tr>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat($id, '.html')"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$label"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$label"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(./tei:occupation, '; ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:listBibl[@type='wrote']/tei:bibl)"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="concat($id, '.html')"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
        
        
        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="personId" select="data(./@xml:id)"/>
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:persName[1]//text()))"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="de">
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
                                    <a href="listperson.html">Personenregister</a>
                                </li>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:choose>
                                    <xsl:when test="./tei:figure/tei:graphic/@url">
                                        <xsl:variable name="imageUrl" select="./tei:figure/tei:graphic/@url"/>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <xsl:call-template name="person_detail"/>
                                            </div>
                                            <div class="col-md-6">
                                                <figure class="figure">
                                                    <img src="{$imageUrl}" class="figure-img img-fluid rounded" alt="Portraitbild von {$name}"/>
                                                    <figcaption class="figure-caption">
                                                        <xsl:value-of select="'Portraitbild von '||$name"/>. Übernommen von <a href="{$imageUrl}">Wikipedia</a>
                                                    </figcaption>
                                                </figure>
                                            </div>
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="person_detail"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <div class="row">
                                    <div class="col-md-6">
                                        <xsl:if test=".//tei:noteGrp">
                                            <h2>Erwähnungen</h2>
                                            <ul>
                                                <xsl:for-each select=".//tei:noteGrp//tei:note">
                                                    <li>
                                                        <a href="{replace(./@target, '.xml', '.html')}">
                                                            <xsl:value-of select="./text()"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                    </div>
                                    <div class="col-md-6">
                                        
                                        <h2>Schaubühne-Texte</h2>
                                        <ul>
                                            <xsl:for-each select="$listperson//tei:bibl[./tei:author[@key='#'||$personId]]">
                                                <li>
                                                    <a href="{concat(@xml:id, '.html')}">
                                                        <xsl:value-of select="./tei:title[@level='a']"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
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
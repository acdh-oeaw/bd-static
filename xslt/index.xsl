<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/one_time_alert.xsl"/>
    <xsl:import href="./partials/blockquote.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"Baedeker digital"'/>
        </xsl:variable>
        <html class="h-100" lang="{$default_lang}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <div class="container col-xxl-8 pt-3">
                        <xsl:call-template name="one_time_alert"/>
                        <div class="row flex-lg-row align-items-center g-5 py-5">
                            <div class="col-lg-6">
                                <h1 class="lh-base">
                                    <span class="display-6">Digitale Edition</span>
                                    <br/>
                                    <span class="display-4">Baedeker</span>
                                    <br/>
                                    <span class="display-6">1875 – 1914</span>
                                </h1>
                                <p class="text-end">herausgegeben vom <a href="https://www.oeaw.ac.at/acdh/">Austrian Centre for Digitial Humanities</a></p>
                                <p class="lead">
                                    Eine TEI/XML online Edition der <br />
                                    Baedeker Reiseführer für Indien, Konstantinopel und Kleinasien, Nordamerika, Palästina und Syrien und für das Mittelmeer.
                                </p>
                                <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                                    <a href="about.html" type="button"
                                        class="btn btn-outline-primary btn-lg px-4 me-md-2"
                                        >Über das Projekt</a>
                                    <a href="toc.html" type="button"
                                        class="btn btn-outline-primary btn-lg px-4">Alle Hefte</a>
                                </div>
                            </div>
                            <div class="col-10 col-sm-8 col-lg-6">
                                <figure class="figure">
                                    <img src="images/title-image.svg"
                                        class="d-block mx-lg-auto img-fluid"
                                        alt="" width="400" height="600"
                                        loading="lazy"/>
                                    <figcaption class="pt-3 figure-caption">von Barbara Krautgartner, CC BY-4.0 <a href="https://www.oeaw.ac.at/acdh/acdh-ch-home">Austrian Centre for Digital Humanites</a></figcaption>
                                </figure>
                            </div>
                        </div>
                        <div class="text-center p-4">
                            <xsl:call-template name="blockquote"/>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
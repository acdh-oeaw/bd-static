<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <header>
            <nav aria-label="Primary" class="navbar navbar-expand-lg">
                <div class="container-fluid">
                    <a class="navbar-brand" href="index.html">
                        <xsl:value-of select="$project_short_title"/>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Projekt</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="about.html">Über das Projekt</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="imprint.html">Impressum</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="hefte.html">Alle Bände</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="toc.html">Alle Seiten</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="listauthors.html">Autoren</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="schlagworte.html">Schlagworte</a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">API</a>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a class="dropdown-item" href="http://dse-static-oai-pmh.acdh-dev.oeaw.ac.at/bd-static/oai-pmh">OAI-PMH</a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="beacon.txt">GND-Beacon</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                        <form class="d-flex" role="search" method="GET" action="search.html">
                            <input class="form-control me-2" type="search" placeholder="z.B. 'Konstantinopel'" aria-label="Suche" name="baedeker[query]"></input>
                            <button class="btn btn-primary" type="submit">Suche</button>
                        </form>
                    </div>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>
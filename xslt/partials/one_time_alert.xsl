<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/" name="one_time_alert">
        <div style="display:block" id="once-popup">
            <div class="alert alert-warning alert-dismissible fade show text-center" role="alert">
                <strong class="text-center fs-2">
                    Alpha Version
                </strong>
                <p>Aktuell nur für den internen Gebrauch vorgesehen.</p>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
        <!-- <script type="text/javascript" src="js/one_time_alert.js"></script> -->
    </xsl:template>
</xsl:stylesheet>
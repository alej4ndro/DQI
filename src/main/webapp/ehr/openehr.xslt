<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:template match="/">
        <html>
            <head>
                <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
                <title>openEHR EHR Extract</title>
                <link rel="stylesheet" type="text/css" href="openehr.css"/>
            </head>
            <body>
                <table class="EXTRACT">
                    <tbody>
                        <xsl:if test="/EHR_EXTRACT">
                        <tr>
                            <td>
                                <div class="EXTRACTTITLE">EHR Extract for <xsl:value-of select="/EHR_EXTRACT/criteria/archetype_ids"/></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="DEMOGRAPHICS">Patient: <xsl:value-of select="/EHR_EXTRACT/subject_of_care"/></div>
                            </td>
                        </tr>
                        <xsl:for-each select="/EHR_EXTRACT/all_compositions">
                            <tr>
                                <td>
                                    <xsl:apply-templates select="."/>
                                </td>
                            </tr>
                        </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="/COMPOSITION | /SECTION | /OBSERVATION | /INSTRUCTION | /ACTION | /EVALUATION | /ELEMENT | /CLUSTER">
                            <xsl:for-each select="/*">
                                <tr>
                                    <td>
                                        <xsl:apply-templates select="."/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'COMPOSITION'] | COMPOSITION">
        <div class="COMPOSITIONBORDER">
            <table class="COMPOSITION">
                <tbody>
                    <tr>
                        <td>
                            <xsl:if test="name">
                                <div class="COMPOSITIONTITLE">
                                    <xsl:apply-templates select="name"/>
                                </div>
                            </xsl:if>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="content">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'SECTION'] | SECTION">
        <div class="SECTIONBORDER">
            <table class="SECTION">
                <tbody>
                    <tr>
                        <td>
                            <div class="SECTIONTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="items">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'OBSERVATION'] | OBSERVATION">
        <div class="OBSERVATIONBORDER">
            <table class="OBSERVATION">
                <tbody>
                    <tr>
                        <td>
                            <div class="OBSERVATIONTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="data">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'EVALUATION'] | EVALUATION">
        <div class="EVALUATIONBORDER">
            <table class="EVALUATION">
                <tbody>
                    <tr>
                        <td>
                            <div class="EVALUATIONTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="data">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'INSTRUCTION'] | INSTRUCTION">
        <div class="INSTRUCTIONBORDER">
            <table class="INSTRUCTION">
                <tbody>
                    <tr>
                        <td>
                            <div class="INSTRUCTIONTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="activities">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'HISTORY'] | HISTORY">
        <div class="HISTORYBORDER">
            <table class="HISTORY">
                <tbody>
                    <tr>
                        <td>
                            <div class="HISTORYTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="events">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'POINT_EVENT'] | POINT_EVENT">
        <div class="POINTEVENTBORDER">
            <table class="POINTEVENT">
                <tbody>
                    <tr>
                        <td>
                            <div class="POINTEVENTTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="data">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <!--TODO-->
    <xsl:template match="*[@xsi:type = 'INTERVAL_EVENT'] | INTERVAL_EVENT">
        <div class="INTERVALBORDER">
            <table class="INTERVAL">
                <tbody>
                    <tr>
                        <td>
                            <div class="INTERVALTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="data">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <!--TODO-->
    <xsl:template match="*[@xsi:type = 'ACTIVITY'] | ACTIVITY">
        <div class="INSTRUCTIONBORDER">
            <table class="INSTRUCTION">
                <tbody>
                    <tr>
                        <td>
                            <div class="INSTRUCTIONTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="activities">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'ITEM_LIST'] | ITEM_LIST">
        <div class="ITEMLISTBORDER">
            <table class="ITEMLIST">
                <tbody>
                    <tr>
                        <td>
                            <div class="ITEMLISTTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="items">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'ITEM_SINGLE'] | ITEM_SINGLE">
        <div class="ITEMSINGLEBORDER">
            <table class="ITEMSINGLE">
                <tbody>
                    <tr>
                        <td>
                            <div class="ITEMSINGLETITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="item">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'ITEM_TABLE'] | ITEM_TABLE">
        <div class="ITEMTABLEBORDER">
            <table class="ITEMTABLE">
                <tbody>
                    <tr>
                        <td>
                            <div class="ITEMTABLETITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="rows">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'ITEM_TREE'] | ITEM_TREE">
        <div class="ITEMTREEBORDER">
            <table class="ITEMTREE">
                <tbody>
                    <tr>
                        <td>
                            <div class="ITEMTREETITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="items">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'CLUSTER'] | CLUSTER">
        <div class="CLUSTERBORDER">
            <table class="CLUSTER">
                <tbody>
                    <tr>
                        <td>
                            <div class="CLUSTERTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="items">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'ELEMENT'] | ELEMENT">
        <div class="ELEMENTBORDER">
            <table class="ELEMENT">
                <tbody>
                    <tr>
                        <td>
                            <div class="ELEMENTTITLE">
                                <xsl:apply-templates select="name"/>:</div>
                        </td>
                        <td>
                            <div class="VALUE">
                                <xsl:for-each select="value">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>



    <xsl:template match="*[@xsi:type = 'DV_ORDINAL']">
        <xsl:value-of select="value"/> - <xsl:value-of select="symbol/value"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'DV_COUNT']">
        <xsl:value-of select="magnitude"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'DV_TEXT']">
        <xsl:value-of select="value"/>
    </xsl:template>
    
    <xsl:template match="*[@xsi:type = 'DV_QUANTITY']">
        <xsl:value-of select="magnitude"/> <xsl:value-of select="units"/>
    </xsl:template>
    
    <xsl:template match="*[@xsi:type = 'DV_CODED_TEXT']">
        <xsl:value-of select="value"/>
        <xsl:if test="(defining_code/terminology_id/value) and (defining_code/code_string)"> [<xsl:value-of select="defining_code/terminology_id/value"/>::<xsl:value-of select="defining_code/code_string"/>] </xsl:if>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'DV_DATE_TIME']">
        <xsl:value-of select="value"/>
    </xsl:template>
    
    <xsl:template match="*[@xsi:type = 'DV_DATE']">
        <xsl:value-of select="value"/>
    </xsl:template>

    <!--<xsl:template match="*[@xsi:type = 'CLUSTER'] | CLUSTER">
        <div class="CLUSTERBORDER">
            <table class="CLUSTER">
                <tbody>
                    <tr>
                        <td>
                            <div class="CLUSTERTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="parts">
                                <xsl:apply-templates select="."/>
                            </xsl:for-each>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'ELEMENT'] | ELEMENT">
        <div class="ELEMENTBORDER">
            <table class="ELEMENT">
                <tbody>
                    <tr>
                        <td>
                            <div class="ELEMENTTITLE">
                                <xsl:apply-templates select="name"/>:</div>
                        </td>
                        <td>
                            <div class="VALUE">
                                <xsl:for-each select="value">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>-->


    <!-- Removes everithing else -->
    <xsl:template match="@*|text()"/>


</xsl:stylesheet>

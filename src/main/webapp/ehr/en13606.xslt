<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (c) 2004-2010 IBIME, Universidad Politécnica de Valencia, Spain -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lxslt="http://xml.apache.org/xslt">

    <xsl:variable name="pathCSS">en13606/</xsl:variable>
    <xsl:variable name="pathJS">en13606/script/</xsl:variable>
    <xsl:variable name="pathIMG">en13606/images/</xsl:variable>
    <xsl:variable name="useTemplate" select="false()"></xsl:variable>

    <xsl:variable name="template" select="document('instance.xml')"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta content="text/html; charset=UTF-8" http-equiv="content-type"/>
                <title>CEN/ISO 13606 Extract</title>
                <link rel="stylesheet" type="text/css" href="{$pathCSS}en13606.css" MEDIA="screen"/>
                <!-- <link rel="stylesheet" type="text/css" href="{$pathCSS}en13606-print.css" MEDIA="print"/> -->
                
                <script type="text/javascript" src="{$pathJS}sortable.js"/>
                <script type="text/javascript" src="{$pathJS}jquery.min.js"/>
                <script type="text/javascript" src="{$pathJS}jquery.bettertip.js"/>
                <script src="{$pathJS}floating.js" language="text/javascript"/>
                <script type="text/javascript" src="{$pathJS}tabber.js"/>
                
            </head>
            <body>
                <table class="EXTRACT">
                    <tbody>
                        <xsl:if test="/EHR_EXTRACT">
                            <tr>
                                <td>
                                    <div class="EXTRACTTITLE"> Extract of <xsl:value-of select="/EHR_EXTRACT/criteria/archetype_ids/extension"/></div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <xsl:choose>
                                        <xsl:when
                                            test="/EHR_EXTRACT/demographic_extract/extract_id/extension  = /EHR_EXTRACT/subject_of_care/extension">
                                            <!-- and /EHR_EXTRACT/demographic_extract/extract_id/root/oid  = /EHR_EXTRACT/subject_of_care/root/oid -->
                                            <xsl:apply-templates select="/EHR_EXTRACT/demographic_extract"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="DEMOGRAPHICS">
                                                <table class="DEMINFO">
                                                    <tbody>
                                                        <tr>
                                                            <td class="DEMCELL">
                                                                <div class="DEMTITLE">ID paciente: </div>
                                                            </td>
                                                            <td>
                                                                <div class="DEMVALUE">
                                                                    <xsl:value-of select="/EHR_EXTRACT/subject_of_care/extension"/>
                                                                </div>

                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
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
                        <xsl:if test="/COMPOSITION | /SECTION | /ENTRY | /CLUSTER | /ELEMENT | /SUBJECT_OF_CARE_PERSON_IDENTIFICATION">
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
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
                <br/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*[@xsi:type='SUBJECT_OF_CARE_PERSON_IDENTIFICATION'] | SUBJECT_OF_CARE_PERSON_IDENTIFICATION"
        name="SUBJECT_OF_CARE_PERSON_IDENTIFICATION">
        <div class="DEMOGRAPHICS">
            <table class="DEMINFO">
                <tbody>
                    <tr>
                        <td class="DEMCELL">
                            <div class="DEMTITLE"> Name: </div>
                        </td>
                        <td>
                            <div class="DEMVALUE">
                                <xsl:for-each select="name/name_part">
                                    <xsl:if test="name_part_type/codeValue = 'GIV' ">
                                        <xsl:value-of select="entity_part_name"/>
                                    </xsl:if>
                                </xsl:for-each>

                                <xsl:for-each select="name/name_part">
                                    <xsl:if test="name_part_type/codeValue = 'FAM' ">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="entity_part_name"/>

                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                        </td>
                        <td class="DEMCELL">
                            <div class="DEMTITLE"> Patient ID: </div>
                        </td>
                        <td>
                            <div class="DEMVALUE">
                                <xsl:value-of select="extract_id/extension"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="DEMCELL">
                            <div class="DEMTITLE"> Birth date: </div>
                        </td>
                        <td>
                            <div class="DEMVALUE">
                                <xsl:value-of select="birth_time/time"/>
                            </div>
                        </td>

                        <td class="DEMCELL">
                            <div class="DEMTITLE"> Sex: </div>
                        </td>
                        <td>
                            <div class="DEMVALUE">
                                <xsl:if test="administrative_gender_code/codeValue = 0">Male</xsl:if>
                                <xsl:if test="administrative_gender_code/codeValue = 1">Female</xsl:if>
                                <xsl:if test="administrative_gender_code/codeValue = 2">Intersexual</xsl:if>
                                <xsl:if test="administrative_gender_code/codeValue = 9">Unknown</xsl:if>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <xsl:if test="deceased_time/time">

                            <td class="DEMCELL">
                                <div class="DEMTITLE"> Decease date: </div>
                            </td>
                            <td colspan="3">
                                <div class="DEMVALUE">
                                    <xsl:value-of select="deceased_time/time"/>
                                </div>
                            </td>

                        </xsl:if>
                    </tr>
                    <tr>
                        <td class="DEMCELL">
                            <div class="DEMTITLE"> Contact: </div>
                        </td>
                        <td colspan="3">
                            <div class="DEMVALUE">
                                <xsl:for-each select="telecom">
                                    <xsl:if test="telecom_address/literal">
                                        <span>
                                            <xsl:value-of select="telecom_address/literal"/>
                                            <xsl:choose>
                                                <xsl:when test="use/codeValue = 'HT'"> (Home). </xsl:when>
                                                <xsl:when test="use/codeValue = 'WT'"> (Work). </xsl:when>
                                                <xsl:when test="use/codeValue = 'FX'"> (Fax). </xsl:when>
                                                <xsl:when test="use/codeValue = 'EC'"> (Emergency). </xsl:when>
                                                <xsl:when test="use/codeValue = 'MC'"> (Mobile). </xsl:when>
                                                <xsl:when test="use/codeValue = 'PG'"> (Buscapersonas). </xsl:when>
                                                <xsl:when test="use/codeValue = 'AS'"> (Respuesta Vocal). </xsl:when>
                                            </xsl:choose>
                                        </span>
                                    </xsl:if>
                                </xsl:for-each>
                            </div>
                        </td>
                    </tr>

                    <xsl:if test="addr/address_use/codeValue='HP'">
                        <tr>
                            <td class="DEMCELL">
                                <div class="DEMTITLE"> Address: </div>
                            </td>
                            <td colspan="3">
                                <div class="DEMVALUE">
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'STR' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'HNR' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'FNM' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'SAL' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'CTY' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='HP']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'CNT' ">
                                            <xsl:value-of select="address_line"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </div>
                            </td>
                        </tr>
                    </xsl:if>

                    <xsl:if test="addr/address_use/codeValue='BIR'">
                        <tr>
                            <td class="DEMCELL">
                                <div class="DEMTITLE"> Birth place: </div>
                            </td>
                            <td colspan="3">
                                <div class="DEMVALUE">
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'STR' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'HNR' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'FNM' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'SAL' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'CTY' ">
                                            <xsl:value-of select="address_line"/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                    <xsl:for-each select="addr[address_use/codeValue='BIR']/addr_part">
                                        <xsl:if test="address_line_type/codeValue = 'CNT' ">
                                            <xsl:value-of select="address_line"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </div>
                            </td>
                        </tr>
                    </xsl:if>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'COMPOSITION'] | COMPOSITION" name="COMPOSITION">
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
                            <div class="tabber">
                                <xsl:for-each select="content">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'SECTION'] | SECTION">
        <div class="tabbertab">
            <h2 class="SECTIONTITLE">
                <xsl:apply-templates select="name"/>
            </h2>
            <div class="SECTIONBORDER">
                <table class="SECTION">
                    <tbody>
                        <!--<tr>
                                <td>
                                    <div class="SECTIONTITLE">
                                        <xsl:apply-templates select="name"/>
                                    </div>
                                </td>
                            </tr>-->
                        <tr>
                            <td>
                                <div class="tabber">
                                    <xsl:for-each select="members">
                                        <xsl:apply-templates select="."/>
                                    </xsl:for-each>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'ENTRY'] | ENTRY">
        <div class="tabbertab">
            <h2 class="ENTRYTITLE">
                <xsl:apply-templates select="name"/>
            </h2>
            <div class="ENTRYBORDER">
                <table class="ENTRY">
                    <tbody>
                        <!--<tr>
                        <td>
                            <div class="ENTRYTITLE">
                                <xsl:apply-templates select="name"/>
                            </div>
                        </td>
                    </tr>-->
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
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'CLUSTER'] | CLUSTER">
        <div class="CLUSTERBORDER">
            <table class="CLUSTER">
                <tbody>
                    <tr>
                        <td>
                            <span>
                                <xsl:attribute name="class">CLUSTERTITLE</xsl:attribute>
                                <!--<xsl:if test="obs_time/low/time">
                                    <a href="javascript:doit();" class="tip">
                                        <xsl:attribute name="title">
                                            <xsl:text>From: </xsl:text>
                                            <xsl:value-of select="obs_time/low/time"/>
                                            <xsl:if test="obs_time/high/time">
                                                <xsl:text> To: </xsl:text>
                                                <xsl:value-of select="obs_time/high/time"/>
                                            </xsl:if>
                                        </xsl:attribute>
                                        <img src="{$pathIMG}clock.png"/>
                                    </a>
                                </xsl:if> -->
                                <xsl:apply-templates select="name"/>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <!-- 
                                STRC01 lista
                                STRC02 tabla
                                -->
                            <xsl:choose>
                                <xsl:when test="structure_type/codeValue = 'STRC02' and parts/structure_type/codeValue = 'STRC01'">
                                    <div class="CLUSTERTABLE">
                                        <!--<table class="CLUSTERTABLE">-->
                                        <table class="sortable" id="anyid" cellpadding="0" cellspacing="0">
                                            <thead class="CLUSTERTABLEHEAD">
                                                <tr>
                                                    <xsl:for-each select="parts[position()=1]/parts">
                                                        <xsl:choose>
                                                            <xsl:when
                                                                test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='secondary'"/> 
                                                            <xsl:when
                                                                test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='hide'"/> 
                                                            <xsl:otherwise>
                                                                <th class="CLUSTERTH">
                                                                    <xsl:value-of select="name/originalText"/>
                                                                </th>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                    <!--<xsl:if test="parts/obs_time/low/time">
                                                        <th class="CLUSTERTH"></th>
                                                        </xsl:if> -->
                                                    <!-- Header for additional info -->
                                                    <xsl:if test="$useTemplate">
                                                    <th class="CLUSTERTH"/>
                                                    </xsl:if>
                                                </tr>
                                            </thead>
                                            <tbody class="CLUSTERTABLEBODY">
                                                <xsl:for-each select="parts">
                                                    <tr>
                                                        <xsl:for-each select="parts">
                                                            <xsl:choose>
                                                                <xsl:when
                                                                    test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='secondary'"/>
                                                                <xsl:when
                                                                    test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='hide'"/> 
                                                                <xsl:otherwise>
                                                                    <td class="CLUSTERTD">
                                                                        <!--<xsl:if test="obs_time/low/time">
                                                                    <a href="javascript:doit();" class="tip">
                                                                        <xsl:attribute name="title">
                                                                           <xsl:text>From: </xsl:text>
                                                                           <xsl:value-of select="obs_time/low/time"/>
                                                                           <xsl:if test="obs_time/high/time">
                                                                           <xsl:text> To: </xsl:text>
                                                                           <xsl:value-of select="obs_time/high/time"/>
                                                                           </xsl:if>
                                                                        </xsl:attribute>
                                                                        <img src="{$pathIMG}clock.png"/>
                                                                    </a>
                                                                </xsl:if>-->
                                                                        <xsl:choose>
                                                                           <xsl:when test="value">
                                                                           <xsl:apply-templates select="value"/>
                                                                           </xsl:when>
                                                                           <xsl:otherwise>
                                                                           <xsl:apply-templates select="parts"/>
                                                                           </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </td>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:for-each>
                                                        <xsl:if test="$useTemplate">
                                                        <td class="CLUSTERTD">
                                                            <!-- Add secondary info -->
                                                            <xsl:variable name="uid">
                                                                <xsl:value-of select="generate-id(parts)"/>
                                                            </xsl:variable>
                                                            <xsl:variable name="imgId">
                                                                <xsl:value-of select="generate-id(.)"/>
                                                            </xsl:variable>
                                                            <a id="{$imgId}" href="${$uid}?width=300" class="betterTip" title="$none">
                                                                <img src="{$pathIMG}plus.png"/>
                                                            </a>
                                                            <div id="{$uid}" style="display:none">
                                                                <xsl:for-each select="parts">
                                                                    <xsl:choose>
                                                                        <xsl:when
                                                                            test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='secondary' and value">
                                                                           <p>
                                                                           <ul>
                                                                           <li>
                                                                           <b><xsl:value-of select="name/originalText"/>:</b>
                                                                           <br/>
                                                                           <xsl:apply-templates select="value"/>
                                                                           </li>
                                                                           </ul>
                                                                           </p>
                                                                        </xsl:when>
                                                                        <xsl:when test="$useTemplate and $template/template/rules/rule/archetype/text()=meaning/codingSchemeName/text() and $template/template/rules/rule/node/text()=meaning/codeValue/text() and $template/template/rules/rule/showType/text()='secondary' and name/originalText">
                                                                            <p>
                                                                                <ul>
                                                                                    <li><b><xsl:value-of select="name/originalText"/>:</b>
                                                                            <br/><xsl:apply-templates select="parts"/>
                                                                                    </li>
                                                                                </ul>
                                                                            </p>
                                                                        </xsl:when>
                                                                    </xsl:choose>
                                                                </xsl:for-each>
                                                            </div>
                                                        </td>
                                                        </xsl:if>
                                                        <!--<xsl:if test="obs_time/low/time">
                                                            <td class="CLUSTERTD">
                                                                <a href="javascript:doit();" class="tip">
                                                                    <xsl:attribute name="title">
                                                                        <xsl:text>From: </xsl:text>
                                                                        <xsl:value-of select="obs_time/low/time"/>
                                                                        <xsl:if test="obs_time/high/time">
                                                                           <xsl:text> To: </xsl:text>
                                                                           <xsl:value-of select="obs_time/high/time"/>
                                                                        </xsl:if>
                                                                    </xsl:attribute>
                                                                    <img src="{$pathIMG}clock.png"/>
                                                                </a>
                                                            </td>
                                                        </xsl:if> -->
                                                    </tr>
                                                </xsl:for-each>
                                            </tbody>
                                        </table>
                                    </div>
                                </xsl:when>
                                <xsl:otherwise>
                                    <div class="CLUSTERCONTENT">
                                        <xsl:for-each select="parts">
                                            <xsl:apply-templates select="."/>
                                        </xsl:for-each>
                                    </div>
                                </xsl:otherwise>
                            </xsl:choose>
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
                            <div>
                                <xsl:attribute name="class">ELEMENTTITLE</xsl:attribute>
                                <xsl:apply-templates select="name"/>: </div>

                        </td>
                        <td>
                            <div class="VALUE">
                                <!--<xsl:text> </xsl:text>-->
                                <xsl:for-each select="value">

                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </td>
                        <!--<td>
                            <xsl:if test="obs_time/low/time">
                                <a href="javascript:doit();" class="tip">
                                    <xsl:attribute name="title">
                                        <xsl:text>From: </xsl:text>
                                        <xsl:value-of select="obs_time/low/time"/>
                                        <xsl:if test="obs_time/high/time">
                                            <xsl:text> To: </xsl:text>
                                            <xsl:value-of select="obs_time/high/time"/>
                                        </xsl:if>
                                    </xsl:attribute>
                                    <img src="{$pathIMG}clock.png"/>
                                </a>
                            </xsl:if>
                        </td>-->
                    </tr>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'ORD']">
        <xsl:value-of select="value"/> - <xsl:apply-templates select="symbol"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'PQ']" name="PQ">
        <xsl:param name="pqdata"/>
        <xsl:choose>
            <xsl:when test="$pqdata">
                <xsl:value-of select="$pqdata/value"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$pqdata/units/codeValue"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="value"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="units/codeValue"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'SIMPLE_TEXT']">
        <xsl:value-of select="originalText"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'CS']"> [<xsl:value-of select="codingSchemeName"/><xsl:value-of select="codingSchemeVersion"/>::<xsl:value-of
            select="codeValue"/>] </xsl:template>

    <xsl:template match="*[@xsi:type = 'CV']">
        <div>
            <xsl:attribute name="title">
                <xsl:value-of select="displayName"/>
            </xsl:attribute>
            <xsl:value-of select="displayName"/> - [<xsl:value-of select="codingSchemeName"/><xsl:value-of select="codingSchemeVersion"
                />::<xsl:value-of select="codeValue"/>] </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'CE']">
        <div>
            <xsl:attribute name="title">
                <xsl:value-of select="displayName"/>
            </xsl:attribute>
            <xsl:value-of select="displayName"/> - [<xsl:value-of select="codingSchemeName"/><xsl:value-of select="codingSchemeVersion"
                />::<xsl:value-of select="codeValue"/>] </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'CD']">
        <div>
            <xsl:attribute name="title">
                <xsl:value-of select="displayName"/>
            </xsl:attribute>
            <xsl:value-of select="displayName"/> - [<xsl:value-of select="codingSchemeName"/><xsl:value-of select="codingSchemeVersion"
                />::<xsl:value-of select="codeValue"/>] </div>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'TS']" name="TS">
        <xsl:param name="tsdata"/>
        <xsl:choose>
            <xsl:when test="nullFlavor/codeValue='NI'"/>
            <xsl:when test="$tsdata">
                <xsl:value-of select="$tsdata/time"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="time"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:template>

    <xsl:template match="*[@xsi:type = 'URI']">
        <xsl:choose>
            <xsl:when
                test="scheme = 'http' or scheme = 'ftp' or scheme = 'file' or scheme = 'https' or scheme = 'mailto' or starts-with(value,'http') or starts-with(value,'ftp') or starts-with(value,'file') or starts-with(value,'https') or starts-with(value,'mailto')">
                <a target="_blank">
                    <xsl:attribute name="href">
                        <xsl:value-of select="value"/>
                    </xsl:attribute>
                    <xsl:value-of select="value"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="value"/>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

    <xsl:template match="*[@xsi:type = 'II']">
        <xsl:if test="assigningAuthorityName">
            <xsl:value-of select="assigningAuthorityName"/> - </xsl:if>
        <xsl:if test="extension">
            <xsl:value-of select="extension"/>
        </xsl:if>
        <xsl:if test="root">
            <xsl:value-of select="root"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'IVL']">
        <xsl:choose>
            <xsl:when test="(lowClosed= 'true') and (highClosed='true')"><xsl:apply-templates select="low"/>..<xsl:apply-templates select="high"/></xsl:when>
            <xsl:when test="(lowClosed= 'true') and (highClosed='false')"><xsl:apply-templates select="low"/>..* </xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='true')"> *..<xsl:apply-templates select="high"/></xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='false')"> * </xsl:when>
            <xsl:otherwise><xsl:apply-templates select="low"/>..<xsl:apply-templates select="high"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'IVLTS']">
        <xsl:choose>
            <xsl:when test="(lowClosed= 'true') and (highClosed='true')"><xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="low"/>
                </xsl:call-template>..<xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="high"/>
                </xsl:call-template></xsl:when>
            <xsl:when test="(lowClosed= 'true') and (highClosed='false')"><xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="low"/>
                </xsl:call-template>..* </xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='true')"> *..<xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="high"/>
                </xsl:call-template></xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='false')"> * </xsl:when>
            <xsl:otherwise><xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="low"/>
                </xsl:call-template>..<xsl:call-template name="TS">
                    <xsl:with-param name="tsdata" select="high"/>
                </xsl:call-template></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'IVLPQ']">
        <xsl:choose>
            <xsl:when test="(lowClosed= 'true') and (highClosed='true')"><xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="low"/>
                </xsl:call-template>..<xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="high"/>
                </xsl:call-template></xsl:when>
            <xsl:when test="(lowClosed= 'true') and (highClosed='false')"><xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="low"/>
                </xsl:call-template>..* </xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='true')"> *..<xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="high"/>
                </xsl:call-template></xsl:when>
            <xsl:when test="(lowClosed= 'false') and (highClosed='false')"> * </xsl:when>
            <xsl:otherwise><xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="low"/>
                </xsl:call-template>..<xsl:call-template name="PQ">
                    <xsl:with-param name="pqdata" select="high"/>
                </xsl:call-template></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'DATE']">
        <xsl:value-of select="date"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'BL']">
        <xsl:if test="value = 'true'">Sí</xsl:if>
        <xsl:if test="value = 'false'">No</xsl:if>
    </xsl:template>

    <!-- <xsl:template match="*[@xsi:type = 'CODED_TEXT']">
        <div>
            <xsl:if test="codedValue/displayName">
                <xsl:attribute name="title">
                    <xsl:value-of select="codedValue/displayName"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="originalText"/>
            <xsl:if test="(codedValue/codingSchemeName) and (codedValue/codeValue)"> [<xsl:value-of select="codedValue/codingSchemeName"
                    /><xsl:value-of select="codedValue/codingSchemeVersion"/>::<xsl:value-of select="codedValue/codeValue"/>] </xsl:if>
        </div>
        </xsl:template>-->

    <xsl:template match="*[@xsi:type = 'CODED_TEXT']">
        
            <xsl:attribute name="title">
                <xsl:if test="codedValue/displayName"><xsl:value-of select="codedValue/displayName"/></xsl:if>
                <xsl:if test="(codedValue/codingSchemeName) and (codedValue/codeValue)"> [<xsl:value-of select="codedValue/codingSchemeName"/><xsl:value-of select="codedValue/codingSchemeVersion"/>::<xsl:value-of select="codedValue/codeValue"/>] </xsl:if>
            </xsl:attribute>
            <xsl:if test="codedValue/displayName">
                <xsl:attribute name="title">
                    <xsl:value-of select="codedValue/displayName"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="originalText"/>
        
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'CR']">
        <xsl:value-of select="role/displayName"/> - <xsl:value-of select="codingSchemeName"/><xsl:value-of select="qualCode/displayName"/>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'DURATION']">
        <xsl:if test="sign &lt; 0"> - </xsl:if>
        <xsl:if test="days">
            <xsl:value-of select="days"/>d </xsl:if>
        <xsl:if test="hours">
            <xsl:value-of select="hours"/>h </xsl:if>
        <xsl:if test="minutes">
            <xsl:value-of select="minutes"/>m </xsl:if>
        <xsl:if test="seconds">
            <xsl:value-of select="seconds"/>s </xsl:if>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'RTO']">
        <xsl:call-template name="PQ">
            <xsl:with-param name="pqdata" select="numerator"/>
        </xsl:call-template>/<xsl:call-template name="PQ">
            <xsl:with-param name="pqdata" select="denominator"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[@xsi:type = 'ED']">
        <xsl:choose>
            <xsl:when test="thumbnail">
                <xsl:choose>
                    <xsl:when test="thumbnail/data">
                        <xsl:if
                            test="(thumbnail/mediaType= 'Image/png') or (thumbnail/mediaType='Image/gif') or (thumbnail/mediaType='Image/gif') or (thumbnail/mediaType='Image/jpeg') or (thumbnail/mediaType='Image/g3fax') or (thumbnail/mediaType='Image/tiff')">
                            <a target="_blank">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="reference"/>
                                </xsl:attribute>
                                <img border="0">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="concat('data:',thumbnail/mediaType,';base64,',thumbnail/data)"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="thumbnail/reference">
                            <a target="_blank">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="reference"/>
                                </xsl:attribute>
                                <img border="0">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="thumbnail/reference"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="data">
                <xsl:if
                    test="(mediaType= 'Image/png') or (mediaType='Image/gif') or (mediaType='Image/gif') or (mediaType='Image/jpeg') or (mediaType='Image/g3fax') or (mediaType='Image/tiff')">
                    <img border="0">
                        <xsl:attribute name="src">
                            <xsl:value-of select="concat('data:',mediaType,';base64,',data)"/>
                        </xsl:attribute>
                    </img>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="reference">
                    <img border="0">
                        <xsl:attribute name="src">
                            <xsl:value-of select="reference"/>
                        </xsl:attribute>
                    </img>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'PIVL']">
        <xsl:apply-templates select="phase"/> : <xsl:apply-templates select="period"/>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'EIVL']">
        <xsl:apply-templates select="event"/> : <xsl:apply-templates select="offset"/>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'INT']">
        <xsl:value-of select="value"/>
    </xsl:template>


    <xsl:template match="*[@xsi:type = 'REAL']">
        <xsl:value-of select="value"/>
    </xsl:template>

    <!-- Removes everithing else -->
    <xsl:template match="@*|text()"/>


</xsl:stylesheet>

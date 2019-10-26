<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (c) 2013 Veratech For Health S.L , Spain -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://schemas.openehr.org/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

	<xsl:output method="html" doctype-system="http://www.w3.org/TR/html4/strict.dtd" doctype-public="-//W3C//DTD HTML 4.01//EN" indent="yes" />
	<!-- Carga de la ayuda -->
	<xsl:variable name="help" select="document('../../../rm/CEN/EN13606/CEN-EN13606-documentation.xml')"/>
	<xsl:variable name="marginrule">10</xsl:variable>

	<xsl:template match="/">
		<html>
			<head>			
				<!-- <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" /> -->
				
				<meta name="keywords" content=" LinkEHR editor (www.linkehr.com)"/>
				<meta name="author" content=" LinkEHR editor (www.linkehr.com)"/>
				<meta name="description" content="HTML render archetype  generated with LinkEHR editor (www.linkehr.com)" />
				
				<link rel="stylesheet" type="text/css" href="css/form1.css" MEDIA="screen"></link>
				
				<link rel="stylesheet" type="text/css" href="css/themes/default/style.css" MEDIA="screen"></link>
				<script type="text/javascript" src="js/xslt13606.js"></script>
				<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
				<script type="text/javascript" src="js/jquery-ui-1.9.2.js"></script>
				<script type="text/javascript" src="js/jquery.jstree.js"></script>
				<script type="text/javascript" src="js/jquery-ui-timepicker-addon.js"></script>
				<link rel="stylesheet" href="css/jquery-ui-1.9.2.css" /> 

				<title>
					<xsl:value-of select="a:archetype/a:archetype_id/a:value" />
				</title>
				
				
			</head>
			<body  id="public" onload="replica();">
					<!-- Activamos la ayuda tooltip a todo el documento -->
					<script>$( document ).tooltip();</script>
					<script>$(document).ready(function(){$('span.required').text('(*)');});</script>
				              
					<!-- Analisis de los hijos del arquetipo -->
					<xsl:if test="a:archetype/a:definition/a:rm_type_name = ('ELEMENT' or 'ENTRY' or 'EVALUATION' or 'OBSERVATION' or 'INSTRUCTION' or 'ADMIN_ENTRY' or 'ACTION' or 'SECTION' or 'CLUSTER' or 'ITEM_TREE')">
					   <div class="padre" id="estructura">
						<xsl:apply-templates select="a:archetype/a:definition" />
					    </div>
					</xsl:if>
					
					<xsl:if test="a:archetype/a:definition/a:rm_type_name = 'COMPOSITION'">
					<div class="padre" id="composicion">
						<xsl:for-each select="a:archetype/a:definition/a:attributes/a:children">
							<xsl:apply-templates select="." />
						</xsl:for-each>
					</div>
					</xsl:if>
				
			</body>
		</html>
	</xsl:template>

	<!-- Definicion de template COMPOSITION -->
	<xsl:template match="*[a:rm_type_name='COMPOSITION']">
		<!-- Variables del div -->
		<xsl:variable name="idcontainer" select="concat('container',./a:node_id)"/>
		<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
		<xsl:variable name="idimgclinical" select="concat('imgclinical',./a:node_id)"/>
		<xsl:variable name="idimgtechnical" select="concat('imgtechnical',./a:node_id)"/>
		
		<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
		<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
		
		<xsl:variable name="idtec" select="concat('sttechnical',./a:node_id)"/>
		<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
		
		<!-- Obtenemos el margen del contendor. Contamos cuantos padres   -->
		<xsl:variable name="tabs">
			<xsl:value-of select="count(ancestor::a:children)"/>
		</xsl:variable>
		<xsl:variable name="margin" select="$marginrule * $tabs"></xsl:variable>
		
		<div  id="{$idcontainer}" style="margin-left: {$margin}px" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
			
			<!-- Montamos la veriable de ayuda clinica -->
			<xsl:variable name="ayudaclinica">
				<xsl:call-template name="descripcion"/>
			</xsl:variable>
		
			<div class="cabecera">
				<table width="98%">
			  	<tr>
	       	  	   	   <td>
			  		<xsl:call-template name="titulo" /><xsl:text>  </xsl:text>
			  		<!-- Chek required -->
			  		<xsl:if test="a:attributes/a:existence/a:lower >= 1">
			  			<span class="required"></span>
			  		</xsl:if>
			  		<img id="{$idimgclinical}" src="icons/clinicalcont.png"  title="{$ayudaclinica}" /><xsl:text> </xsl:text><img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{$jqidcontainer}','{$jqimgclinical}')"/>
			  	  </td>
			  	  <td align="right">
			  		<!-- <img src="icons/logo.png" style="visibility: visible;" /> -->
			  	  </td>
			 	 </tr>	
				
			</table>	
			</div>
			<div class="contenedor"  id="{$idtec}" style="display:none; " >
				<!-- Analizamos las propiedades del CLUSTER -->
				<ul>
					<xsl:call-template name="showinfoclass" />
					<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
				</ul>	
			</div>
			
			<script >
				<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
			</script>
			
		</div>
	</xsl:template>

	<!-- Definición de template CLUSTER -->
	<xsl:template name="CUERPOCLUSTER">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variables del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"></xsl:variable>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres   -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="count(ancestor::a:children) &lt; 1"></xsl:when>
			</xsl:choose>
			
			<xsl:variable name="margin" select="$marginrule * $tabs + 3"></xsl:variable>
		
			<div id="{$idcontainer}" idclon="{$idcontainer}" style="margin-left: {$margin}px;margin-top:0px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')"  type="CLUSTER">
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				
				<h4><xsl:call-template name="titulo" /><xsl:text>  </xsl:text>
					
					<!-- Chek required -->
					<xsl:if test="a:attributes/a:existence/a:lower >= 1">
						<span class="required"></span>
					</xsl:if>
					
					<xsl:if test="$i = 1">
						<img id="{$idimgclinical}" src="icons/clinicalcont.png"  title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
						<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{$jqidcontainer}','{$jqimgclinical}')"/>
					</xsl:if>
				
				</h4>
				
					<div id="{$idsubdivcontainer}"  type="CLUSTER">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
				<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
				<!--<xsl:if test="a:attributes/a:children[@xsi:type = 'ARCHETYPE_SLOT']" >
					<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:attributes/a:children/a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:attributes/a:children/a:excludes/a:string_expression"/></div>
				</xsl:if>-->
				
				<!-- El CLUSTER tiene dos formas de printado. La tradicional a través de un formato de lista
					y otra mas compleja donde los elementos definidos en esta definen las columnas de una
					tabla. Se conoce el tipo de printado por los valores de unos codigos internos 
					Lista: STRC01
					Tabla: STRC02
				-->
				<xsl:for-each select="a:attributes[a:rm_attribute_name = 'items']" >
					<xsl:for-each select="a:children">
						<xsl:apply-templates select="." />					
					</xsl:for-each>
				</xsl:for-each>
				</div>
				
				<div class="contenedor"  id="{$idtec}" style="display:none; " >
					<!-- Analizamos las propiedades del CLUSTER -->
					<ul>
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>	
				</div>
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<!-- Zone line button add new occurence -->
				<xsl:if test="$i = $count">

					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
									</script>
								</td>
							</tr>
						</table>
					</div>
					</xsl:if>
				</xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCLUSTER">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="*[a:rm_type_name='CLUSTER']" name="CLUSTER">
	<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCLUSTER">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
	
	</xsl:template>

	<!-- Definición de template ITEM_TREE -->
	<xsl:template name="CUERPOITEM_TREE">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variables del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"></xsl:variable>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres   -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="count(ancestor::a:children) &lt; 1"></xsl:when>
			</xsl:choose>
			
			<xsl:variable name="margin" select="$marginrule * $tabs + 3"></xsl:variable>
		
			<div id="{$idcontainer}" idclon="{$idcontainer}" style="margin-left: {$margin}px;margin-top:0px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')"  type="ITEM_TREE">
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				
				<h4><xsl:call-template name="titulo" /><xsl:text>  </xsl:text>
					
					<!-- Chek required -->
					<xsl:if test="a:attributes/a:existence/a:lower >= 1">
						<span class="required"></span>
					</xsl:if>
					
					<xsl:if test="$i = 1">
						<img id="{$idimgclinical}" src="icons/clinicalcont.png"  title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
						<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{$jqidcontainer}','{$jqimgclinical}')"/>
					</xsl:if>
				
				</h4>
				
					<div id="{$idsubdivcontainer}"  type="ITEM_TREE">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
				
				<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
				<!--<xsl:if test="a:attributes/a:children[@xsi:type = 'ARCHETYPE_SLOT']" >
					<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:attributes/a:children/a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:attributes/a:children/a:excludes/a:string_expression"/></div>
				</xsl:if>-->
				
				<!-- El CLUSTER tiene dos formas de printado. La tradicional a través de un formato de lista
					y otra mas compleja donde los elementos definidos en esta definen las columnas de una
					tabla. Se conoce el tipo de printado por los valores de unos codigos internos 
					Lista: STRC01
					Tabla: STRC02
				-->
			
				
				<xsl:for-each select="a:attributes[a:rm_attribute_name = 'items']" >
					<xsl:for-each select="a:children">
						<xsl:apply-templates select="." />					
					</xsl:for-each>
				</xsl:for-each>
				
				</div>
				
				<div class="contenedor"  id="{$idtec}" style="display:none; " >
					<!-- Analizamos las propiedades del CLUSTER -->
					<ul>
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>	
				</div>
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<!-- Zone line button add new occurence -->
				<xsl:if test="$i = $count">

					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
										$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
										$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
									</script>
								</td>
							</tr>
						</table>
					</div>
					</xsl:if>
				</xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOITEM_TREE">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="*[a:rm_type_name='ITEM_TREE']" name="ITEM_TREE">
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOITEM_TREE">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
	
	</xsl:template>
	
	
	<!-- Definicion del template CUERPOSECTION -->
	<xsl:template name="CUERPOSECTION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Variables del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idbtnaddINI" select="concat('idbtnadd',./a:node_id)"/>
			<xsl:variable name="idbtnadd" select="concat($idbtnaddINI,$i)"/>
			<xsl:variable name="jidbtnadd" select="concat('#',idbtnadd)"/>
			
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres   -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			<xsl:variable name="margin" select="$marginrule * $tabs"></xsl:variable>
			
			<div id="{$idcontainer}" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')">
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
				<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
				<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
				
				<h2>
					<!-- onclick="showhide('{$idsubdivcontainer}','{$idimgcollapsable}')" -->
					<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Section"   style="visibility: visible"/>
					<script>
						$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
						showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
						});
					</script>
					<xsl:text>   </xsl:text>
					
					<xsl:call-template name="titulo" /><xsl:text>   </xsl:text>
					
					<!-- Show button collapsable -->
					
					<!-- Chek required -->
					<xsl:if test="a:attributes/a:existence/a:lower >= 1">
						<span class="required"></span>
					</xsl:if>
					
					<xsl:if test="$i = 1">
						<img id="{$idimgclinical}" src="icons/clinicalcont.png"  title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
						<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{$jqidcontainer}','{$jqimgclinical}')"/>
					</xsl:if>
					
				</h2>
				<div id="{$idsubdivcontainer}" type="SECTION">
					
					
					<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
					<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
						<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
					</xsl:if>
					
					<xsl:for-each select="a:attributes[a:rm_attribute_name = 'members']" >
						<xsl:for-each select="a:children">
							<xsl:apply-templates select="." />					
						</xsl:for-each>
					</xsl:for-each>
					
					<!-- Analizamos las propiedades del SECTION -->
					<div class="contenedor"  id="{$idtec}" style="display:none; " >
						<ul>
							<xsl:call-template name="showinfoclass" />
							<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
						</ul>
					</div>
					<script>
						<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
					</script>
					
				</div>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:variable name="separadorbtnINI"  select="concat('separadorbtn',./a:node_id)"></xsl:variable>
				<xsl:variable name="separadorbtn"  select="concat($separadorbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jseparadorbtn"  select="concat('#',$separadorbtnINI)"></xsl:variable>
			
				<xsl:if test="$i = $count">
				     <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn" id="{$separadorbtn}">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				     </xsl:if>
				</xsl:if>
				
				
			</div>
		
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOSECTION">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Definicion de templates SECTION  -->
	<xsl:template match="*[a:rm_type_name='SECTION']" name="SECTION" >
	
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOSECTION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	
	
	<!-- Definicion del template CUERPOENTRY -->
	<xsl:template name="CUERPOENTRY">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="ENTRY" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
					
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="ENTRY">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del ENTRY para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. ELEMENT y CLUSTER con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'items']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					    <div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
										      <td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
										</tr>
										<tr>
										      <td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										});
									</script>
								</td>
							</tr>
						</table>
					        </div>
				</xsl:if>
			     </xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOENTRY">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

	
	
	<!-- Definicion de templates ENTRY -->
	<xsl:template match="*[a:rm_type_name='ENTRY'] " name="ENTRY" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOENTRY">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
		
	<!-- Definicion de templates OBSERVATION -->
	<xsl:template match="*[a:rm_type_name='OBSERVATION'] " name="OBSERVATION" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOOBSERVATION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>	
	
		<!-- Definicion del template CUERPOOBSERVATION -->
	<xsl:template name="CUERPOOBSERVATION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="OBSERVATION" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
					
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="OBSERVATION">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del OBSERVATION para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. (EVENTS/POINT_EVENTS/INTERVAL_EVENTS y ITEM_TREE...						con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'data']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						<!-- protocol should be really shown on screen<xsl:for-each select="a:attributes[a:rm_attribute_name = 'protocol']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>-->
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					    <div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
										      <td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
										</tr>
										<tr>
										      <td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										});
									</script>
								</td>
							</tr>
						</table>
					        </div>
				</xsl:if>
			     </xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOOBSERVATION">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
		<!-- Definicion de templates INSTRUCTION -->
	<xsl:template match="*[a:rm_type_name='INSTRUCTION'] " name="INSTRUCTION" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOINSTRUCTION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>	

	
	<!-- Definicion del template CUERPOENTRY -->
	<xsl:template name="CUERPOINSTRUCTION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="ENTRY" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
						
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="INSTRUCTION">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del ENTRY para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. ELEMENT y CLUSTER con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'activities']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
							<table class="padreseparador" style="width: 100%;">
								<tr>
									<td width="80%">
										<table width="100%">
											<tr>
												<td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
											</tr>
											<tr>
												<td></td>
											</tr>
										</table>
									</td>
									<td class="separadorbtn">
										<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
										<script>
											$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											}); 
											$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
											});
											$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											});
										</script>
									</td>
								</tr>
							</table>
						</div>
					</xsl:if>
				</xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOENTRY">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
			<!-- Definicion de templates ACTION -->
	<xsl:template match="*[a:rm_type_name='ACTION'] " name="ACTION" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOACTION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>	
	
	<!-- Definicion del template CUERPOENTRY -->
	<xsl:template name="CUERPOACTION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="ENTRY" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
						
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="ACTION">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del ENTRY para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. ELEMENT y CLUSTER con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'description']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
							<table class="padreseparador" style="width: 100%;">
								<tr>
									<td width="80%">
										<table width="100%">
											<tr>
												<td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
											</tr>
											<tr>
												<td></td>
											</tr>
										</table>
									</td>
									<td class="separadorbtn">
										<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
										<script>
											$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											}); 
											$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
											});
											$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											});
										</script>
									</td>
								</tr>
							</table>
						</div>
					</xsl:if>
				</xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOENTRY">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
				<!-- Definicion de templates EVALUATION -->
	<xsl:template match="*[a:rm_type_name='EVALUATION'] " name="EVALUATION" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOEVALUATION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>	
	
		<!-- Definicion del template CUERPOEVALUATION -->
	<xsl:template name="CUERPOEVALUATION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="EVALUATION" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
					
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="EVALUATION">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del EVALUATION para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. (EVENTS/POINT_EVENTS/INTERVAL_EVENTS y ITEM_TREE...						con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'data']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						<!-- protocol should be really shown on screen<xsl:for-each select="a:attributes[a:rm_attribute_name = 'protocol']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>-->
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					    <div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
										      <td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
										</tr>
										<tr>
										      <td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										});
									</script>
								</td>
							</tr>
						</table>
					        </div>
				</xsl:if>
			     </xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOEVALUATION">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- Definicion de templates ADMIN_ENTRY -->
	<xsl:template match="*[a:rm_type_name='ADMIN_ENTRY'] " name="ADMIN_ENTRY" >
		
		<!-- Obtenemos las ocurrencias definidas al DIV -->
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOADMIN_ENTRY">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>	
	
	<!-- Definicion del template CUERPOENTRY -->
	<xsl:template name="CUERPOADMIN_ENTRY">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Variable del div -->
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat(idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idsubdivcontainerINI" select="concat('subcontainer',./a:node_id)" />
			<xsl:variable name="idsubdivcontainer" select="concat($idsubdivcontainerINI,$i)" />
			
			<!-- Obtenemos el margen del contendor. Contamos cuantos padres de tipo SECTION  -->
			<xsl:variable name="tabs">
				<xsl:value-of select="count(ancestor::a:children)"/>
			</xsl:variable>
			
			<!-- Variables para el titulo del boton de multiples ocurrencias -->
			<xsl:variable name="idatt">
				<xsl:value-of select="./a:node_id"/>
			</xsl:variable>
			<xsl:variable name="auxiliar" >
				<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
			</xsl:variable>
			<!-- Fin variables -->
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<xsl:variable name="margin" select="($marginrule * $tabs) + 5"/>
			<div id="{$idcontainer}"  min="{$min}" max="{$max}"  type="ENTRY" idclon="{$idcontainer}" style="margin-left: {$margin}px;" class="desmarca" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<fieldset>
					
					<legend>
						
						<!-- Show button collapsable -->
						<xsl:variable name="idimgcollapsableINI" select="concat('collasable',./a:node_id)" />
						<xsl:variable name="idimgcollapsable" select="concat($idimgcollapsableINI,$i)" />
						<xsl:variable name="jidimgcollapsable" select="concat('#',$idimgcollapsable)" />
						
						<img id="{$idimgcollapsable}"  src="icons/down.png" title="Collapse or descollapse Entry"  style="visibility: visible"/>
						<script>
							$(("<xsl:value-of select="$jidimgcollapsable"/>")).on('click', function(){
							showhide(("<xsl:value-of select="$idsubdivcontainer"/>"),("<xsl:value-of select="$idimgcollapsable"/>"));
							});
						</script>
						<xsl:text>   </xsl:text>
						
						<xsl:call-template name="titulo"/><xsl:text>   </xsl:text>
						
						<!-- Chek required -->
						<xsl:if test="a:attributes/a:existence/a:lower >= 1">
							<span class="required"></span>
						</xsl:if>
						
						<xsl:if test="$i = 1">
							<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
							<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{jqidcontainer}','{$jqimgclinical}')"/>
						</xsl:if>
						
					</legend>
					
					<div id="{$idsubdivcontainer}"  type="ADMIN_ENTRY">
						
						<!-- Comprobamos si es un slot de tipo entry. Si fuera asi mostramos info extra en el dic clinical -->
						<xsl:if test="@xsi:type = 'ARCHETYPE_SLOT'" >
							<div><img src="icons/slot.png"   style="visibility: visible; margin-left:5px;"/><font class="bold"><xsl:text>Include:  </xsl:text></font><xsl:value-of select="a:includes/a:string_expression"/><font class="bold"><xsl:text>Exclude: </xsl:text></font><xsl:value-of select="a:excludes/a:string_expression"/></div>
						</xsl:if>
						
						<!-- Procesamos resto de nodos del ENTRY para conseguir el encapsulamiento del fieldset  -->
						<!-- Es decir el resto de nodos del arquetipo. ELEMENT y CLUSTER con todos los subtipos -->
						
						<xsl:for-each select="a:attributes[a:rm_attribute_name = 'data']" >
							<xsl:for-each select="a:children">
								<xsl:apply-templates select="." />					
							</xsl:for-each>
						</xsl:for-each>
						
					</div>	
					
				</fieldset>
				
				<!-- Analizamos las propiedades del ENTRY -->
				<div class="technical"  id="{$idtec}" style="display:none;" >
					<ul>	
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
					</ul>
				</div>	
				
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
							<table class="padreseparador" style="width: 100%;">
								<tr>
									<td width="80%">
										<table width="100%">
											<tr>
												<td class="separador"  align="top"><xsl:text>&#160;</xsl:text></td>
											</tr>
											<tr>
												<td></td>
											</tr>
										</table>
									</td>
									<td class="separadorbtn">
										<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
										<script>
											$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											}); 
											$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
											});
											$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
											});
										</script>
									</td>
								</tr>
							</table>
						</div>
					</xsl:if>
				</xsl:if>
				
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOENTRY">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion del template CUERPOELEMENTO -->
	<xsl:template name="CUERPOELEMENTO">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Si numchildren es mayor que uno. Se define alternativa -->
			
			<xsl:variable name="idcontainerINI" select="concat('container',./a:node_id)"/>
			<xsl:variable name="idcontainer" select="concat($idcontainerINI,$i)"/>
			<xsl:variable name="jqidcontainer" select="concat('#',$idcontainer)"/>
			
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Creamos el div contenedor -->
			<!-- Antigua clase: class="contenedor" -->
			<div class="desmarca" id="{$idcontainer}" idclon="{$idcontainer}" type="ELEMENT" onmouseover="markcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" onmouseout="unmarkcontainer('{$jqidcontainer}','{$jqimgclinical}','{$jqimgtechnical}','yes')" >
				
				<!-- Montamos la variable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<label><xsl:call-template name="titulo" /><xsl:text>:  </xsl:text></label>
				
				<!-- Chek required -->
				<xsl:if test="a:attributes/a:existence/a:lower >= 1">
					<span class="required"></span>
				</xsl:if>
				
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinicalcont.png" title="{$ayudaclinica}" /><xsl:text>   </xsl:text>
					<img id="{$idimgtechnical}" src="icons/tecnicalcont.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$jqidcontainer}','{$jqidcontainer}','{$jqimgclinical}')"/>
				</xsl:if>
				
				
				
				<!-- Obtenemos si el element tiene alternativas. Miramos si tiene mas de un hijo -->
				<xsl:variable name="numchildren">
					<xsl:choose>
						<xsl:when test="a:attributes/a:children[@xsi:type = 'C_COMPLEX_OBJECT'] and a:attributes/a:rm_attribute_name = 'value'">
							<xsl:value-of select="count(a:attributes/a:children[parent::a:attributes/a:rm_attribute_name = 'value'])"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<!-- Analizamos el resto de los nodos -->
				<xsl:for-each select="a:attributes[a:rm_attribute_name = 'value']" >
					
					<xsl:apply-templates select="a:children">	
						<xsl:with-param name="alternativa" select="$numchildren" />
						<xsl:with-param name="idcontenedor" select="$jqidcontainer" />
					</xsl:apply-templates>
					
				</xsl:for-each> 	
				
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				
				<!-- Zone line button add new occurence -->
				<xsl:if test="$i = $count">
					<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqidcontainer"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqidcontainer"/>").removeClass("marca");
											$("<xsl:value-of select="$jqidcontainer"/>").addClass("desmarca");
										}); 
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			       </xsl:if>				
			</div>
			
			<!-- Analizamos las propiedades del ELEMENT -->
			<div class="technical"  id="{$idtec}" style="display:none; " >
				<ul>	
					<xsl:call-template name="showinfoclass" />
					<xsl:call-template name="showattributesclasscontainers"></xsl:call-template>
				</ul>
			</div>
			<script >
				<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
			</script>
			
			
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOELEMENTO">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Defincion de templates ELEMENT -->
	<xsl:template match="*[a:rm_type_name='ELEMENT']">
	 	
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOELEMENTO">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			
		</xsl:call-template>
			
	</xsl:template>
	

	<!-- Definicion del template CUERPOSIMPLETEXT -->
	<xsl:template name="CUERPOSIMPLETEXT">
		
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca"  onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
					
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:call-template name="stringnode" >
					<xsl:with-param name="field">originalText</xsl:with-param>
					<xsl:with-param name="size">45</xsl:with-param>
				</xsl:call-template>
				
			
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				      <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											    $("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
												$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				      </xsl:if>
				</xsl:if>	
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOSIMPLETEXT">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>




	<!-- Definicion comportamiento DV_TEXT -->
	<xsl:template match="*[a:rm_type_name='DV_TEXT' ]" name="DV_TEXT">
		
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPODV_TEXT">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>
	
	</xsl:template>
	
		<!-- Definicion del template CUERPODV_TEXT -->
	<xsl:template name="CUERPODV_TEXT">
		
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca"  onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
					
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: value. -->
				<xsl:call-template name="stringnode" >
					<xsl:with-param name="field">value</xsl:with-param>
					<xsl:with-param name="size">45</xsl:with-param>
				</xsl:call-template>
				
			
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				      <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											    $("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
												$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				      </xsl:if>
				</xsl:if>	
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOSIMPLETEXT">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	
	<!-- Definicion de template OID -->
	<xsl:template match="*[a:rm_type_name='OID']">
		<xsl:call-template name="titulo"/>
		
		<xsl:for-each select="a:attributes">
			<xsl:call-template name="nombrecampos" />
			<xsl:call-template name="tipocampos" />	
		</xsl:for-each>
		
	</xsl:template>
	
	
	<!-- ********************************** TRATAMIENTO CASO : IVL *********************************************************** -->
	
	<!-- Definicion del template CUERPOIVL -->
	<xsl:template name="CUERPOIVL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Podemos tener intervalos de:
				PQ, TS, DURATION, RTO, ORD -->
	
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Analizamos que tipo de IVL es y en función de esto, renderizamos los objetos correspondientes -->
				<!-- CASO TS -->
				<xsl:if test="a:attributes/a:children/a:rm_type_name = 'TS'">
					<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
					<xsl:variable name="idtimer" select="concat($idtimerINI,$id)"/>
					<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
					From: <input type="text" id="{$idtimer}"/>
					<xsl:call-template name="timernode" >
						<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
					</xsl:call-template>
					<xsl:variable name="idtimer1INI" select="concat('timer1',$id)"/>
					<xsl:variable name="idtimer1" select="concat($idtimer1INI,$i)"/>
					<xsl:variable name="jidtimer1" select="concat('#',$idtimer1)"/>
					To: <input type="text" id="{$idtimer1}"/>
					<xsl:call-template name="timernode" >
						<xsl:with-param name="id"><xsl:value-of select="$jidtimer1"/></xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				
				<!-- CASO PQ -->
				<xsl:if test="a:attributes/a:children/a:rm_type_name = 'PQ'">
					<fieldset >
						<legend class="mini">From:</legend>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text><!-- Caso en el que la Unit tenga valores definidos -->
						<xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
						
					</fieldset>
					<fieldset >
						<legend class="mini">To:</legend>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text><!-- Caso en el que la Unit tenga valores definidos -->
						<xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
					</fieldset>
				</xsl:if>
				<!-- CASO DURATION -->
				<xsl:if test="a:attributes/a:children/a:rm_type_name = 'DURATION'">
					
					<fieldset >
						<legend class="mini">From:</legend>
						<xsl:variable name="idyearINI" select="concat('year',./a:node_id)"/>
						<xsl:variable name="idyear" select="concat($idyearINI,$i)"/>
						<xsl:variable name="jqyear" select="concat('#',$idyear)"/>
						
						<xsl:text>Years: </xsl:text><input id="{$idyear}"  size="10" />
						
						<xsl:call-template name="spinner">
							<xsl:with-param name="id"><xsl:value-of select="$jqyear"/></xsl:with-param>
						</xsl:call-template>
						
						<xsl:text> Months: </xsl:text>
						<xsl:call-template name="stringnode" >
							<xsl:with-param name="field">months</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Days: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">days</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Hours: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">hours</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Minutes: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">minutes</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
					</fieldset>
					<fieldset >
						<legend class="mini">To:</legend>
						<xsl:variable name="idyear2INI" select="concat('year',./a:node_id)"/>
						<xsl:variable name="idyear2" select="concat(idyear2INI,./a:node_id)"/>
						<xsl:variable name="jqyear2" select="concat('#',$idyear2)"/>
						
						<xsl:text>Years: </xsl:text><input id="{$idyear2}"  size="10" />
						
						<xsl:call-template name="spinner">
							<xsl:with-param name="id"><xsl:value-of select="$jqyear2"/></xsl:with-param>
						</xsl:call-template>
						
						<xsl:text> Months: </xsl:text>
						<xsl:call-template name="stringnode" >
							<xsl:with-param name="field">months</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Days: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">days</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Hours: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">hours</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
						<xsl:text>Minutes: </xsl:text><xsl:call-template name="stringnode" >
							<xsl:with-param name="field">minutes</xsl:with-param>
							<xsl:with-param name="size">10</xsl:with-param>
						</xsl:call-template> 
					</fieldset>	
				</xsl:if>
				<!-- CASO RTO's -->
				<xsl:if test="a:attributes/a:children/a:rm_type_name = 'RTO'">
					<fieldset >
						<legend class="mini">From:</legend>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text>
						<xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
						<xsl:text> / </xsl:text>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text>
						<xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
					</fieldset>
					<fieldset >
						<legend class="mini">To:</legend>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text>
						<xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
						<xsl:text> / </xsl:text>
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text><xsl:if test="a:attributes" >
							<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
								<xsl:for-each select="a:attributes/a:children">
									<xsl:apply-templates select="." />
								</xsl:for-each>
							</xsl:if>
						</xsl:if>					
						<!-- Caso en el que la Unit no CS's definidos -->
						<xsl:if test="a:attributes = false() ">
							<xsl:call-template name="stringnode"/> 
						</xsl:if>	
					</fieldset>
				</xsl:if>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
										creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											    $("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
												$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				    </xsl:if>
			          </xsl:if>
			</div>
		
		
		
		</xsl:if>
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOIVL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Definicion de template IVL -->
	<xsl:template match="*[a:rm_type_name='IVL']">
	
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOIVL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : IVL *********************************************************** -->
	
	
	<!-- ********************************** TRATAMIENTO CASO : TS         *********************************************************** -->
	
	<!-- Definicion del template CUERPOELEMENTO -->
	<xsl:template name="CUERPOTS">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
				<xsl:variable name="idtimer" select="concat($idtimerINI,$i)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				
				<input type="text" id="{$idtimer}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				<xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
			              	   </xsl:if>
			           </xsl:if>
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOTS">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template TS -->
	<xsl:template match="*[a:rm_type_name='DV_DATE_TIME']">
		
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
	
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOTS">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>
	
		
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : TS *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : IVLTS *********************************************************** -->
	
	
	<!-- Definicion del template CUERPOELEMENTO -->
	<xsl:template name="CUERPOIVLTS">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="clinical" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
				<xsl:variable name="idtimer" select="concat($idtimerINI,$id)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				From: <input type="text" id="{$idtimer}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				<xsl:variable name="idtimer1INI" select="concat('timer1',$id)"/>
				<xsl:variable name="idtimer1" select="concat($idtimer1INI,$id)"/>
				<xsl:variable name="jidtimer1" select="concat('#',$idtimer1)"/>
				To: <input type="text" id="{$idtimer1}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer1"/></xsl:with-param>
				</xsl:call-template>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
										        <td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
										        <td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				    </xsl:if>
			         </xsl:if>
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOIVLTS">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template IVLTS -->
	<xsl:template match="*[a:rm_type_name='IVLTS']">
		<!-- Adquirimos los parametros -->
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>

		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOIVLTS">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	

	<!-- ********************************** FIN TRATAMIENTO CASO : IVLTS *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : EIVL *********************************************************** -->
	
	<!-- Definicion del template CUERPOELEMENTO -->
	<xsl:template name="CUERPOEIVL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Adquirimos los parametros -->
			
			
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimer" select="concat('timer',$id)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				Time: <input type="text" id="{$idtimer}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				Offset: <select name="offset"><option >Antes</option><option >Despues</option></select>
				<xsl:variable name="idtimer1" select="concat('timer1',$id)"/>
				<xsl:variable name="jidtimer1" select="concat('#',$idtimer1)"/>
				Event: <select name="evento"><option >Desayuno</option><option >Comida</option><option >Merienda</option><option >Cena</option></select> 
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				 <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
							      <td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				      </xsl:if>
				</xsl:if>
			</div>



		</xsl:if>

		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOEIVL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template EIVL -->
	<xsl:template match="*[a:rm_type_name='EIVL']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOEIVL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	
	
	<!-- ********************************** FIN TRATAMIENTO CASO : EIVL *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : BL  *********************************************************** -->
	
	<!-- Definicion del template CUERPOBL-->
	<xsl:template name="CUERPOBL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
				
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<xsl:variable name="obligatory">
				<xsl:choose>
					<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
					<xsl:otherwise>norequired</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<select >
					<option>Yes</option>
					<option>No</option>
				</select><span class="{$obligatory}"></span>
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				<!--
					<xsl:for-each select="a:attributes">
					<xsl:call-template name="nombrecampos" />
					<xsl:call-template name="tipocampos" />	
					</xsl:for-each> -->
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none;">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>	
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
				</xsl:if>		
			</div>
			
			
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOBL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	

	<!-- Definicion de template BL -->
	<xsl:template match="*[a:rm_type_name='DV_BOOLEAN']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOBL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : BL *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : CS  *********************************************************** -->
	
	<!-- Definicion del template CUERPOELEMENTO -->
	<xsl:template name="CUERPOCS">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<xsl:if test="parent::a:attributes/a:rm_attribute_name = 'value' or parent::a:attributes/a:rm_attribute_name = 'parts' or parent::a:attributes/a:rm_attribute_name = 'items' or parent::a:attributes/a:rm_attribute_name = 'members' or parent::a:attributes/a:rm_attribute_name = 'content'">
				
				<!-- Adquirimos los parametros -->
				
				<!-- Definimos el DIV -->
				<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
				<xsl:variable name="id" select="concat($idINI,$i)"/>
				<xsl:variable name="jqid" select="concat('#',$id)"/>
				
				<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
				<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
				<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
				
				<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
				<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
				<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
				
				
				<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
				<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
				<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
				
				<!-- Obtenemos las ocurrencias definidas al DIV -->
				<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
				<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
				
				
				<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
					
					<xsl:if test="$alternativa >1">
						<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
					</xsl:if>
					
					<!-- Renderizamos ad-hoc los campos que debe de tener  
						este tipo basico -->
					<!-- Para este tipo son: -->
					<!-- Un input o combo de tipo String. Valor: originalText. -->
					<xsl:text>Code: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">codeValue</xsl:with-param>
					</xsl:call-template> 
					<xsl:text> Terminology: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">codingSchemeName</xsl:with-param>
					</xsl:call-template>
					
					<!--
						<xsl:for-each select="a:attributes">
						<xsl:call-template name="nombrecampos" />
						<xsl:call-template name="tipocampos" />	
						</xsl:for-each> -->
					
					<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
					<div id="{$idtec}" class="technical" style="display:none; ">
						<ul>
							<!-- Mostramos la info del elemento -->
							<xsl:call-template name="showinfoclass" />
							<xsl:call-template name="showattributesclasscontainers"/>
						</ul>
					</div>
					<script >
						<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
					</script>
					
					<!-- Montamos la veriable de ayuda clinica -->
					<xsl:variable name="ayudaclinica">
						<xsl:call-template name="descripcion"/>
					</xsl:variable>
					
					<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
					<xsl:if test="$i = 1">
						<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
						<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
					</xsl:if>
					
					<!-- Variables para el titulo del boton de multiples ocurrencias -->
					<xsl:variable name="idatt">
						<xsl:value-of select="./a:node_id"/>
					</xsl:variable>
					<xsl:variable name="auxiliar" >
						<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
					</xsl:variable>
					<!-- Fin variables -->
					
					<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
					<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
					<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
					
					<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
					<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
					
					<xsl:if test="$i = $count">
					  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
							<table class="padreseparador" style="width: 100%;">
								<tr>
									<td width="80%">
										<table width="100%">
											<tr>
												<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
											</tr>
											<tr>
												<td></td>
											</tr>
										</table>
									</td>
									<td class="separadorbtn">
										<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
										<script>
											$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
												creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
											
											}); 
											$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
												$("<xsl:value-of select="$jqid"/>").addClass("marca");
											});
											$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
											}); 
											
										</script>
									</td>
								</tr>
							</table>
						</div>
					  </xsl:if>
				         
				         </xsl:if>
				</div>
				
			</xsl:if>
			<!-- Caso simple en el que solo representa unidades  -->
			<xsl:if test="parent::a:attributes/a:rm_attribute_name = 'units' " >
				<xsl:call-template name="stringnode" >
				          	<xsl:with-param name="field">codeValue</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		
		
		</xsl:if>
		      
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCS">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<!-- Definicion de template CS -->
	<xsl:template match="*[a:rm_type_name='CS']" name="CS">	
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCS">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : CS *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : CV  *********************************************************** -->
	
	<xsl:template name="CUERPOCV">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio"  class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:text> Term: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">displayName</xsl:with-param>
				</xsl:call-template>
				<xsl:text>Code: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">codeValue</xsl:with-param>
				</xsl:call-template> 
				<xsl:text> Terminology: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">codingSchemeName</xsl:with-param>
				</xsl:call-template>
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				    </xsl:if>
			        </xsl:if>
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCV">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- Definicion de template CV -->
	<xsl:template match="*[a:rm_type_name='CV']" name="CV">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCV">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : CS *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : CD  *********************************************************** -->
	
	
	<xsl:template name="CUERPOCD" >
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				
				<!-- Si el tipo tiene binding definido mostramos solo un campo con toda esa informacion -->
				<xsl:if test="count(.//a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list) > 0">
					<xsl:text>Binding: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">codeValue</xsl:with-param>
					</xsl:call-template> 	
				</xsl:if>
				<!-- Sino tiene bindings definidos motramos los campos vacios -->
				<xsl:if test="count(.//a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list) = 0">
					<xsl:text> Term: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">displayName</xsl:with-param>
					</xsl:call-template>
					<xsl:text>Code: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">codeValue</xsl:with-param>
					</xsl:call-template> 
					<xsl:text> Terminology: </xsl:text><xsl:call-template name="stringnode" >
						<xsl:with-param name="field">codingSchemeName</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>
			       </xsl:if>		
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCD">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- Definicion de template CD -->
	<xsl:template match="*[a:rm_type_name='CD']" name="CD">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCD">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
		
	</xsl:template>
	
	
	<!-- ********************************** FIN TRATAMIENTO CASO : CD *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : CE  *********************************************************** -->
	
	<xsl:template name="CUERPOCE">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<!-- Si el tipo tiene binding definido mostramos solo un campo con toda esa informacion -->
				<table width="99%"  class="tiposC">
					
					<xsl:if test="count(a:attributes/a:children[a:rm_type_name='CD']) > 0">
						
						<!-- Averiguamos si hay algun CD que no tenga definido un codingSchemeName o un CodeValue sin list -->
						<xsl:variable name="isSomeEmptyScheme">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CD']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='codingSchemeName']) = 0">
									TRUE
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:variable name="isSomeEmptyCoding">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CD']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='codeValue']/a:children/a:item/a:list) = 0">
									TRUE
								</xsl:if>		
							</xsl:for-each>
						</xsl:variable>
						
						
						<!-- Implementacion caso 2 -->
						<!-- Hay valores en TODOS los CodedValue y si el CodedValue ha sido resuelto no tendra CodingScheme, pero si no ha
							sido resuelto debera contener CodingScheme -->
						<xsl:variable name="AllCodedValueHAVEScheme">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CD']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='codeValue']/a:children/a:item/a:list) > 0">
									<xsl:if test="not(contains(a:attributes[a:rm_attribute_name='codeValue']/a:children/a:item/a:list,'::'))" >
										<xsl:if test="count(a:attributes[a:rm_attribute_name='codingSchemeName']/a:children/a:item/a:list) = 0">
											FALSE
										</xsl:if>
									</xsl:if>
								</xsl:if>		
								
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:if test="not(contains($isSomeEmptyCoding,'TRUE'))  and not(contains($AllCodedValueHAVEScheme,'FALSE'))" >
							
							
							<tr>
								<td colspan="1"  align="left" >
									<xsl:text>Code: </xsl:text>
								</td>
								<td colspan="5">
									<select name="valores">
										
										<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CD']">
											
											
											<xsl:variable name="codingSchemeName"><xsl:value-of select="a:attributes[a:rm_attribute_name='codingSchemeName']/a:children/a:item/a:list"/></xsl:variable>
											<xsl:variable name="displayName"><xsl:value-of select="a:attributes[a:rm_attribute_name='displayName']/a:children/a:item/a:list"/></xsl:variable>
											<xsl:for-each select=".//a:attributes[a:rm_attribute_name='codeValue']/a:children/a:item/a:list">
												<option>
													<xsl:if test="contains(.,'::')">
														<xsl:value-of select="substring-before(.,'[')"/>
														<xsl:text> [</xsl:text>
														<xsl:value-of select="substring-before(substring-after(.,'['),'::')"/>
														<xsl:text>::</xsl:text>
														<xsl:value-of select="substring-before(substring-after(.,'::'),']')"/>
														<xsl:text>]</xsl:text>
													</xsl:if>
													<xsl:if test="not(contains(.,'::'))">
														<xsl:value-of select="$displayName"/>
														<xsl:text> [</xsl:text>
														<xsl:value-of select="$codingSchemeName"/>
														<xsl:text>::</xsl:text>
														<xsl:value-of select="."/>
														<xsl:text>]</xsl:text>
													</xsl:if>
												</option>
												
												
											</xsl:for-each>
										</xsl:for-each>
										
									</select>			
								</td>
							</tr>

						</xsl:if>
						<!-- Implementacion caso 3 -->
						<!--  Hay codigos en blanco o no hay codigos en blanco y si hay codingScheme en blanco y los codigos no son bindings -->
						<xsl:if test="((contains($isSomeEmptyCoding,'TRUE')) or ((not(contains($isSomeEmptyCoding,'TRUE')))  and (contains($AllCodedValueHAVEScheme,'FALSE'))))">
							<!-- <xsl:if test="((contains($isSomeEmptyScheme,'TRUE')) and (contains($AllCodedValueHAVEScheme,'FALSE')))"> -->
							<tr>
								<td  align="left">
									<xsl:text> DisplayName: </xsl:text>
								</td>
								<td>
									<select name="valoresdisplayname">
										<!-- Añadimos los displayName -->
										<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'displayName']/a:children/a:item/a:list">
											<option><xsl:value-of select="."/></option>
										</xsl:for-each>
										<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list">
											<xsl:if test="contains(.,'::')">
												<option><xsl:value-of select="substring-before(.,'[')"/></option>	
											</xsl:if>
											
										</xsl:for-each>
										
							 			
									</select>
								</td>
								<td align="left">
									<xsl:text>Code: </xsl:text>		
								</td>
								<td>
									<select name="valorescode">
										<!-- Añadimos los Code -->
										
										<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'mappings']/a:children[a:rm_type_name= 'CD']/a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list">
											<xsl:if test="contains(.,'::')" >
												<option><xsl:value-of select="substring-before(substring-after(.,'::'),']')"/></option>
											</xsl:if>
											<xsl:if test="not(contains(.,'::'))" >
												<option><xsl:value-of select="."/></option>
											</xsl:if>
											
										</xsl:for-each>	
									</select>
								</td>
								<td  align="left">
									<xsl:text> Terminology: </xsl:text>	
								</td>	
								<td>
									<select name="valoresterminology">
										<!-- Añadimos los displayName -->
										<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'codingSchemeName']/a:children/a:item/a:list">
											<option><xsl:value-of select="."/></option>
										</xsl:for-each>
										<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list">
											<xsl:if test="contains(.,'::')" >
												<option><xsl:value-of select="substring-before(substring-after(.,'['),'::')"/></option>
											</xsl:if>
										</xsl:for-each>
										
									</select>
									
								</td>
							</tr>
							
							
							<!-- </xsl:if> -->
							
						</xsl:if>
						
						
					</xsl:if>
					
					<!-- No existen CD's definidos o solo hay un patron definido en el valor. Se muestran en blanco los campos -->
					<xsl:if test="(count(a:attributes/a:children[a:rm_type_name = 'CD']) = 0) or ((count(a:attributes/a:children[a:rm_type_name = 'CD']/a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:pattern) > 0) and (count(a:attributes/a:children[a:rm_type_name = 'CD']/a:attributes[a:rm_attribute_name = 'codingSchemeName']/a:children/a:item/a:list) = 0))">
						<tr>
							<td  align="left">
								<xsl:text> Description: </xsl:text>
							</td>
							<td>
								<xsl:call-template name="stringnode" >
									<xsl:with-param name="field">displayName</xsl:with-param>
									<xsl:with-param name="size"></xsl:with-param>
								</xsl:call-template>
							</td>
							<td align="left">
								<xsl:text>Code: </xsl:text>		
							</td>
							<td>
								<xsl:call-template name="stringnode" >
									<xsl:with-param name="field"></xsl:with-param>
									<xsl:with-param name="size"></xsl:with-param>
								</xsl:call-template>	
							</td>
							<td  align="left">
								<xsl:text> Terminology: </xsl:text>	
							</td>	
							<td>
								<xsl:call-template name="stringnode" >
									<xsl:with-param name="field">codingSchemeName</xsl:with-param>
									<xsl:with-param name="size"></xsl:with-param>
								</xsl:call-template>	
							
							</td>
						</tr>
					</xsl:if>
					
					<!--
						<xsl:for-each select="a:attributes/a:children">
						<tr>
						<td colspan="6">
						<xsl:apply-templates select="." />
						</td>
						</tr>
						</xsl:for-each> -->
					
					
				
				</table>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				    <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>
			         </xsl:if>
				
			</div>
			
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCE">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!-- Definicion de template CE -->
	<xsl:template match="*[a:rm_type_name='CE']" name="CE">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCE">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : CE *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : CODED_TEXT  *********************************************************** -->

	
	<xsl:template name="CUERPOCODED_TEXT">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<!-- Montamos la veriable de ayuda clinica -->
			<xsl:variable name="ayudaclinica">
				<xsl:call-template name="descripcion"/>
			</xsl:variable>
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<table width="99%"  class="tiposC">
					<tr>
						<td colspan="1"  align="left" >
						<!--	<xsl:text>Value: </xsl:text>
						</td>
						<td colspan="5">-->
							<xsl:call-template name="stringnode" >
								<xsl:with-param name="field">value</xsl:with-param>
								<xsl:with-param name="size"></xsl:with-param>
							</xsl:call-template>			
						</td>
					</tr>
					<!-- Existen CD's definidos. Hay que resolverlos -->
					<xsl:if test="count(a:attributes/a:children[a:rm_type_name='CODE_PHRASE']) > 0">
					
						<!-- Implementacion caso 1. Hay binding definidos. No hay ningun codingSchemeName ningun CD definido.  -->
						<!--
						    <xsl:if test="((count(.//a:attributes/a:children[a:rm_type_name='CD']/a:attributes[a:rm_attribute_name='codingSchemeName']) = 0)) " >
							
						    	<xsl:if test="contains(a:attributes[a:rm_attribute_name='codedValue']/a:children/a:attributes/a:children/a:item/a:list,'::')">
						    	<tr>
								<td colspan="1"  align="left" >
									<xsl:text>Binding: </xsl:text>
								</td>
								<td colspan="5">
									<xsl:call-template name="stringnode" >
										<xsl:with-param name="field">codeValue</xsl:with-param>
										<xsl:with-param name="size"></xsl:with-param>
									</xsl:call-template>			
								</td>
						    		
						    	</tr>
						    	</xsl:if>
						    </xsl:if>	
						 -->
						 
						<!-- <xsl:variable name="isLocal">
							<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item">
								<xsl:if test="a:list = 'local'">
									TRUE
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						 
						 	 <xsl:variable name="isLocal">
							<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item">
								<xsl:if test="a:list = 'local'">
									TRUE
								</xsl:if>
							</xsl:for-each>
						</xsl:variable> -->
						 
						 <!-- Averiguamos si hay algun CD que no tenga definido un codingSchemeName o un CodeValue sin list -->
						<xsl:variable name="isSomeEmptyScheme">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CODE_PHRASE']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='codingSchemeName']) = 0">
									TRUE
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
							
						<xsl:variable name="isSomeEmptyCoding">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CODE_PHRASE']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='defining_code']/a:children/a:item/a:list) = 0">
									TRUE
								</xsl:if>		
							</xsl:for-each>
						</xsl:variable>
						
						
						<!-- Implementacion caso 2 -->
						<!-- Hay valores en TODOS los CodedValue y si el CodedValue ha sido resuelto no tendra CodingScheme, pero si no ha
						sido resuelto debera contener CodingScheme -->
						<!--<xsl:variable name="AllCodedValueHAVEScheme">
							<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CD']">
								<xsl:if test="count(a:attributes[a:rm_attribute_name='defining_code']/a:children/a:item/a:list) > 0">
									<xsl:if test="not(contains(a:attributes[a:rm_attribute_name='defining_code']/a:children/a:item/a:list,'::'))" >
										<xsl:if test="count(a:attributes[a:rm_attribute_name='defining_code']/a:children/a:item/a:list) = 0">
											FALSE
										</xsl:if>
									</xsl:if>
								</xsl:if>		
								
							</xsl:for-each>
						</xsl:variable> -->
						
						<xsl:if test="not(contains($isSomeEmptyCoding,'TRUE'))  " > <!--and not(contains($AllCodedValueHAVEScheme,'FALSE'))-->
							
								
								<tr>
									<td colspan="1"  align="left" >
										<xsl:text>Code: </xsl:text>
									</td>
									<td colspan="5">
										<select name="valores">
											
											<xsl:for-each select=".//a:attributes/a:children[a:rm_type_name='CODE_PHRASE']">
												
												
												<xsl:variable name="codingSchemeName"><xsl:value-of select="a:attributes[a:rm_attribute_name = 'defining_code']/a:children/a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list"/></xsl:variable>
												<xsl:variable name="displayName"><xsl:value-of select="a:attributes[a:rm_attribute_name='value']/a:children/a:item/a:list"/></xsl:variable>
												<xsl:for-each select=".//a:attributes[a:rm_attribute_name='code_string']/a:children/a:item/a:list">
													<option>
														<xsl:if test="contains(.,'::')">
															<xsl:value-of select="substring-before(.,'[')"/>
															<xsl:text> [</xsl:text>
															 <xsl:value-of select="substring-before(substring-after(.,'['),'::')"/>
															<xsl:text>::</xsl:text>
															<xsl:value-of select="substring-before(substring-after(.,'::'),']')"/>
															<xsl:text>]</xsl:text>
														</xsl:if>
														<xsl:if test="not(contains(.,'::'))">
															<xsl:value-of select="$displayName"/>
															<xsl:text> [</xsl:text>
															<xsl:value-of select="$codingSchemeName"/>
															<xsl:text>::</xsl:text>
															<xsl:value-of select="."/>
															<xsl:text>]</xsl:text>
														</xsl:if>
													</option>
													
													
												</xsl:for-each>
											</xsl:for-each>
											
										</select>			
									</td>
								</tr>
								
							
							
							
						</xsl:if>
						<!-- Implementacion caso 3 -->
						<!--  Hay codigos en blanco o no hay codigos en blanco y si hay codingScheme en blanco y los codigos no son bindings -->
						<!--<xsl:if test="((contains($isSomeEmptyCoding,'TRUE')) )"> or ((not(contains($isSomeEmptyCoding,'TRUE')))  and (contains($AllCodedValueHAVEScheme,'FALSE')) )-->
						<!--		<tr>
									<td  align="left">
										<xsl:text> DisplayName: </xsl:text>
									</td>
									<td>
										<select name="valoresdisplayname">-->
											<!-- Añadimos los displayName -->
						<!--					<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list">
												<option><xsl:value-of select="."/></option>
											</xsl:for-each>
											<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'code_string']/a:children/a:item/a:list">
												<xsl:if test="contains(.,'::')">
													<option><xsl:value-of select="substring-before(.,'[')"/></option>	
												</xsl:if>
												
											</xsl:for-each>
											
											
										</select>
									</td>
									<td align="left">
										<xsl:text>Code: </xsl:text>		
									</td>
									<td>
										<select name="valorescode">-->
											<!-- Añadimos los Code -->
											
							<!--				<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'codedValue']/a:children[a:rm_type_name= 'CD']/a:attributes[a:rm_attribute_name = 'codeValue']/a:children/a:item/a:list">
												<xsl:if test="contains(.,'::')" >
													<option><xsl:value-of select="substring-before(substring-after(.,'::'),']')"/></option>
												</xsl:if>
												<xsl:if test="not(contains(.,'::'))" >
													<option><xsl:value-of select="."/></option>
												</xsl:if>
												
											</xsl:for-each>	
										</select>
									</td>
									<td  align="left">
										<xsl:text> Terminology: </xsl:text>	
									</td>	
									<td>
										<select name="valoresterminology">-->
											<!-- Añadimos los displayName -->
							<!--				<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list">
												<option><xsl:value-of select="."/></option>
											</xsl:for-each>
											<xsl:for-each select=".//a:attributes[a:rm_attribute_name = 'code_string']/a:children/a:item/a:list">
												<xsl:if test="contains(.,'::')" >
													<option><xsl:value-of select="substring-before(substring-after(.,'['),'::')"/></option>
												</xsl:if>
											</xsl:for-each>
											
											
										</select>-->
										<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
							<!--			<xsl:if test="$i = 1">
											<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
											<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
										</xsl:if>
									</td>
								</tr>-->
								
								
							<!-- </xsl:if> 
							
						</xsl:if>-->
						
						
					</xsl:if>
					
					<!-- No existen CD's definidos o solo hay un patron definido en el valor. Se muestran en blanco los campos -->
					<xsl:if test="(count(a:attributes/a:children[a:rm_type_name = 'CODE_PHRASE']) = 0) or ((count(a:attributes/a:children[a:rm_type_name = 'CODE_PHRASE']/a:attributes[a:rm_attribute_name = 'defining_code']/a:children/a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:pattern) > 0) and (count(a:attributes/a:children[a:rm_type_name = 'CODE_PHRASE']/a:attributes[a:rm_attribute_name = 'defining_code']/a:children/a:attributes[a:rm_attribute_name = 'terminology_id']/a:children/a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list) = 0))">
					<tr>
						<td  align="left">
							<xsl:text> Description: </xsl:text>
						</td>
						<td>
							<xsl:call-template name="stringnode" >
								<xsl:with-param name="field">displayName</xsl:with-param>
								<xsl:with-param name="size"></xsl:with-param>
							</xsl:call-template>
						</td>
						<td align="left">
							<xsl:text>Code: </xsl:text>		
						</td>
						<td>
							<xsl:call-template name="stringnode" >
								<xsl:with-param name="field"></xsl:with-param>
								<xsl:with-param name="size"></xsl:with-param>
							</xsl:call-template>	
						</td>
						<td  align="left">
							<xsl:text> Terminology: </xsl:text>	
						</td>	
						<td>
							<xsl:call-template name="stringnode" >
								<xsl:with-param name="field">codingSchemeName</xsl:with-param>
								<xsl:with-param name="size"></xsl:with-param>
							</xsl:call-template>	
							<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
							<xsl:if test="$i = 1">
								<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
								<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
							</xsl:if>
						</td>
					</tr>
					</xsl:if>
				
					<!--
					<xsl:for-each select="a:attributes/a:children">
					<tr>
						<td colspan="6">
						<xsl:apply-templates select="." />
						</td>
					</tr>
					</xsl:for-each> -->
				
				
				</table>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				
				
				
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>
			       </xsl:if>
			</div>
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOCODED_TEXT">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	

	<!-- Definicion de template DV_CODED_TEXT -->
	<xsl:template match="*[a:rm_type_name='DV_CODED_TEXT']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOCODED_TEXT">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- ********************************** FIN TRATAMIENTO CASO : CODED_TEXT *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : DATE  *********************************************************** -->
	
	<xsl:template name="CUERPODATE">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
				<xsl:variable name="idtimer" select="concat($idtimerINI,$i)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				<input type="text" id="{$idtimer}"/>
				<xsl:call-template name="datenode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>
			        </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPODATE">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template DATE -->
	<xsl:template match="*[a:rm_type_name='DV_DATE']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPODATE">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
			
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : DATE  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : DURATION *********************************************************** -->
	
	
	<xsl:template name="CUERPODURATION">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:variable name="idyearINI" select="concat('year',./a:node_id)"/>
				<xsl:variable name="idyear" select="concat($idyearINI,$i)"/>
				<xsl:variable name="jqyear" select="concat('#',$idyear)"/>
				
				<xsl:text>Years: </xsl:text><input id="{$idyear}"  size="10" />
				
				<xsl:call-template name="spinner">
					<xsl:with-param name="id"><xsl:value-of select="$jqyear"/></xsl:with-param>
				</xsl:call-template>
				
				<xsl:text> Months: </xsl:text>
				<xsl:call-template name="stringnode" >
					<xsl:with-param name="field">months</xsl:with-param>
					<xsl:with-param name="size">10</xsl:with-param>
				</xsl:call-template> 
				<xsl:text>Days: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">days</xsl:with-param>
					<xsl:with-param name="size">10</xsl:with-param>
				</xsl:call-template> 
				<xsl:text>Hours: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">hours</xsl:with-param>
					<xsl:with-param name="size">10</xsl:with-param>
				</xsl:call-template> 
				<xsl:text>Minutes: </xsl:text><xsl:call-template name="stringnode" >
					<xsl:with-param name="field">minutes</xsl:with-param>
					<xsl:with-param name="size">10</xsl:with-param>
				</xsl:call-template> 
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				  </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPODURATION">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template DURATION -->
	<xsl:template match="*[a:rm_type_name='DURATION']" name="DURATION">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPODURATION">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : DURATION  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : INT  *********************************************************************** -->
	
	
	<!-- Definicion de template INT  -->
	
	<xsl:template name="CUERPOINT">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:call-template name="numnode"/>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOINT">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<xsl:template match="*[a:rm_type_name='DV_COUNT']" name="DV_COUNT">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOINT">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
			
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : INT  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : ORD  *********************************************************************** -->
	
	<!-- Definicion de template ORD -->
	<xsl:template name="CUERPOORD">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Analizamos si el padre es de tipo ELEMENT. Si es estamos empezando a analizar
				el conjunto de ord's que deben aparecer                                                                                    -->
			<xsl:if test="(preceding-sibling::a:children/a:rm_type_name = not(node()))">
				
				<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
				<xsl:variable name="id" select="concat($idINI,$i)"/>
				<xsl:variable name="jqid" select="concat('#',$id)"/>
				
				<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
				<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
				<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
				
				<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
				<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
				<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
				
				
				<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
				<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
				<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
				
				<!-- Obtenemos las ocurrencias definidas al DIV -->
				<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
				<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
				
				
				<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
					
					<!-- Procesamos todos los ords -->
					<select name="ord" style="width: 180px">
						<xsl:for-each select="parent::a:attributes/./a:children">
							<xsl:sort select="a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list"/>
							<xsl:if test="a:rm_type_name = 'DV_ORDINAL'">
								<xsl:call-template name="optionord" />
							</xsl:if>
						</xsl:for-each>
					</select>
					
					<div id="{$idtec}" class="technical" style="display:none; ">
						<ul>
							<!-- Mostramos la info del elemento -->
							<xsl:call-template name="showinfoclass" />
							<xsl:call-template name="showattributesclasscontainers"/>
						</ul>
					</div>
					<script >
						<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
					</script>
					
					<!-- Montamos la veriable de ayuda clinica -->
					<xsl:variable name="ayudaclinica">
						<xsl:call-template name="descripcion"/>
					</xsl:variable>
					
					<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
					<xsl:if test="$i = 1">
						<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
						<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
					</xsl:if>
					
					<!-- Variables para el titulo del boton de multiples ocurrencias -->
					<xsl:variable name="idatt">
						<xsl:value-of select="./a:node_id"/>
					</xsl:variable>
					<xsl:variable name="auxiliar" >
						<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
					</xsl:variable>
					<!-- Fin variables -->
					
					<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
					<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
					<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
					
					<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
					<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
					<xsl:if test="$i = $count">
					  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
						<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
							<table class="padreseparador" style="width: 100%;">
								<tr>
									<td width="80%">
										<table width="100%">
											<tr>
												<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
											</tr>
											<tr>
												<td></td>
											</tr>
										</table>
									</td>
									<td class="separadorbtn">
										<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
										<script>
											$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
												creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
											
											}); 
											$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
												$("<xsl:value-of select="$jqid"/>").addClass("marca");
											});
											$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
												$("<xsl:value-of select="$jqid"/>").removeClass("marca");
												$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
											}); 
											
										</script>
									</td>
								</tr>
							</table>
						</div>
					  </xsl:if>
				         </xsl:if>
				</div>
			</xsl:if>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOORD">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<xsl:template match="*[a:rm_type_name='DV_ORDINAL']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOORD">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : ORD  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : ED  *********************************************************************** -->
	
	<xsl:template name="CUERPOED">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio"  name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<input type="file" ></input>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			             </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOED">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template ED -->
	<xsl:template match="*[a:rm_type_name='DV_MULTIMEDIA']">
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOED">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : ED  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : EIVL  *********************************************************************** -->
	
	<xsl:template name="CUERPOEIVLL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio"  name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
				<xsl:variable name="idtimer" select="concat($idtimerINI,$i)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				
				From: <input type="text" id="{$idtimer}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				<xsl:variable name="idtimer1INI" select="concat('timer1',$id)"/>
				<xsl:variable name="idtimer1" select="concat($idtimer1INI,$i)"/>
				<xsl:variable name="jidtimer1" select="concat('#',$idtimer1)"/>
				To: <input type="text" id="{$idtimer1}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer1"/></xsl:with-param>
				</xsl:call-template>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			         </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOEIVLL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template EIVL -->
	<xsl:template match="*[a:rm_type_name='EIVL']">
	
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOEIVLL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : EIVL  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : PQ  *********************************************************************** -->
	
	<xsl:template name="CUERPOPQ">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				
				<xsl:if test="a:attributes/a:rm_attribute_name = 'magnitude' " >
				<xsl:text>Magnitude: </xsl:text>
				<xsl:call-template name="numnode" >
				          	<xsl:with-param name="field">magnitude</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

				<xsl:if test="a:attributes/a:rm_attribute_name = 'units' " >
				<xsl:text>Units: </xsl:text>
				<xsl:call-template name="stringnode" >
				          	<xsl:with-param name="field">units</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
				
				
				
			<!--	<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
				<xsl:text>Unit: </xsl:text>-->
				<!-- Caso en el que la Unit tenga valores definidos -->
				<!--	<xsl:if test="a:attributes" >
				<xsl:call-template name="stringnode"/> -->
					<!--<xsl:if test="count(a:attributes/a:children[a:rm_type_name = 'CS']) &lt;= 1 ">
						<xsl:for-each select="a:attributes/a:children">
							<xsl:apply-templates select="." />
						</xsl:for-each>
					</xsl:if>-->
				<!--	</xsl:if>					-->
				<!-- Caso en el que la Unit no CS's definidos -->
			<!--		<xsl:if test="a:attributes = false() ">
					 <xsl:call-template name="stringnode"/> 
				</xsl:if>	-->
				
				
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			         </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOPQ">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion de template DV_QUANTITY -->
	<xsl:template match="*[a:rm_type_name='DV_QUANTITY']">
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOPQ">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : PQ  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : II  *********************************************************************** -->
	
	<xsl:template name="CUERPOII">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:text>Id: </xsl:text><xsl:call-template name="stringnode"/>
				<xsl:text>OID: </xsl:text><xsl:call-template name="stringnode"/>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				     </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOII">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<!-- Definicion template II -->
	<xsl:template match="*[a:rm_type_name='II']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOII">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : II  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : REAL  *********************************************************************** -->
	
	<xsl:template name="CUERPOREAL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}" idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:call-template name="numnode"/>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOREAL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion template REAL -->
	<xsl:template match="*[a:rm_type_name='REAL']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOREAL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : REAL  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : RTO  *********************************************************************** -->
	
	<xsl:template name="CUERPORTO">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px"  onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio"  name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<fieldset>
					<legend class="mini">Numerator</legend>
				<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
				<xsl:text>Unit: </xsl:text>
				<xsl:if test="a:attributes" >
					<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
						<xsl:for-each select="a:attributes/a:children">
							<xsl:apply-templates select="." />
						</xsl:for-each>
					</xsl:if>
				</xsl:if>					
				<!-- Caso en el que la Unit no CS's definidos -->
				<xsl:if test="a:attributes = false() ">
					<xsl:call-template name="stringnode"/> 
				</xsl:if>	
				</fieldset>
				<fieldset>
					<legend class="mini">Denominator</legend>
				<!-- <xsl:text> / </xsl:text> -->
				<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
				<xsl:text>Unit: </xsl:text>
				<xsl:if test="a:attributes" >
					<xsl:if test="count(a:attributes/a:children/a:rm_type_name = 'CS') &lt;= 1 ">
						<xsl:for-each select="a:attributes/a:children">
							<xsl:apply-templates select="." />
						</xsl:for-each>
					</xsl:if>
				</xsl:if>					
				<!-- Caso en el que la Unit no CS's definidos -->
				<xsl:if test="a:attributes = false() ">
					<xsl:call-template name="stringnode"/> 
				</xsl:if>	
				</fieldset>
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPORTO">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Definicion template RTO -->
	<xsl:template match="*[a:rm_type_name='RTO']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPORTO">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
		
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : RTO  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : URI  *********************************************************************** -->
	
	<!-- Definicion template URI -->
	<xsl:template name="CUERPOURI">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px"  onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<xsl:call-template name="stringnode"/> 
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				  <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				     </xsl:if>
				</xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOURI">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	
	<xsl:template match="*[a:rm_type_name='URI']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOURI">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
	
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : URI  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : PIVL  *********************************************************************** -->
	
	<xsl:template name="CUERPOPIVL">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<!-- Definimos el DIV -->
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Componente DataPicker. -->
				<xsl:variable name="idtimerINI" select="concat('timer',$id)"/>
				<xsl:variable name="idtimer" select="concat($idtimerINI,$i)"/>
				<xsl:variable name="jidtimer" select="concat('#',$idtimer)"/>
				Start Date: <input type="text" id="{$idtimer}"/>
				<xsl:call-template name="datenode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer"/></xsl:with-param>
				</xsl:call-template>
				<xsl:variable name="idtimer1INI" select="concat('timer1',$id)"/>
				<xsl:variable name="idtimer1" select="concat($idtimer1INI,$i)"/>
				<xsl:variable name="jidtimer1" select="concat('#',$idtimer1)"/>
				Duration: <input type="text" id="{$idtimer1}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer1"/></xsl:with-param>
				</xsl:call-template>
				<xsl:variable name="idtimer2INI" select="concat('timer2',$id)"/>
				<xsl:variable name="idtimer2" select="concat($idtimer2INI,$i)"/>
				<xsl:variable name="jidtimer2" select="concat('#',$idtimer2)"/>
				Repeat Every: <input type="text" id="{$idtimer2}"/>
				<xsl:call-template name="timernode" >
					<xsl:with-param name="id"><xsl:value-of select="$jidtimer1"/></xsl:with-param>
				</xsl:call-template>
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if>
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("desmarca");
											$("<xsl:value-of select="$jqid"/>").addClass("marca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				       </xsl:if>
				</xsl:if>
			</div>	
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOPIVL">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- Definicion template PIVL -->
	<xsl:template match="*[a:rm_type_name='PIVL']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOPIVL">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
		
	</xsl:template>
	
	
	<!-- **********************************  FIN TRATAMIENTO CASO : URI  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : IVLPQ  *********************************************************************** -->
	
	<xsl:template name="CUERPOIVLPQ">
		<xsl:param name="i"      />
		<xsl:param name="count"  />
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		<!--begin_: Line_by_Line_Output -->
		<xsl:if test="$i &lt;= $count">
			<xsl:variable name="idINI" select="concat('stclinical',./a:node_id)"/>
			<xsl:variable name="id" select="concat($idINI,$i)"/>
			<xsl:variable name="jqid" select="concat('#',$id)"/>
			
			<xsl:variable name="idtecINI" select="concat('sttechnical',./a:node_id)"/>
			<xsl:variable name="idtec" select="concat($idtecINI,$i)"/>
			<xsl:variable name="jqidtec" select="concat('#',$idtec)"/>
			
			<xsl:variable name="idimgclinicalINI" select="concat('imgclinical',./a:node_id)"/>
			<xsl:variable name="idimgclinical" select="concat($idimgclinicalINI,$i)"/>
			<xsl:variable name="jqimgclinical" select="concat('#',$idimgclinical)"/>
			
			
			<xsl:variable name="idimgtechnicalINI" select="concat('imgtechnical',./a:node_id)"/>
			<xsl:variable name="idimgtechnical" select="concat($idimgtechnicalINI,$i)"/>
			<xsl:variable name="jqimgtechnical" select="concat('#',$idimgtechnical)"/>
			
			
			<!-- Obtenemos las ocurrencias definidas al DIV -->
			<xsl:variable name="min" select="a:occurrences/a:lower"></xsl:variable>
			<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
			
			
			<div min="{$min}" max="{$max}" id="{$id}"  idclon="{$id}" class="desmarca" style="margin-left:10px" onmouseover="markcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" onmouseout="unmarkcontainer('{$jqid}','{$jqimgclinical}','{$jqimgtechnical}','no')" >
				
				
				<xsl:if test="$alternativa >1">
					<input type="radio" class="radio" name='{$idcontenedor}' /><xsl:text>  </xsl:text><xsl:call-template name="titulo" /><xsl:text>:     </xsl:text>
				</xsl:if>
				
				<!-- Renderizamos ad-hoc los campos que debe de tener  
					este tipo basico -->
				<!-- Para este tipo son: -->
				<!-- Un input o combo de tipo String. Valor: originalText. -->
				<fieldset >
					<legend class="mini">From:</legend>
					<!--<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
					<xsl:text>Unit: </xsl:text> -->
					<xsl:if test="a:attributes" >
						<xsl:if test="count(a:attributes/a:children[a:rm_type_name = 'CS'] &lt;= 1)">
							<xsl:for-each select="a:attributes[a:rm_attribute_name = 'high']">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</xsl:if>
					</xsl:if>					
					<!-- Caso en el que la Unit no CS's definidos -->
					<xsl:if test="a:attributes = false() ">
						<!-- <xsl:call-template name="stringnode"/> -->
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text> <xsl:call-template name="stringnode"/>
					</xsl:if>	
				</fieldset>
				<fieldset >
					<legend class="mini">To:</legend>
					<!-- <xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
					<xsltext>Unit: </xsl:text> -->
					<xsl:if test="a:attributes" >
						<xsl:if test="count(a:attributes/a:children[a:rm_type_name = 'CS']) &lt;= 1 ">
							<xsl:for-each select="a:attributes[a:rm_attribute_name = 'low']">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</xsl:if>
					</xsl:if>					
					<!-- Caso en el que la Unit no CS's definidos -->
					<xsl:if test="a:attributes = false() ">
						<!-- <xsl:call-template name="stringnode"/> -->
						<xsl:text>Value: </xsl:text><xsl:call-template name="numnode"/>
						<xsl:text>Unit: </xsl:text> <xsl:call-template name="stringnode"/>
					</xsl:if>	
				</fieldset>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				
				
				
				<!-- Procesamos el resto de atributos del arquetipo si hubieran definido. -->
				<div id="{$idtec}" class="technical" style="display:none; ">
					<ul>
						<!-- Mostramos la info del elemento -->
						<xsl:call-template name="showinfoclass" />
						<xsl:call-template name="showattributesclasscontainers"/>
					</ul>
				</div>
				<script >
					<xsl:text>$("</xsl:text><xsl:value-of select="$jqidtec"/><xsl:text>").jstree({plugins : [ "themes", "html_data"] });</xsl:text>
				</script>
				
				<!-- Montamos la veriable de ayuda clinica -->
				<xsl:variable name="ayudaclinica">
					<xsl:call-template name="descripcion"/>
				</xsl:variable>
				
				<!-- Añadimos los botones de ayuda clinica y ayuda tecnica -->
				<xsl:if test="$i = 1">
					<img id="{$idimgclinical}" src="icons/clinical.png" title="{$ayudaclinica}" />
					<img id="{$idimgtechnical}" src="icons/tecnical.png" onclick="viewdialog('{$jqimgtechnical}','{$jqidtec}','{$idcontenedor}','{$jqid}','{$jqimgclinical}')"/>
				</xsl:if >
				
				<!-- Variables para el titulo del boton de multiples ocurrencias -->
				<xsl:variable name="idatt">
					<xsl:value-of select="./a:node_id"/>
				</xsl:variable>
				<xsl:variable name="auxiliar" >
					<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
				</xsl:variable>
				<!-- Fin variables -->
				
				<xsl:variable name="idbtnINI"  select="concat('idbtnclonador',./a:node_id)"></xsl:variable>
				<xsl:variable name="idbtn"  select="concat($idbtnINI,$i)"></xsl:variable>
				<xsl:variable name="jidbtn"  select="concat('#',$idbtn)"></xsl:variable>
				
				<xsl:variable name="idseparadorINI"  select="concat('dvseparadorsc',./a:node_id)"></xsl:variable>
				<xsl:variable name="idseparador"  select="concat($idseparadorINI,$i)"></xsl:variable>
				<xsl:if test="$i = $count">
				   <xsl:if test="((a:occurrences/a:upper_included = 'false') or (a:occurrences/a:upper > 1)) ">
					<div style="display: inline;" id="{$idseparador}" class="dvseparadorsc">
						<table class="padreseparador" style="width: 100%;">
							<tr>
								<td width="80%">
									<table width="100%">
										<tr>
											<td class="separador"  align="top"><xsl:text>&#160;</xsl:text> </td>
										</tr>
										<tr>
											<td></td>
										</tr>
									</table>
								</td>
								<td class="separadorbtn">
									<b>Add new <xsl:value-of select="$auxiliar"/></b><input class="btn_add" type="button" id="{$idbtn}" ></input>
									<script>
										$("<xsl:value-of select="$jidbtn"/>").on('click', function(){
											creanuevodiv(("<xsl:value-of select="$jqid"/>"),("<xsl:value-of select="$idseparador"/>"));
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										
										}); 
										$("<xsl:value-of select="$jidbtn"/>").on('mouseenter', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										});
										$("<xsl:value-of select="$jidbtn"/>").on('mouseout', function(){
											$("<xsl:value-of select="$jqid"/>").removeClass("marca");
											$("<xsl:value-of select="$jqid"/>").addClass("desmarca");
										}); 
										
									</script>
								</td>
							</tr>
						</table>
					</div>
				   </xsl:if>
			          </xsl:if>
			</div>
			
		</xsl:if>
		
		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="CUERPOIVLPQ">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
				<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<!-- Definicion template IVLPQ -->
	<xsl:template match="*[a:rm_type_name='IVLPQ']">
		
		<xsl:param name="alternativa" />
		<xsl:param name="idcontenedor"/>
		
		<xsl:variable name="min">
			<xsl:choose>
				<xsl:when test="a:occurrences/a:lower > 1">
					<xsl:value-of select="a:occurrences/a:lower"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="max" select="a:occurrences/a:upper"></xsl:variable>
		
		<xsl:call-template name="CUERPOIVLPQ">
			<xsl:with-param name="i">1</xsl:with-param>
			<xsl:with-param name="count"><xsl:value-of select="$min"/></xsl:with-param>
			<xsl:with-param name="alternativa"><xsl:value-of select="$alternativa"/></xsl:with-param>
			<xsl:with-param name="idcontenedor"><xsl:value-of select="$idcontenedor"/></xsl:with-param>
		</xsl:call-template>	
				
	</xsl:template>
	
	<!-- **********************************  FIN TRATAMIENTO CASO : URI  *********************************************************** -->
	
	<!-- **********************************  TRATAMIENTO CASO : IVLPQ  *********************************************************************** -->
	
	<!-- Definicion template CR -->
	<xsl:template match="*[a:rm_type_name='CR']">
		<xsl:call-template name="titulobr" />
		
		
		<xsl:for-each select="a:attributes">
			<xsl:call-template name="nombrecampos" />
			<xsl:call-template name="tipocampos" />	
		</xsl:for-each>
		
		<br/><br/>	
	</xsl:template>
	
	
		
	<!-- Templates Auxiliares -->
	<!-- Título con salto de línea -->
	<xsl:template name="titulobr">
		<xsl:variable name="idatt">
			<xsl:value-of select="./a:node_id"/>
		</xsl:variable>
		<br/>
		<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
		<br/>
	</xsl:template>
	
	<!-- Título sin salto de línea -->
	<xsl:template name="titulo">
		<xsl:variable name="idatt">
			<xsl:value-of select="./a:node_id"/>
		</xsl:variable>
		<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id = 'text']"/>
	</xsl:template>
	
	
	
	<!-- Descripcion del item -->
	<xsl:template name="descripcion">
		<xsl:variable name="idatt">
			<xsl:value-of select="./a:node_id"/>
		</xsl:variable>
		<xsl:value-of select="/a:archetype/a:ontology/a:term_definitions/a:items[@code=$idatt]/a:items[@id ='description']"/>
	</xsl:template>
	
	<!-- Nombre del campo -->
	<xsl:template name="nombrecampos">
		<br/><xsl:value-of select="a:rm_attribute_name"/><br/>	
	</xsl:template>
	
	<!-- Template que renderiza el campo en funcion de:
		2.- El objeto primitivo del hijo. children/rm_type_name el cual es primitivo
		1.- El objeto del hijo children es un tipo complejo. Se invoca para su descomposicion
		3.- En caso que el objeto no tenga hijos se renderiza adhoc.
	-->
	<xsl:template name="tipocampos">
		
		<xsl:param name="noprocess" />
		<xsl:variable name="nombrevar">
			<xsl:value-of select="a:rm_attribute_name"/>
		</xsl:variable>
		<xsl:variable name="tipo">
			<xsl:choose>
				<xsl:when test="a:children/a:rm_type_name">
					<xsl:value-of select="a:children/a:rm_type_name"/>		
				</xsl:when>
				<xsl:otherwise>STRING</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="contadortipo">
			<xsl:value-of select="count(a:children[@xsi:type='C_PRIMITIVE_OBJECT']/a:rm_type_name)"/>
		</xsl:variable>
		<xsl:variable name="contadorcomp">
			<xsl:value-of select="count(a:children[@xsi:type='C_COMPLEX_OBJECT']/a:rm_type_name)"/>
		</xsl:variable>
		
		<!-- CASO 1                                                                             -->
		<!-- Existen hijos children de tipo COMPLEX_OBJECT -->
		<xsl:if test="$contadorcomp > 0">
			<xsl:apply-templates select="." />
		</xsl:if>
		
		<!-- CASO 2                                                                            -->
		<!-- Existen hijos children de tipo PRIMITIVE_OBJECT -->
		<xsl:if test="$nombrevar!=$noprocess">
			<!-- <xsl:if test="($contadortipo > 0 and $contadorcomp = 0)"> -->
			<xsl:if test="$contadorcomp = 0">	
			<xsl:choose>		
				<!-- Caso: VALOR TIPO STRING -->
				<xsl:when test="$tipo = 'STRING' ">
					<xsl:variable name="valor" >
						<xsl:choose>
							<xsl:when test="a:children/a:item/a:list">
								<xsl:value-of select="count(a:children/a:item/a:list)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$valor >1">
						<xsl:value-of select="$nombrevar"/> :
						<xsl:for-each select="a:children/a:item/a:list">
								<xsl:value-of select="."/><br/>
							</xsl:for-each>
												
					</xsl:if>
					<xsl:if test="$valor = 1">
						<xsl:value-of select="$nombrevar"/> :<xsl:value-of  select="a:children/a:item/a:list" /><br/>	
					</xsl:if>
					<xsl:if test="$valor = 0">
						<xsl:value-of select="$nombrevar"/> : Sin definir	<br/>
					</xsl:if>
				</xsl:when>
				<!-- Fin caso VALOR TIPO STRING -->
			
				<!-- Caso: VALOR TIPO BOOLEAN -->
				<xsl:when test="$tipo = 'BOOLEAN'">
					<input type="checkbox" /><br/>
				</xsl:when>
				<!-- Fin caso VALOR BOOLEAN -->
			
				<!-- Caso: VALOR TIPO DATE -->
				<xsl:when test="$tipo = 'DV_DATE'">
					<xsl:variable name="valorlist" >
						<xsl:choose>
							<xsl:when test="a:children/a:item/a:list">
								<xsl:value-of select="count(a:children/a:item/a:list)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="valorrange" >
						<xsl:choose>
							<xsl:when test="a:children/a:item/a:range">
								<xsl:value-of select="count(a:children/a:item/a:range)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$valorlist >= 1 and $valorrange = 0" >
						<xsl:if test="$valorlist >= 1">
							<select name="valores" >
								<xsl:for-each select="a:children/a:item/a:list">
									<option><xsl:value-of select="."/></option>
								</xsl:for-each>
							</select>
							<br/><br/>
						</xsl:if>
						<xsl:if test="$valorlist  = 0">
							<select name="valores">
								<option></option>
							</select>
							<br/><br/>
						</xsl:if>
					</xsl:if>
				
					<xsl:if test="$valorlist = 0 and $valorrange >= 1" >
						<xsl:if test="$valorrange >= 1">
							From: <select name="valores" >
								<option><xsl:value-of select="a:children/a:item/a:range/a:lower"/></option>
							</select>
							To: <select name="valores" >
								<option><xsl:value-of select="a:children/a:item/a:range/a:upper"/></option>
							</select>
							<br/><br/>
						</xsl:if>
						<xsl:if test="$valorrange  = 0">
							<select name="valores">
								<option></option>
							</select>
							<br/><br/>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<!-- Fin caso VALOR DATE -->
			
				<!-- Caso: VALOR TIPO INTEGER -->
				<xsl:when test="$tipo = 'INTEGER' or $tipo ='DOUBLE' ">
					<xsl:variable name="valorlist" >
						<xsl:choose>
							<xsl:when test="a:children/a:item/a:list">
								<xsl:value-of select="count(a:children/a:item/a:list)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="valorrange" >
						<xsl:choose>
							<xsl:when test="a:children/a:item/a:range">
								<xsl:value-of select="count(a:children/a:item/a:range)"/>
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
				
					<xsl:if test="$valorlist >= 1 and $valorrange = 0" >
				         		<xsl:if test="$valorlist > 1">
				         		<select>
				         			<xsl:for-each select="a:children/a:item/a:list">
				         				<option value="{.}" ><xsl:value-of select="."/></option>
				         			</xsl:for-each>
				         		</select>
				         		</xsl:if>
				          		<xsl:if test="$valorlist = 1">
							<xsl:for-each select="a:children/a:item/a:list">
					 			<input type="text" value="{.}" />
				           			</xsl:for-each>
				          		</xsl:if>
						<br/><br/>	
					</xsl:if>
				
					<xsl:if test="$valorlist = 0 and $valorrange >= 1" >
						<xsl:if test="$valorrange >= 1">
							Inicio: <input type="text" value="{a:children/a:item/a:range/a:lower}" /> 
							Fin:  <input type="text" value="{a:children/a:item/a:range/a:upper}" />						
							<br/><br/>
						</xsl:if>
						<xsl:if test="$valorrange  = 0">
							<select name="valores">
								<option></option>
							</select>
							<br/><br/>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<!-- Fin caso VALOR INTEGER -->
			</xsl:choose>
			</xsl:if>
		</xsl:if>
		
	</xsl:template>
	
	<!-- Template AD-HOC Data. Imprime un calendario jquery -->
	<xsl:template name="datenode">
		<xsl:param name="id"/>
		
		<xsl:variable name="obligatory">
		<xsl:choose>
			<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
			<xsl:otherwise>norequired</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
			<script>
				<xsl:text>$('</xsl:text><xsl:value-of select="$id"/><xsl:text>').datetimepicker({
					showTimepicker : false
					});</xsl:text>		
			</script><span class="{$obligatory}"></span>	
	</xsl:template>
	
	<!-- Template AD-HOC Data. Imprime un calendario jquery -->
	<xsl:template name="timernode">
		<xsl:param name="id"/>
		
		<xsl:variable name="obligatory">
			<xsl:choose>
				<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
				<xsl:otherwise>norequired</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		

		<script>
			<xsl:text>$('</xsl:text><xsl:value-of select="$id"/><xsl:text>').datetimepicker();</xsl:text>		
		</script><span class="{$obligatory}"></span>	
	</xsl:template>
	
	
	<!-- Template AD-HOC String. Imprime un input text vacio, un input text  con datos o 
	un select en funcion de los datos-->
	<xsl:template name="stringnode">
		<xsl:param name="field" />
		<xsl:param name="size"/>
		
		<xsl:variable name="obligatory">
			<xsl:choose>
				<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
				<xsl:otherwise>norequired</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="valor" >
			<xsl:choose>
				<!-- .// -->
				<xsl:when test=".//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list">
					<xsl:value-of select="count(.//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="patron">
			<xsl:choose>
				<!-- .// -->
				<xsl:when test=".//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:pattern">
					<xsl:value-of select="count(.//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:pattern)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$valor >=1">
			<xsl:if test="$valor > 1">
				<select name="valores">
					<!-- .// -->
					<xsl:for-each select=".//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list">
						<option><xsl:value-of select="."/></option>
					</xsl:for-each>
				</select><span class="{$obligatory}"></span>						
			</xsl:if>
			<xsl:if test="$valor = 1">
				<!-- <input type="text"   value="{.//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list}" size="{$size}" /><span class="{$obligatory}"></span>	-->
				<!-- .// -->
				<font><xsl:value-of select=".//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list" /></font>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$valor =0 and $patron >= 1">
			<!-- .// -->
			<input type="text"   value="{.//a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list}"  size="{$size}" /><span class="{$obligatory}"></span>	
		</xsl:if>
		
		
		<xsl:if test="$valor = 0 and $patron= 0">
			<input type="text" size="{$size}"  /><span class="{$obligatory}" ></span>	
		</xsl:if>
	</xsl:template>
	
	<!-- Template AD-HOC String. Imprime un input text vacio, un input text  con datos o 
		un select en funcion de los datos-->
	<xsl:template name="combonode">
		<xsl:param name="limit"/>
		
		<xsl:variable name="obligatory">
			<xsl:choose>
				<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
				<xsl:otherwise>norequired</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="valor" >
			<xsl:choose>
				<xsl:when test=".//a:children/a:item/a:list">
					<xsl:value-of select="count(.//a:children/a:item/a:list)"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$valor >=1">
			<select name="valores" >
				<xsl:for-each select="a:children/a:item/a:list">
					<option selected="."><xsl:value-of select="."/></option>
				</xsl:for-each>
			</select><span class="{$obligatory}"></span>						
		</xsl:if>
		
		<xsl:if test="$valor = 0">
			<select name="valores" ><option></option></select><span class="{$obligatory}"></span>	
		</xsl:if>
	</xsl:template>
	
	<!--  Template Interger and real  -->
	<xsl:template name="numnode">
		<xsl:param name="field" select="a:attributes/a:rm_attribute_name"/>
			<xsl:variable name="obligatory">
				<xsl:choose>
					<xsl:when test="a:attributes/a:existence/a:lower >= 1">required</xsl:when>
					<xsl:otherwise>norequired</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
			<xsl:variable name="valorlist" >
				<xsl:choose>
					<xsl:when test="a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list">
						<xsl:value-of select="count(a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list)"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="valorrange" >
				<xsl:choose>
					<xsl:when test="a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:range">
						<xsl:value-of select="count(a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:range)"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="$valorlist >= 1 and $valorrange = 0" >
				<xsl:if test="$valorlist > 1">
					<select >
						<xsl:for-each select="a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list">
							<option value="{.}" ><xsl:value-of select="."/></option>
						</xsl:for-each>
					</select><span class="{$obligatory}"></span>
				</xsl:if>
				<xsl:if test="$valorlist = 1">
					<xsl:for-each select="a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:list">
						<input type="text" value="{.}"  /><span class="{$obligatory}"></span>
					</xsl:for-each>
				</xsl:if>
				<br/><br/>	
			</xsl:if>
			
			<xsl:if test="$valorlist = 0 and $valorrange >= 1" >
				<xsl:if test="$valorrange >= 1">
					<input type="text" title="Value Min: {a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:range/a:lower} Value Max: {a:attributes[a:rm_attribute_name = $field]/a:children/a:item/a:range/a:upper} "/>
					<!-- <br/>
					Begin: <input type="text"  title=" Min: {a:attributes/a:children/a:item/a:range/a:lower}" /><span class="{$obligatory}"></span> 
					End:  <input type="text"   title="Max: {a:attributes/a:children/a:item/a:range/a:upper}" /><span class="{$obligatory}"></span>						
					<br/> -->
				</xsl:if>
				<xsl:if test="$valorrange  = 0">
					<select name="valores">
						<option></option>
					</select><span class="{$obligatory}"></span>
					<br/><br/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$valorlist = 0 and $valorrange = 0" >
				<input type="text" /><span class="{$obligatory}"></span>
			</xsl:if>
		
		<!-- Fin caso VALOR INTEGER -->
	</xsl:template>
	
	
	<!-- Definicion template showinfoclass -->
	<xsl:template name="showinfoclass">
		<li><a><xsl:text>Class: </xsl:text> <xsl:value-of select="a:rm_type_name"/></a></li>
		<li><a><xsl:text>Id: </xsl:text><xsl:value-of select="a:node_id"/></a></li>
		
		<li><a><xsl:text>Ocurrences </xsl:text></a><ul>
			<li><a>
			<xsl:if test="a:occurrences/a:lower_included = 'true' and a:occurrences/a:upper_included = 'true' ">
				<xsl:text>[ </xsl:text><xsl:value-of select="a:occurrences/a:lower"/><xsl:text> .. </xsl:text><xsl:value-of select="a:occurrences/a:upper"/><xsl:text>]</xsl:text>	 	   
			</xsl:if>
			<xsl:if test="a:occurrences/a:lower_included = 'true' and a:occurrences/a:upper_included = 'false' ">
				<xsl:text>[ </xsl:text><xsl:value-of select="a:occurrences/a:lower"/><xsl:text> ... Unbounded ]</xsl:text>	   
			</xsl:if>
			<xsl:if test="a:occurrences/a:lower_included = 'false' and a:occurrences/a:upper_included = 'true' ">
				<xsl:text>[ Unbounded</xsl:text><xsl:text> ... </xsl:text><xsl:value-of select="a:occurrences/a:upper"/><xsl:text>]</xsl:text>		   
			</xsl:if>
			<xsl:if test="a:occurrences/a:lower_included = 'false' and a:occurrences/a:upper_included = 'false' ">
				<xsl:text>[ Unbounded</xsl:text><xsl:text> ... Unbounded ]</xsl:text>			   
			</xsl:if>
			</a></li>
		
		</ul></li>
	</xsl:template>
	
	<!-- Definicion template showattributesclasscontainers -->
	<xsl:template name="showattributesclasscontainers">
		<xsl:variable name="item">
			<xsl:value-of select="a:rm_type_name"/>
		</xsl:variable>
		<xsl:variable name="helplong">
			<xsl:value-of select="$help/RMDocumentation/class[@name = $item]/language[@id = 'en']/longhelp"/>
		</xsl:variable>
		<!--Analizamos sus atributos -->
		<xsl:if test="count(a:attributes) > 0">
			<li><a><xsl:text>Attributes</xsl:text></a><ul>
			<xsl:for-each select="a:attributes">
				<li><a><xsl:text>Name: </xsl:text><xsl:value-of select="a:rm_attribute_name"/></a><ul>
				<li><a><xsl:text>Existence</xsl:text></a><ul>
				<!-- <xsl:for-each select="a:existence/* ">
					<li><a><xsl:text>existence.</xsl:text><xsl:value-of select="name()"/> = <xsl:value-of select="."/></a></li>	
					</xsl:for-each> -->
					<li><a>
						<xsl:if test="a:existence/a:lower = '0' and a:existence/a:upper = '0' ">
							<xsl:text> Not allowed</xsl:text>	 	   
						</xsl:if>
						<xsl:if test="a:existence/a:lower = '0' and a:existence/a:upper = '1' ">
							<xsl:text> Optional </xsl:text>	   
						</xsl:if>
						<xsl:if test="a:existence/a:lower = '1' and a:existence/a:upper = '1' ">
							<xsl:text>Mandatory</xsl:text>	 		   
						</xsl:if>
						
					</a></li>
				</ul></li></ul></li>
			</xsl:for-each>
			</ul></li>
		</xsl:if>
		<li><a><xsl:text>Description</xsl:text></a><ul>
			<li><a style="white-space: pre; word-wrap: break-word;"><xsl:value-of select="$helplong"/> </a></li>
		</ul></li>
	</xsl:template>
	
	<!-- Definicion template spinner -->
	<xsl:template name="spinner">
		<xsl:param name="id" />
		<script>$("<xsl:value-of select="$id"/>").spinner();</script>
	</xsl:template>
	
	<!-- Definicion template optionord -->
	<xsl:template name="optionord">

		<option><xsl:value-of select="a:attributes[a:rm_attribute_name = 'value']/a:children/a:item/a:list"/><xsl:text>   </xsl:text><xsl:value-of select="a:attributes[a:rm_attribute_name = 'symbol']/a:children/a:attributes/a:children/a:item/a:list"/></option>
	</xsl:template>
	
	<!-- Definicion matcheo comodín -->
	<xsl:template match="@*|text()"/>
		
</xsl:stylesheet>
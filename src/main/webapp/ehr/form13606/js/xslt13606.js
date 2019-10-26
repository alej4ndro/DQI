var hover=true;
var global=1;
var z=1;
var replica;
var iddivreplica;
var iddivdivisorareplica;



function replica() {

	padre = $("#composicion");
	

	if ($(padre).attr("id")) {
	
		replica = $("#composicion").clone(false)
			.attr({"id": "CLON"})
			.insertAfter("#composicion");
			
		//Lo ocultamos
		$(replica).css("display","none");
	
		//Renombramos los id originales
		$('div,img,input',$(replica)).each(function(){
					this.id	= "0" + this.id;	
		});
	
	
		
		}
	else {
			replica = $("#estructura").clone(false)
			.attr({"id": "CLON"})
			.insertAfter("#estructura");
	
			//Lo ocultamos
			$(replica).css("display","none");
	
			//Renombramos los id originales
			$('div,img,input',$(replica)).each(function(){
					this.id	= "0" + this.id;	
			});
			
			
	}
	
	
}


function crea_ocurrencias() {
	padre = $("#composicion");
	//alert($(padre).attr("id"));
	//alert("dentro de crea_ocurrencias");
	if ($(padre).attr("id")) {

	}
	else {
		
		
		//Buscamos aquellos div que tengan un minimo definido que no es undefined
		$('div',"#estructura").each(function() {
			
			
			if ($(this).attr('min')) {
				
					idseparators = new Array();
					valor = $(this).attr('min');
			
					//Si tiene minimo y este es mayor que uno.
					if ($(this).attr('min') > 1) {
							
							//Para cada minimo se crea un clon
							for (var i=1;i<valor;i++) {
								//Si es la primera iteracion el id es el obtenido por el each.
								if (i==1) { iddivreplica=$(this).attr("id"); }
								j=0;
							
								//Obtenemos el div separador
								//Condiciones, es un hijo directo que empieza por dvseparator
								//$('div',"#" + iddivreplica).each(function() {
									//alert("ANALIZANDO DIV: " + this.id);
								//	if (this.id.substring(0,13) == 'dvseparadorsc') {
										//	alert("Insertando id :" + this.id + "en posicion " + j);
								//		idseparators[j] = this.id;
								//		j=j+1;
								//	}
								//});
								
								//alert("Parametros:" + iddivreplica + " y " + idseparators[j-1]); 
							    iddivreplica = creanuevodiv("#" + iddivreplica,j);
								
									
								
								
								//alert("NUEVO ID CLONADO" + iddivreplica);
								//idseparators = [];
							
							}
	
					}
			}
		});
	}
}


function viewdialog(idimagentec,idtecnical,reference,idclinical,idimagenclinical) {
		var btntechnical = $(idimagentec);
		var msgtechnical = $(idtecnical);
		var jvreference = $(reference);
		var jvidclinical = $(idclinical);
		var jvidimagenclinical = $(idimagenclinical);
		var jvidimagentec = $(idimagentec);
		
		<!-- Mostramos el dialog de la informacion clinica -->
		
		msgtechnical.css("visibility","visible");
		msgtechnical.dialog({
			autoOpen: false,
			title: "Info Technical",
			modal: false,
			width: 400,
			minHeight: 250,
			position: { my: "right bottom" - 20, at: "right bottom", of: reference },
			open: function(event,ui) { 
				hover=false;
				
				if (idclinical == "") {
					
					markcontaineronclick(reference,idimagenclinical,idimagentec,'no'); 
				} else {
					
					markcontaineronclick(idclinical,idimagenclinical,idimagentec,'no'); 
				}
				
			},
			beforeClose: function(event,ui) { 
				hover=true;
				jvidimagenclinical.css("visibility","hidden");
				jvidimagentec.css("visibility","hidden");
				
				if (idclinical == "") {
					unmarkcontaineronclick(reference,idimagenclinical,idimagentec,'no'); 
				} else {
					unmarkcontaineronclick(idclinical,idimagenclinical,idimagentec,'no'); 
				}
				
				
				}
		});
		msgtechnical.dialog("open");
		
		
	}
	
	function markcontainer(container,img1,img2,iscontainer) {
		var jvcontainer = $(container);
		var jvimg1 = $(img1);
		var jvimg2 = $(img2);
		
			$(container).mouseover(function(event) {
			 if (hover) {
					$(img1).css("visibility","visible");
					$(img2).css("visibility","visible");
					event.stopPropagation();
				}
			});
	}
	
	function unmarkcontainer(container,img1,img2) {
	
		var jvcontainer = $(container);
		var jvimg1 = $(img1);
		var jvimg2 = $(img2);
	
		$(container).mouseout(function(event) {
				
				if(hover) {
						$(img1).css("visibility","hidden");
						$(img2).css("visibility","hidden");
					}
				
			});
	}
	
	function markcontaineronclick(container,img1,img2,iscontainer) {
		var jvcontainer = $(container);
		
		$(container).removeClass("desmarca");
		$(container).addClass("marca");
		
		//jvcontainer.css('border','dotted');
		//jvcontainer.css('border-width','1px');
		//jvcontainer.css('border-color','#000000');
	}
	
	function unmarkcontaineronclick(container,img1,img2){
		var jvcontainer = $(container);
		
		$(container).removeClass("marca");
		$(container).addClass("desmarca");
		
		//jvcontainer.css("border","none");
		//$(container).css({'border-color':'white','border':'dotted','border-width':'1px'});
		//jvcontainer.css();
		//jvcontainer.css("border-width","1px");
		
	
	}
	
	function showhide(idcontainer, idimg) {
		
		//alert("Estoy en showhide: ID Div" + idcontainer + " ID Imagen: " + idimg);
		
		obj = document.getElementById(idcontainer);
		objimg = document.getElementById(idimg);
		
		
		
		
		if (obj.style.display == 'none') {
			obj.style.display = 'block';
			objimg.src="icons/down.png";
			
		} else {
			obj.style.display = 'none';
			objimg.src="icons/up.png";
		}
	}
	
	function creanuevodiv(superpadre,divseparador) {
		
		inside= 1;
		var insidesubcontainer= 0;
		
		var idsimgs = new Array();
		var indexarray = 0;
		var idcollasable;
		
		//Obtenemos el div original de la zona oculta
		idoriginal = $(superpadre).attr("idclon");
		//alert("Vamos a clonar: " + superpadre);
		//alert("Utilizamos el CLON:" + idoriginal);
		//alert("Vamos a eliminar la barra:" + divseparador);
		
		
		//Control clicks create new divs
		global = global + 1;
		
		//New ID composition
		var newid = superpadre + "R" + global;
		newid =  newid.replace("#","");
	
		
		//alert("Nuevo ID del CLON: " + newid);
		
		//Eliminamos la barra que ha producido el evento de clonado
		$("#" + divseparador).remove();
		
		//Create clone with other ID
		nuevoobjeto = $("#0" + idoriginal).clone(false)
			.attr({"id": newid})
			.insertAfter(superpadre);
		
		//alert($(nuevoobjeto).prev().prop('tagName'));
		
		//Now, we can manage the new div
		//We go to analize ecah element of div. 
		//Steps:
		// 1- change id's
		
		$('div,img,input',$(nuevoobjeto)).each(function(){
			
					var namecontainer;
					
					nameid = this.id.substring(0,13);
					var nameidcompleto = this.id;
					var namesubcontainer;
				
					z = z + 1 + Math.round(Math.random()*100);
				
					//Manage images
					if (nameid == '0collasableat') {
							//Change id
							idcollasable = 'collapsableatR0' + z; 
							this.id = 'collapsableatR0' + z;
							//alert("Cambiamos el ID a:" + this.id);

					}
			
					if (nameid == '0imgclinicala') {
							$(this).remove();
					}		
			
					if (nameid == '0imgtechnical') {
							$(this).remove();
					}
		
					//Manages DIV's
					if (nameid == '0subcontainer') {
					 
					//Manage div subcontainerat. 
					//Steps:
					//1- Change id div
						namesubcontainer = 'subcontaineratR0' + z + inside;
						this.id = 'subcontaineratR0' + z + inside;
						//alert("Cambiamos el ID a:" + this.id);
					
						tiposubcontainer = $(this).attr("type");
						
							if ((tiposubcontainer == 'ENTRY') || (tiposubcontainer == 'SECTION')) {
						
								$(document).off('click',"#" + idcollasable);
								$(document).on('click',"#" + idcollasable, function(){
											showhide(namesubcontainer,idcollasable);				
								});
							}	
					}
				
					if (nameid == '0containerat0') {	
						this.id = 'containerat0R' + z;
						//alert("Cambiamos el ID a:" + this.id);
					}
				
					if (nameid == '0sttechnicala') {
						this.id = 'sttechnicalatR' + z;
						//alert("Cambiamos el ID a:" + this.id);
					}

					if (nameid == '0stclinicalat') {
						this.id = 'stclinicalatR' + z;
						//alert("Cambiamos el ID a:" + this.id);
					}

					if (nameid == '0idbtnclonado') {
					   
						this.id = 'idbtnclonadorR' + z;
						botonid = this.id;
						
						//alert("Cambiamos el ID a:" + this.id);
						
						lon = $(this).parents().get().length;
						var padrediv;
						var divsseparators = new Array();
						var j=0;
							
							
						for (i=0;i<lon;i++) {
							if (($(this).parents().get(i).tagName) == 'DIV') {
								id = $(this).parents().get(i).id;
								//alert("ID: " +  id + "Encontrado: " + encontrado);
								if ((id.substring(0,13) == 'dvseparadorsc')) {
										separador=id;
										divsseparators[j]=id;
										j++;
									//	alert("DIV separador a eliminar en el futuro al pulsa sobre el boton:" + separador);
									
									
								}
								
								if (id.substring(0,13) != 'dvseparadorsc') {
									padrediv = id;
									//alert("Padre encontrado!! " +  id + "para el hijo: " + this.id);
									break;
								}
							}
						}
							
						
						$(document).off('click',"#" + botonid);
						$(document).off('mouseover',"#" + botonid);
						$(document).off('mouseout',"#" + botonid);
											
						$(document).on('click',"#" + botonid, function(){
									$("#" + padrediv).removeClass("marca");
									$("#" + padrediv).addClass("desmarca");
									creanuevodiv("#" + padrediv,divsseparators[0]);	
									
									
						});
							
						$("#" + botonid).mouseover(function() {
							$("#" + padrediv).removeClass("desmarca");
							$("#" + padrediv).addClass("marca");
						
						});
						
						$("#" + botonid).mouseout(function() {
							$("#" + padrediv).removeClass("marca");
							$("#" + padrediv).addClass("desmarca");
						
						});
						
					}

					if (nameid == '0dvseparadors') {
						this.id = 'dvseparadorscR' + z;
						
					
					}
					
		});
		
		
		//Guardamos en global este id
		return newid;
		
			
	}
		
		

		
		
		
	
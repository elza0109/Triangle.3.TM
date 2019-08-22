$( document ).ready(function() {
var breadhtml = "";
if (localStorage.getItem('bread')){
	breadhtml = localStorage.getItem('bread');
	$("#breadcrumbs").html(breadhtml);
}

var baseOrigin = window.location.origin;
var baseUrlmenu = "";
var baseUrl_en_id = _spPageContextInfo.webAbsoluteUrl;
var posen = baseUrl.search("/en");
var posId = baseUrl.search("/id");
var poslayouts = baseUrl.search("_layouts");

if(posen != -1 || posId != -1){
	baseUrlmenu = baseUrl_en_id;
}
else{
	baseUrlmenu = baseOrigin + "/en";
}

var manageLists =false;
	function MyFunction() { 
		var call = jQuery.ajax({
        url: baseUrlmenu +
            "/_api/Web/effectiveBasePermissions",
        type: "GET",
        dataType: "json",
        headers: {
            Accept: "application/json;odata=verbose"
        }
    });

    call.done(function (data, textStatus, jqXHR) {
        var manageListsPerms = new SP.BasePermissions();
        manageListsPerms.initPropertiesFromJson(data.d.EffectiveBasePermissions);

        manageLists = manageListsPerms.has(SP.PermissionKind.manageLists);

        var baseUrl2 = baseUrlmenu;
	$.ajax({
	        url: baseUrlmenu +"/_api/Web/CurrentUser?$expand=groups&$select=groups/Title,Id",
	        dataType: "json",
	        method: "GET",
	        headers: {Accept: "application/json;odata=verbose"},
	        async: false,
	        success: function(b) {
	        	//console.log('b', b);         
	        },error: function(error){console.log(JSON.stringify(error))}
	    })	
	
	
	var menuItem = new function (){
		var a =[];
	    return $.ajax({
	        url: baseUrlmenu +"/_api/web/lists/getbytitle('Menus')/items?$select=Level,Parent_x0020_Menus,Title,Icon,Position,URL,order0&$filter=OData__ModerationStatus eq '0'&$orderby=Level,order0",
	        dataType: "json",
	        method: "GET",
	        headers: {Accept: "application/json;odata=verbose"},
	        async: false,
	        success: function(b) {
	        	$.each(b.d.results, function(idx, val) {						                
	                a.push({
	                    x: idx,
	                    t: val.Title,
	                    l: val.Level,
	                    p: val.Parent_x0020_Menus,
	                    u: val.URL,
	                    i: val.Icon,
	                    o: val.Position
	                });
	            })         
	        },error: function(error){console.log(JSON.stringify(error))}
	    }),a;
	};	
	
	var htmlTop = "";
	var htmlChild = "";
	var htmlLeft = "";
	var htmlFooter = "";
	var htmlFooterChild = "";
	menuItem.forEach(function(element) {
		 if(element.o == 0 && element.l == 0){ // top level 0
	 		var id = (element.t).split(' ').join('');
	 		htmlTop = '<li class="dropdown">'+
	 					'<a data-toggle="dropdown" class="dropdown-toggle" href="#"> '+element.t+' <b class="caret"></b></a>'+ 
		 				'<ul id="'+id+'" class="dropdown-menu">'+
		 				'</ul>'+
				     '</li>';
				    
				    $("#menu").append(htmlTop);
				return;
			}
			
		if(element.o == 1 && element.l == 0){ //footer
		 	var id = (element.t).split(' ').join('');
		 	id = id.replace("&", "");
		 	htmlFooter = '<div class="col-xl-4 col-lg-4 col-md-4 col-sm-4">'+
	    					'<br/><ul class="list-unstyled"><li class="dropdown">'+
			 					'<a data-toggle="dropdown" class="dropdown-toggle" href="#"> '+element.t+' <b class="caret"></b></a>'+ 
			 					'<div class="dropup">'+
				 				'<ul id="'+id+'" class="list-unstyled dropdown-menu">'+
				 				'</ul>'+
				 				'</div>'+
						     '</li></ul>'
						 '</div>'
			$('#footer-menu').append(htmlFooter);
		 	return;
		 }
			
		 if(element.o == 0 && element.l == 1){ //top level 1
		 	var id = (element.p).split(' ').join('');
		 	var url = element.u.search("Apps");
		 	if(url != -1 ){
		 		htmlChild = '<li><a href="'+baseOrigin+element.u+'" onclick="breadcrumb(`'+ element.p +'`, `'+ element.t +'`)">'+ element.t +'</a></li>'
			}
			else{
				htmlChild = '<li><a href="'+baseUrl2+element.u+'" onclick="breadcrumb(`'+ element.p +'`, `'+ element.t +'`)">'+ element.t +'</a></li>'
			}
		 	
		 	$('#'+ id +'').append(htmlChild );
		 	return;
		 }
		 
		 if(element.o == 1 && element.l == 1){ //footer level 1
		 	var id = (element.p).split(' ').join('');
		 	id = id.replace("&", "");
		 	var url = element.u.search("http");

		 	if(url != -1 )
		 	{
		 		htmlFooterChild = '<li id="'+element.t+'"><a href="'+element.u+'" target="_blank" onclick="breadcrumb(`'+ element.p +'`, `'+ element.t +'`)">'+ element.t +'</a></li>'		 	}
		 	else
		 	{
		 		htmlFooterChild = '<li id="'+element.t+'"><a href="'+baseUrl2+element.u+'" onclick="breadcrumb(`'+ element.p +'`, `'+ element.t +'`)">'+ element.t +'</a></li>'
		 	}
		 	
		 	
		 	$('#'+ id +'').append(htmlFooterChild);
		 	return;
		 }


		 if(element.o == 2){
				if(element.p != 'CMS'){
			 		var id = (element.t).split(' ').join('');
			 		htmlLeft += '<a href="'+baseUrl2+element.u+'" onclick="breadcrumb(`'+ element.p +'`, `'+ element.t +'`)">'+
								'<div class="row well">'+
									'<div class="col-md-2 no-padding"><img src="'+element.i+'" alt="" class="img-responsive"/></div>'+
									'<div class="col-md-10 child-left-nav">'+element.t+'</div>'+
								'</div>'+
							'</a>';
					return;
				}
			}		
	});	
	
	if (manageLists){
		htmlLeft += '</ul>'+
												  '</div>'+
											  '</nav>';
	}
	
	$("#LeftNAV").append(htmlLeft);
    });
		
	}

	ExecuteOrDelayUntilScriptLoaded(MyFunction,"sp.js");
	
	SP.SOD.executeFunc('sp.js', 'SP.ClientContext', function () { 
	});
	
});

	function breadcrumb(parent, child){
		var html = '<a href="/en">Home</a><span> &gt;&nbsp;'+child+'</span>';
		if(parent != "null") html = '<a href="/en">Home</a><span> &gt;&nbsp;'+parent+' &gt;&nbsp;'+child+'</span>';
		
		localStorage.setItem('bread',html);
	}

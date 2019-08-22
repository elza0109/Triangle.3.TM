// Activates the Carousel
$('.carousel').carousel({
  interval: 5000
})

// Activates Tooltips for Social Links
$('.tooltip-social').tooltip({
  selector: "a[data-toggle=tooltip]"
})



//hide LeftNavCustom for content 
//var baseOrigin = window.location.origin;
var baseOrigin = "http://triangle.three.co.id";

var baseUrl = window.location.href;
var baseUrl_en_id = _spPageContextInfo.webAbsoluteUrl;
var poslayouts = baseUrl.search("_layouts");
var poslists = baseUrl.search("/Lists/");
var posSites = baseUrl.search("/sites/search/");

var posDisplay = baseUrl.search("Display.aspx");
var posNewForm = baseUrl.search("NewForm.aspx");
var posDisplayForm = baseUrl.search("DispForm.aspx");
var posEditForm = baseUrl.search("EditForm.aspx");

var posForms = baseUrl.search("Forms");
var posCalendar = baseUrl.search("Calendar");
var PostBlog = baseUrl.search("/Posts");
var PostVideo = baseUrl.search("Video/videoplayerpage.aspx");
var PostCategory = baseUrl.search("/Category.aspx");
var siteIT =  baseUrl.search("/IT");
var siteMeetingroom =  baseUrl.search("/MeetingRoom");
var siteapps =  baseUrl.search("/Apps");
var poslayoutsAddVideo = baseUrl.search("/_layouts/15/Upload.aspx");
var poslayoutsEditVideo = baseUrl.search("/_layouts/15/EditVideoSet.aspx");

var sitePostBlog =  baseUrl.search("/Lists/Posts/");

var parentDOM = document.getElementById("s4-bodyContainer");
var test = document.getElementsByClassName('ms-dlgFrameContainer');

var posEN = baseUrl.search("/en");
var posID = baseUrl.search("/id");

var getLocUrl = baseUrl.split(baseUrl_en_id)[1];

if(posEN!= -1 || posID != -1)
{
	var myURL = baseUrl_en_id + '/cms';
	document.getElementById('urlConfig').href = myURL;

	if(sitePostBlog != -1)
	{
		document.getElementById("linkEN").href = baseOrigin+'/en/blog';
		document.getElementById("linkID").href = baseOrigin+'/id/blog';
	}
	else
	{
		document.getElementById("linkEN").href = baseOrigin+'/en'+getLocUrl;
		document.getElementById("linkID").href = baseOrigin+'/id'+getLocUrl;
	}
	
	if(poslists != -1)
	{
		document.querySelector("#breadcrumbs").style.display = 'none';
		if(posDisplay != -1)
		{
			$('#s4-ribbonrow').hide();
			var newHeight = $(document).height();
			//if ($.browser.msie) { newHeight = newHeight - 3; }
			$('#s4-workspace').height(newHeight);
			document.getElementById("suiteBar").style.height = "35px";
		}
	}

	$.ajax({
        url: baseOrigin +"/_api/Web/CurrentUser?$expand=groups&$select=groups/Title,Id",
        dataType: "json",
        method: "GET",
        headers: {Accept: "application/json;odata=verbose"},
        async: false,
        success: function(b) {
        	var item= b.d.Groups.results;
        	var lenght = item.length;
        	for(var i=0; i < lenght; i++){
     			if (item[i].Title == "HR Admin")
     			{
     				document.querySelector("#li-line").style.display = 'block';
     				document.querySelector("#li-fa-cog").style.display = 'block';
     				$("ul.ms-cui-tts").show();
     				$("#3knowledgeaddnew").show();
     			}
     			else{
     				$("ul.ms-cui-tts").hide();
     			}
     			      
     		} 
        },error: function(error){//console.log(JSON.stringify(error))
       			}
    })
}
else
{
	document.getElementById("linkEN").href = baseOrigin+'/en';
	document.getElementById("linkID").href = baseOrigin+'/id';
	
	if(siteapps!= -1 ){
		if (posNewForm != -1 || posDisplayForm != -1 || posEditForm != -1){
			$('#s4-ribbonrow').hide();
			var newHeight = $(document).height();
			//if ($.browser.msie) { newHeight = newHeight - 3; }
			$('#s4-workspace').height(newHeight);
			document.getElementById("suiteBar").style.height = "35px";
		}
	}

	
}


	    
if(PostVideo != -1 ){
document.getElementById("idVideoSetDownloadContainer").style.display='none';
}
	

if(poslayouts != -1 || siteIT != -1 || siteMeetingroom != -1|| siteapps != -1 || posSites != -1){
document.querySelector("#LeftNAV").style.display = 'none';
document.querySelector("#MainContentCustom").classList.add("row");
document.querySelector("#MainContentCustom").classList.remove("col-md-10");
document.querySelector("#breadcrumbs").style.display = 'none';
}

if(PostBlog != -1){
document.querySelector("#pageContentTitle").style.display = 'none';
document.querySelector("#DeltaPlaceHolderLeftNavBar").style.display = 'none';
}

if(poslayoutsAddVideo != -1)
{
	console.log(poslayoutsEditVideo);
	document.getElementById("ctl00_PlaceHolderMain_ctl04").style.display='none';
	document.getElementById("ctl00_PlaceHolderMain_ctl04_tablerow1").style.display='none';
	
	document.querySelector("#LeftNAV").style.display = 'block';
	document.querySelector("#MainContentCustom").classList.add("col-md-10");
	document.querySelector("#MainContentCustom").classList.remove("row");
	document.querySelector("#breadcrumbs").style.display = 'none';
}

if (poslayoutsEditVideo != -1)
{

	document.querySelector("#LeftNAV").style.display = 'block';
	document.querySelector("#MainContentCustom").classList.add("col-md-10");
	document.querySelector("#MainContentCustom").classList.remove("row");
	document.querySelector("#breadcrumbs").style.display = 'none';
	
	//Video EN
	$(".ms-standardheader:contains('Content Type')").closest("tr").hide();
	$(".ms-standardheader:contains('VideoType')").closest("tr").hide();
	$(".ms-standardheader:contains('People In Video')").closest("tr").hide();
	$(".ms-standardheader:contains('Show Embed Link')").closest("tr").hide();
	$(".ms-standardheader:contains('Show Download Link')").closest("tr").hide();
	$(".ms-standardheader:contains('Owner')").closest("tr").hide();
	
	//Video ID
	$(".ms-standardheader:contains('Tipe Isi')").closest("tr").hide();
	$(".ms-standardheader:contains('VideoType')").closest("tr").hide();
	$(".ms-standardheader:contains('Pemilik')").closest("tr").hide();
	$(".ms-standardheader:contains('Perlihatkan Tautan Unduhan')").closest("tr").hide();
	$(".ms-standardheader:contains('Perlihatkan Tautan Tersemat')").closest("tr").hide();
	$(".ms-standardheader:contains('Orang di Video')").closest("tr").hide();
}

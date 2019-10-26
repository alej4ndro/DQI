window.onload = function() {
	var links = document.links || document.getElementsByTagName('a.tip');
	var n = links.length;
	for (var i = 0; i < n; i++) {
		if (links[i].title && links[i].title != '') {
			// add the title to anchor innerhtml
			links[i].innerHTML += '<span>'+links[i].title+'</span>'; 
			links[i].title = ''; // remove the title
		}
	}
}

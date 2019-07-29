
var params;
var menu_type;
var sort_type;
var HOME = 0;
var TV = 1;
var MOVIES = 2;
var ABOUT = 3;
var TITLE = 0;
var RELEASE = 1;
var GENRE = 2;
var stars = 0;
var MAX_STARS = 5;

document.onload = initialize();

//initialize default values
function initialize() {
  menu_type = HOME;
  sort_type = -1;
  
  params = []
  if (window.location.href.split('?').length > 1) {
    split = window.location.href.split('?')[1].split('&')
    i = 0
    while(i < split.length) {
      console.log(split[i]);
      var splitparam = split[i].split('=');
      params[splitparam[0]] = decodeURIComponent(decodeURIComponent(splitparam[1].replace('#', '')));
      console.log(splitparam[0] + ' ' + params[splitparam[0]]);
      i++;
	}
  }
}

function menu(val) {
  menu_type = val;
  var options = 4;
  resetSort();
  for(var i = 0; i < options; i++)
	document.getElementById("menu_"+i).className = "";
  document.getElementById("menu_"+menu_type).className = "active";
  
  switch(menu_type) {
    case HOME:
	  redirectRoute("/");
	  break;
	case TV:
	  redirectRoute("/tv/list", {"page": "list"});
	  break;
	case MOVIES:
	  redirectRoute("/movie/list", {"page": "list"});
	  break;
	case ABOUT:
	  redirectRoute("/home/about");
	  break;
	default:
	  break;
  }
}

function redirectRoute(route, params) {
  var subdirs = window.location.href.split("/").length;
  var subStr = "";
  for(var i = 0; i < subdirs; i++)
	subStr += "../";
  subStr = subStr.slice(0, -1);
  
  var parameters = params ? "?" : "";
  if(params) {
  var keys = Object.keys(params);
  for(var i = 0; i < keys.length; i++)
	parameters += keys[i] + '=' + params[keys[i]] + '&';
  parameters = parameters.slice(0, -1);
  }
  
  subStr += route + parameters;
  console.log(subStr);
  window.location.href = subStr;
}

function resetSort() {
  var options = 3;
  for(var i = 0; i < options; i++)
	if(document.getElementById("sort_"+i))
	  document.getElementById("sort_"+i).className = "";
}

function sort(val) {
  menu_type = val;
  resetSort();
  document.getElementById("sort_"+menu_type).className = "active";
  var loc = window.location.href;
  switch(menu_type) {
    case TITLE:
	  if(!loc.includes("?"))
		window.location.href = "home/index?sort=title";
	  else
		window.location.href = loc + "&sort=title";
	  break;
	case RELEASE:
      if(!loc.includes("?"))
		window.location.href = "home/index?sort=date";
	  else
	    window.location.href = loc + "&sort=date";
	  break;
	case GENRE:
      if(!loc.includes("?"))
		window.location.href = "home/index?sort=genre";
      else
	    window.location.href = loc + "&sort=genre";
	  break;
	default:
	  break;
  }
}

function edit_bar(index, value) {
	console.log(index + " " + value);
  var bar = document.getElementById('sb' + index);
  	if(value)
      stars = (stars == value) ? value - 1 : value;
    var solid = document.getElementById('solid_path').value;
    var empty = document.getElementById('empty_path').value;
    var i = 1;
    while (i <= MAX_STARS) {
      document.getElementById(index + 'star' + i).src = (i <= stars) ? solid : empty;
      i++;
	}
  if(index == 0)
    document.getElementById('starfield').value = stars;
  return
}

//ajax autofill searchbar
//tv repliation
//sort home page

params = undefined
API_KEY = 'fdfcdee7aa83cf59356577f37eac94e6'
BASE_API_URL = 'https://api.themoviedb.org/'
BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/'
IMG_WIDTH = 200
LANG = 'en-US'
title = undefined
date = undefined
tmdb_id = undefined
isMovie = undefined

initDetails = ->
  console.log 'details'
  
  params = []
  if window.location.href.split('?').length > 1
    split = window.location.href.split('?')[1].split('&')
    i = 0
    while i < split.length
      console.log split[i]
      splitparam = split[i].split('=')
      params[splitparam[0]] = decodeURIComponent(decodeURIComponent(splitparam[1].replace('#', '')))
      console.log splitparam[0] + ' ' + params[splitparam[0]]
      i++
  
  if params['page'] != 'details'
    return

  title = params['title']
  date = params['date']
  tmdb_id = params['tmdb_id']
  isMovie = params['isMovie'] == 'true'
  console.log tmdb_id + ' ' + title
  getDetails()
  return

getDetails = ->
  if !tmdb_id
    return false
  data = '{}'
  xhttp = new XMLHttpRequest
  xhttp.addEventListener 'readystatechange', ->
    if @readyState == @DONE
      displayDetails JSON.parse(@responseText)
    return
  console.log isMovie
  xhttp.open 'GET', BASE_API_URL + '3/' + (if isMovie then 'movie' else 'tv') + '/' + tmdb_id + '?api_key=' + API_KEY
  xhttp.send data
  return

displayDetails = (json) ->
displayDetails = (json) ->
  `var i`
  console.log json
  genres = json['genres']
  genre_string = ''
  genre_nums = '';
  i = 0
  while i < genres.length
    genre_string += genres[i]['name'] + ', '
    genre_nums += genres[i]['id'] + ','
    i++
  genre_string = genre_string.slice(0, -2)
  genre_nums = genre_nums.slice(0, -1)
  created_by = ''
  if json['created_by']
    i = 0
    while i < json['created_by'].length
      created_by += json['created_by'][i]['name'] + ', '
      i++
    created_by = created_by.slice(0, -2)
  document.getElementById('body_left_div').style = 'display: inline;'
  document.getElementById('body_left_div').innerHTML = '<h1 id="media_title"></h1><br><span id="media_date"></span><br><span id="media_runtime"></span><br><span id="media_genres"></span><br><span id="media_budget"></span><br><span id="media_revenue"></span><br><span id="media_tagline"></span><br><span id="media_overview"></span><br>'
  document.getElementById('body_left_div').innerHTML += '<form action=\'../' + (if isMovie then 'movie' else 'tv') + '_review/review\' method=\'get\'><a onclick=\'parentNode.submit();\' href=\'#\'>Review</a>' + '<input type=\'hidden\' name=\'title\' value=\'' + (if isMovie then json['title'] else json['name']) + '\'></input>' + '<input type=\'hidden\' name=\'date\' value=\'' + date + '\'></input>' + '<input type=\'hidden\' name=\'tmdb_id\' value=\'' + tmdb_id + '\'></input>' + '<input type=\'hidden\' name=\'isMovie\' value=\'' + isMovie + '\'></input>' + '<input type=\'hidden\' name=\'page\' value=\'review\'></input><input type=\'hidden\' name=\'genres\' value=\'' + genre_string + '\'></input></form>'
  document.getElementById('body_right_div').innerHTML = '<img id="media_img" src="" style="float:right;">'
  document.getElementById('media_img').src = BASE_IMAGE_URL + 'w' + IMG_WIDTH + json['poster_path']
  document.getElementById('media_title').innerHTML = if isMovie then json['title'] else json['name']
  document.getElementById('media_date').innerHTML = (if isMovie then 'Release Date: ' else 'First Air Date: ') + json[if isMovie then 'release_date' else 'first_air_date']
  document.getElementById('media_runtime').innerHTML = if isMovie then 'Runtime: ' + json['runtime'] + ' minutes' else json['number_of_seasons'] + ' Seasons, ' + json['number_of_episodes'] + ' Episodes'
  document.getElementById('media_genres').innerHTML = "Genres: " + genre_string
  document.getElementById('media_budget').innerHTML = if isMovie then 'Budget: $' + json['budget'] else 'Created By: ' + created_by
  document.getElementById('media_revenue').innerHTML = if isMovie then 'Revenue: $' + json['revenue'] else 'In Production: ' + json['in_production']
  document.getElementById('media_tagline').innerHTML = if json['tagline'] then json['tagline'] else ''
  document.getElementById('media_overview').innerHTML = json['overview']
  
  return

document.addEventListener 'turbolinks:load', initDetails()
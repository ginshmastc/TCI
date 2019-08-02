params = undefined
allgenres = undefined
sorted_results = undefined
API_KEY = 'fdfcdee7aa83cf59356577f37eac94e6'
BASE_API_URL = 'https://api.themoviedb.org/'
BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/'
IMG_WIDTH = 200
LANG = 'en-US'
media = undefined


init = ->
  console.log 'init Index'
  media = []
  params = []
  allgenres = []
  if window.location.href.split('?').length > 1
    split = window.location.href.split('?')[1].split('&')
    i = 0
    while i < split.length
      splitparam = split[i].split('=')
      params[splitparam[0]] = decodeURIComponent(decodeURIComponent(splitparam[1].replace('#', '')))
      i++
  
  if !params['page']
    console.log 'index ' + params['tmdb_id']
    getMovieGenres()
  return

#Media object
Media = (tmdb_id, title, date, overview, poster_path, isMovie, genres) ->
  @tmdb_id = tmdb_id
  @title = title
  @date = date
  @overview = overview
  @poster_path = poster_path
  @isMovie = isMovie
  @genres = genres
  @details = null
  return
  
getMovieGenres = ->
  data = '{}'
  xhttp = new XMLHttpRequest
  xhttp.addEventListener 'readystatechange', ->
    if @readyState == @DONE
      json = JSON.parse(@responseText)
      json = json["genres"]
      i = 0
      while i < json.length
        allgenres['k'+json[i]['id']] = json[i]['name']
        i++
      getTvGenres()
    return
  xhttp.open 'GET', BASE_API_URL + '3/genre/movie/list?api_key=' + API_KEY
  xhttp.send data
  return  

getTvGenres = ->
  data = '{}'
  xhttp = new XMLHttpRequest
  xhttp.addEventListener 'readystatechange', ->
    if @readyState == @DONE
      json = JSON.parse(@responseText)
      json = json["genres"]
      i = 0
      while i < json.length
        allgenres['k'+json[i]['id']] = json[i]['name']
        i++
      if !params["search"]
        getTrending()
      else
        search()
    return
  xhttp.open 'GET', BASE_API_URL + '3/genre/tv/list?api_key=' + API_KEY
  xhttp.send data
  return  
  
getTrending = ->
  data = '{}'
  xhttp = new XMLHttpRequest
  xhttp.addEventListener 'readystatechange', ->
    if @readyState == @DONE
      json = JSON.parse(@responseText)
      json = json["results"]
      if params['sort'] == 'title' || params['sort'] == 'date' || params['sort'] == 'genre'
        sort(json)
      
      loadMedia json
    return
  xhttp.open 'GET', BASE_API_URL + '3/trending/all/day?api_key=' + API_KEY
  xhttp.send data
  return
  
search = ->
  data = '{}'
  xhttp = new XMLHttpRequest
  xhttp.addEventListener 'readystatechange', ->
    if @readyState == @DONE
      json = JSON.parse(@responseText)
      json = json["results"]
      if params['sort'] == 'title' || params['sort'] == 'date' || params['sort'] == 'genre'
        sort(json)
      
      loadMedia json
    return
  xhttp.open 'GET', BASE_API_URL + '3/search/multi?api_key=' + API_KEY + '&query=' + params['search']
  xhttp.send data
  return

loadMedia = (json) ->
  `var tmdb_id`
  `var title`
  `var isMovie`
  `var date`
  `var genres`
  console.log json
  results = json
  i = 0
  while i < results.length
    genrelist = results[i]['genre_ids']
    genre_nums = ''
    j = 0
    while j < genrelist.length
      genre_nums += genrelist[j] + ','
      j++
    genre_nums = genre_nums.slice(0, -1)
    tmdb_id = results[i]['id']
    title = if results[i]['title'] then results[i]['title'] else results[i]['name']
    isMovie = if results[i]['first_air_date'] == undefined then true else false
    date = if isMovie then results[i]['release_date'] else results[i]['first_air_date']
    overview = results[i]['overview']
    poster = results[i]['poster_path']
    console.log 'creating media ' + tmdb_id + ' ' + title + ' ' + date + ' ' + overview + ' ' + poster + ' isMovie:' + isMovie + ' genres:' + genre_nums
    m = new Media(tmdb_id, title, date, overview, poster, isMovie, genre_nums)
    media[media.length] = m
    i++
  displayMedia()
  return

displayMedia = ->
  document.getElementById('body_left_div').innerHTML = ''
  i = 0
  while i < media.length
    m = media[i]
    j = 0
    glist = m.genres.split(',')
    gstr = ''
    while j < glist.length
      gstr += allgenres['k'+glist[j]] + ', '
      j++
    gstr = gstr.slice(0, -2)
    d = new Date(m.date)
    html = '<div class=\'media\' data-no-turbolink><div class=\'media_left\'><div id=\'media_top_left\'><img src=\'' + BASE_IMAGE_URL + 'w' + IMG_WIDTH + m.poster_path + '\'></div><div id=\'media_bottom_left\'></div></div>'
    html += '<div class=\'media_right\'><div class=\'media_top_right\'><span class=\'media_title\'>' + m.title + '</span><br><span class=\'media_date\'>'
    html += if m.isMovie then 'Release Date: ' else 'First Air Date: '
    html += d.toDateString() + '</span><br><div class=\'media_genres\'>Genre: ' + gstr + '</div></div><div class=\'media_bottom_right\'><br><div class=\'media_overview\'>' + m.overview + '</div>'
    html += '<div style="display: block; width: 100%;"><div style="width: 50%; float:left;"><form action=\'' + (if m.isMovie then "movie" else "tv") + '/details\' method=\'get\'><a onclick= \'parentNode.submit()\' href=\'#\'>Details</a>' + '<input type=\'hidden\' name=\'title\' value=\'' + m.title + '\'></input>' + '<input type=\'hidden\' name=\'date\' value=\'' + m.date + '\'></input>' + '<input type=\'hidden\' name=\'tmdb_id\' value=\'' + m.tmdb_id + '\'></input>' + '<input type=\'hidden\' name=\'isMovie\' value=\'' + m.isMovie + '\'></input>' + '<input type=\'hidden\' name=\'page\' value=\'details\'></input>' + '<input type=\'hidden\' name=\'genres\' value=\'' + m.genres + '\'></input>' + '</form>'
    html += '</div><div class=" width: 50%; float:right;"><form action=\'' + (if m.isMovie then "movie_review" else "tv_review") + '/review\' method=\'get\'><a onclick= \'parentNode.submit()\' href=\'#\'>Review</a>' + '<input type=\'hidden\' name=\'title\' value=\'' + m.title + '\'></input>' + '<input type=\'hidden\' name=\'date\' value=\'' + m.date + '\'></input>' + '<input type=\'hidden\' name=\'tmdb_id\' value=\'' + m.tmdb_id + '\'></input>' + '<input type=\'hidden\' name=\'isMovie\' value=\'' + m.isMovie + '\'></input>' + '<input type=\'hidden\' name=\'page\' value=\'review\'></input>' + '<input type=\'hidden\' name=\'genres\' value=\'' + m.genres + '\'></input></form></div></div></div></div></div>'
    document.getElementById('body_left_div').innerHTML += html
    i++
  return

sort = (arr) ->
  i = 0
  if arr.length <= 1
    return arr
  l1 = Math.ceil(arr.length / 2)
  l2 = arr.length - l1
  arr1 = []
  arr2 = []

  while i < arr.length
    if i < l1
      arr1[i] = arr[i]
    else
      arr2[i - l1] = arr[i]
    i++
  sort arr1
  sort arr2
  i = 0
  j = 0
  k = 0
  while k < arr.length
    if i >= l1
      arr[k] = arr2[j++]
    else if j >= l2
      arr[k] = arr1[i++]
    else
      arr[k] = if compare(arr1[i], arr2[j]) then arr2[j++] else arr1[i++]
    k++
  return

compare = (a, b) ->
  if params['sort'] == 'title'
    aname = if a['title'] then a['title'] else a['name']
    bname = if b['title'] then b['title'] else b['name']
    return aname > bname
  else if params['sort'] == 'date'
    adate = if a['release_date'] then a['release_date'] else a['first_air_date']
    bdate = if b['release_date'] then b['release_date'] else b['first_air_date']
    adateobj = new Date(adate)
    bdateobj = new Date(bdate)
    return adateobj.getTime() > bdateobj.getTime()
  else if params['sort'] == 'genre'
    agenre = allgenres["k"+a['genre_ids'][0]]
    bgenre = allgenres["k"+b['genre_ids'][0]]
    return agenre > bgenre
  true

  
document.addEventListener 'turbolinks:load', init()

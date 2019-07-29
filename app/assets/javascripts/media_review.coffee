
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


initReview = ->
  console.log 'reviews'
  
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
  
  if params['page'] != 'review'
    return
  title = params['title']
  date = params['date']
  tmdb_id = params['tmdb_id']
  isMovie = params['isMovie'] == 'true'
  console.log tmdb_id + ' ' + title
  return


document.addEventListener 'turbolinks:load', initReview()
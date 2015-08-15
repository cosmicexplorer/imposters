setupReplacements = (setup, success, failure, xhrObj) ->
  setup()
  if xhrObj
    xhr = new xhrObj.XMLHttpRequest
  else
    xhr = new XMLHttpRequest
  xhr.onreadystatechange = ->
    if xhr.readyState is 4 and xhr.status is 200
      resp = JSON.parse xhr.response
      success resp
      console.log
        loaded: 'replacements'
        resp: resp
      localStorage.setItem 'imposters-replacements',
        JSON.stringify resp
  xhr.onerror = ->
    console.error "failure"
    resp = JSON.parse localStorage.getItem 'imposters-replacements'
    failure resp
    console.error
      loaded: 'replacements-from-storage'
      resp: resp
  xhr.open 'get',
    'https://raw.githubusercontent.com/cosmicexplorer/imposters/master/' +
      'replacements.json',
    yes
  xhr.send()

module.exports = setupReplacements

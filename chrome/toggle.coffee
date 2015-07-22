act = chrome.browserAction
doReplacement = yes
replacements = null

act.onClicked.addListener (tab) ->
  if replacements?
    doReplacement = not doReplacement
    act.setIcon path: (if doReplacement then 'on.png' else 'off.png')
    console.log "set imposters replacement to #{doReplacement}"

setupReplacements = ->
  act.setIcon path: 'not-loaded.png'
  replacements = null
  xhr = new XMLHttpRequest
  xhr.onreadystatechange = ->
    if xhr.readyState is 4 and xhr.status is 200
      resp = JSON.parse xhr.response
      replacements = resp
      act.setIcon path: 'on.png'
      console.log
        loaded: 'replacements'
        resp: resp
  xhr.open 'get',
    'https://raw.githubusercontent.com/cosmicexplorer/imposters/master/' +
      'replacements.json',
    yes
  xhr.send()

rt = chrome.runtime.onMessage.addListener (req, sender, sendResponse) ->
  switch req
    when 'get-do-replacement' then sendResponse doReplacement
    when 'get-replacement-obj' then sendResponse replacements
    when 'setup-replacements' then setupReplacements()

setupReplacements()

act = chrome.browserAction
doReplacement = yes
replacements = null

act.onClicked.addListener (tab) ->
  if replacements?
    doReplacement = not doReplacement
    act.setIcon path: (if doReplacement then 'res/on.png' else 'res/off.png')
    console.log "set imposters replacement to #{doReplacement}"

setupReplacements = ->
  act.setIcon path: 'res/not-loaded.png'
  replacements = null
  xhr = new XMLHttpRequest
  xhr.onreadystatechange = ->
    if xhr.readyState is 4 and xhr.status is 200
      resp = JSON.parse xhr.response
      replacements = resp
      console.log
        loaded: 'replacements'
        resp: resp
      localStorage.setItem 'imposters-replacements',
        JSON.stringify replacements
      act.setIcon path: 'res/on.png'
  xhr.onerror = ->
    replacements = JSON.parse localStorage.getItem 'imposters-replacements'
    console.error
      loaded: 'replacements-from-storage'
      resp: replacements
    act.setIcon path: 'res/on.png'
  # use file:// for testing since it takes a while to propagate to rawgit
  # considered using rawgit, but it's not automatically pointed at the most
  # recent commit, which kinda defeats the purpose. we can easily host this on a
  # dedicated cdn when this becomes incredibly popular
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

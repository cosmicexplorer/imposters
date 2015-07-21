replaceAllFromJson = (rplc) ->
  console.log rplc

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    replaceObj = JSON.parse sessionStorage.getItem 'imposters-replacements'
    if not replaceObj
      xhr = new XMLHttpRequest
      xhr.onreadystatechange = ->
        if xhr.readyState is 4
          sessionStorage.setItem 'imposters-replacements', xhr.response
          replaceAllFromJson JSON.parse xhr.response
      xhr.open 'get',
        'https://raw.githubusercontent.com/cosmicexplorer/imposters/master/replacements.json',
        yes
      xhr.send()
    else
      replaceAllFromJson replaceObj

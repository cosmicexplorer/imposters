replaceAllFromJson = (rplc) ->
  console.log rplc

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    chrome.runtime.sendMessage 'get-replacement-obj', (replaceObj) ->
      replaceAllFromJson replaceObj if replaceObj?

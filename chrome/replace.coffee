ReplaceAll = require '../common/replace-all'

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    chrome.runtime.sendMessage 'get-replacement-obj', (replaceObj) ->
      replaceAllFn = -> ReplaceAll replaceObj if replaceObj?
      replaceAllFn()
      # for dynamic pages like google instant
      setTimeout replaceAllFn, 500
      setTimeout replaceAllFn, 1000
      setTimeout replaceAllFn, 2000
      setInterval replaceAllFn, 5000 # keep doing every 5 seconds

ReplaceAll = require '../common/replace-all'

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    chrome.runtime.sendMessage 'get-replacement-obj', (replaceObj) ->
      replaceAllFn = -> ReplaceAll replaceObj if replaceObj?
      replaceAllFn()
      setTimeout replaceAllFn, 200 # for dynamic pages like google instant

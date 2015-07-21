ReplaceAll = require './replace-all'

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    chrome.runtime.sendMessage 'get-replacement-obj', (replaceObj) ->
      ReplaceAll.replaceAllFromJson replaceObj if replaceObj?

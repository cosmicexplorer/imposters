Replace = require '../common/replace-all'

chrome.runtime.sendMessage 'get-do-replacement', (doReplacement) ->
  if doReplacement
    chrome.runtime.sendMessage 'get-replacement-obj',
      Replace.WatchNodesAndReplaceText

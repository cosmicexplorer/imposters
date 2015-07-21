sessionStorage.setItem 'imposters-do-replacement', JSON.stringify yes

act = chrome.browserAction

act.onClicked.addListener (tab) ->
  curVal = JSON.parse sessionStorage.getItem 'imposters-do-replacement'
  sessionStorage.setItem 'imposters-do-replacement', JSON.stringify not curVal
  act.setIcon path: (if curVal then 'off.png' else 'on.png')
  console.log "set imposters replacement to #{not curVal}"

rt = chrome.runtime.onMessage.addListener (req, sender, sendResponse) ->
  if req is 'get-do-replacement'
    sendResponse JSON.parse sessionStorage.getItem 'imposters-do-replacement'

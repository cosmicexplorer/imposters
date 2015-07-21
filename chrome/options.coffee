btn = document.getElementById 'updateButton'
btn.onclick = ->
  chrome.runtime.sendMessage 'setup-replacements'

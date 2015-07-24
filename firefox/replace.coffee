ReplaceAll = require '../common/replace-all'

self.port.emit 'get-do-replacement'

self.port.on 'get-do-replacement', (doReplacement) ->
  if doReplacement
    self.port.emit 'get-replacement-obj'
    self.port.on 'get-replacement-obj', (replaceObj) ->
      replaceAllFn = -> ReplaceAll replaceObj if replaceObj?
      replaceAllFn()
      # for dynamic pages like google instant
      setTimeout replaceAllFn, 500
      setTimeout replaceAllFn, 1000
      setTimeout replaceAllFn, 2000
      setInterval replaceAllFn, 5000 # keep doing every 5 seconds

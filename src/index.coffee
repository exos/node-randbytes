
timerandom = require './lib/timerandom'
urandom = require './lib/urandom'

module.exports =
   timeRandom: timerandom
   urandom: urandom
   getRandomBytes: (cant, cb) ->
       randSource = urandom.getInstance()
       randSource.getRandomBytes(cant, cb)
   getHighRandomSource: ->
       return new urandom({
            filePath: '/dev/random'
       })

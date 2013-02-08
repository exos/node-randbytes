
instance = null

class TimeBasedRandomGenerator
    
    @getInstance: ->
        if not instance
            instance = new TimeBasedRandomGenerator()
        
        return instance

    getRandomBytes: (bytes, callback) ->
        
        t = (new Date).getTime()
        random = ''
        
        for i in [1..bytes] by 1
            byte = t * Math.floor((Math.random()*1024)+1) % 255;
            random += String.fromCharCode(byte)
            
        callback (new Buffer(random,'binary'))
        
module.exports = TimeBasedRandomGenerator


fs = require 'fs'

instance = null

class UrandomGenerator
    
    srcfile = null
    buffer = ''
    promises = []
    buffersize = 1024


    @getInstance: ->
        if not instance
            instance = new UrandomGenerator()
        
        return instance

    checkPromises = ->
    
        while promises.length
        
        
            mpromise = promises.shift()
            
            falta = mpromise.bytes - mpromise.buffer.length
            
            
            if falta > buffer.length
                mpromise.buffer += buffer
                promises.push(mpromise)
                buffer = ''
                break
            else
                mpromise.buffer += buffer.substr(0,falta)
                buffer = buffer.substr(falta)
                mpromise.callback(new Buffer(mpromise.buffer,'binary'))
                mpromise = null

        
        if (buffer.length < buffersize)
            srcfile.resume()
        
        
    constructor: (options = {}) ->
    
        buffersize = options.bufferSize ? 1024
        options.filePath = options.filePath ? '/dev/urandom'
        
        srcfile = new fs.createReadStream options.filePath ,{
            encoding: 'binary',
            bufferSize: buffersize
        }
        
        srcfile.on 'data', (data) ->
        
            falta = buffersize - buffer.length
        
            if falta is 0
                
                srcfile.pause()
                return
        
            if data.length > falta
                
                data = data.slice(0,falta)
                
            
            buffer += data.toString('binary')
            checkPromises()
          

    getRandomBytes: (bytes, callback) ->
        
        if buffer.length < bytes
            buf = buffer
            buffer = ''
        
            promises.push({
                buffer: buf,
                bytes: bytes,
                callback: callback
            })
            
        else
            callback(new Buffer(buffer.substr(0,bytes),'binary'))
            buffer = buffer.substr(bytes)
            
        srcfile.resume()
        
        
module.exports = UrandomGenerator

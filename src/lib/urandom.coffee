
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
    
        ##console.log 'checkeo promises'
    
        while promises.length
        
            #console.log 'voy por un promise'
        
            mpromise = promises.shift()
            
            falta = mpromise.bytes - mpromise.buffer.length
            
            #console.log 'faltan ', falta, 'bytes'
            
            if falta > buffer.length
            
                #console.log 'buffer superado, se entrega todo'
            
                mpromise.buffer += buffer
                promises.push(mpromise)
                buffer = ''
                break
            else
            
                #console.log 'le doy buffer'
            
                mpromise.buffer += buffer.substr(0,falta)
                buffer = buffer.substr(falta)

                #console.log 'promise completado, entrego'
                mpromise.callback(new Buffer(mpromise.buffer,'binary'))
                mpromise = null

        #console.log 'termino el checkeo'
        if (buffer.length < buffersize)
            #console.log 'buffer no lleno, mando a leer el archivo'
            srcfile.resume()
        
    constructor: (options = {}) ->
    
        buffersize = options.bufferSize ? 1024
        options.filePath = options.filePath ? '/dev/urandom'
        
        #console.log 'Construyo buffer de', buffersize
        
        srcfile = new fs.createReadStream options.filePath ,{
            encoding: 'binary',
            bufferSize: buffersize
        }
        
        srcfile.on 'data', (data) ->
        
            #console.log 'llega data de urandom'
            
            falta = buffersize - buffer.length
        
            if falta is 0
                #console.log 'no falta nada asi que pauseo'
                srcfile.pause()
                return
        
            if data.length > falta
                #console.log 'recorto la data a', falta
                data = data.slice(0,falta)
                
            #console.log 'completo buffer'
            buffer += data.toString('binary')
            checkPromises()
          
    getRandomBlock: (bytes, callback) ->
        
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
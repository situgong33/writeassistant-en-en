# { BufferedProcess } = require 'atom'
fs = require 'fs'
path = require 'path'
fuzzaldrin = require 'fuzzaldrin'

module.exports =
  selector: atom.config.get('writeassistant-en-en.FileType')
  inclusionPriority: 0
  excludeLowerPriority: false

  wordRegex: /[a-zA-Z][\-a-zA-Z]*$/
  properties: {}
  keys: []
  isWork: false
  
  getSuggestions: ({editor, bufferPosition}) ->
      prefix = @getPrefix(editor, bufferPosition)
      return [] unless prefix?.length >= 2
      return @getWordsSuggestions(prefix)

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''

  loadEnglishDict: ->
      fs.readFile path.resolve(__dirname, '..', 'en-en-dict.json'), (error, content) =>
          return if error
          isWorkValue = "true"
          if isWorkValue.match(@isWork)
            console.log ("close package: writeassistant-en-en")
            @isWork = false
            @properties = JSON.parse("{}")
            @keys = Object.keys(@properties)
            atom.notifications.addSuccess "WriteAssistant-en-en Stoped Success."
          else 
            console.log ("reLoad package: writeassistant-en-en")
            @isWork = true
            @properties = JSON.parse(content)
            @keys = Object.keys(@properties)
            console.log ("load success!")
            atom.notifications.addSuccess "WriteAssistant-en-en Started Sucecss."
          
          
  toggle: ->
    console.log("toggle")
    @loadEnglishDict()

  getWordsSuggestions: (prefix) ->
    words = fuzzaldrin.filter(@keys, prefix)
    for word in words
      {
        text: word
        rightLabel: @properties[word].description
        description: @properties[word].description
        replacementPrefix: prefix
      }

provider = require './provider'

module.exports =
  activate: ->
      provider.loadEnglishDict()
      atom.commands.add 'atom-workspace', 'writeassistant-en-en:toggle': => provider.toggle()
  getProvider: ->
      provider

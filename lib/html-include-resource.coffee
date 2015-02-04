IncludeResourceView = require './html-include-resource-view'
{CompositeDisposable} = require 'atom'
path = require 'path'

module.exports =
  activate: ->
    atom.workspaceView.command "html-include-resource:include", => @include()

  include: ->
    htmlTags = ''
    editor = atom.workspace.activePaneItem
    selection = editor.getSelection()
    treeView = atom.packages.getLoadedPackage('tree-view')
    treeView = require(treeView.mainModulePath).treeView
    selectedEntries = treeView.list[0].querySelectorAll('.selected')

    if selectedEntries && editor.getPath
      entryCounter = 0
      newLine = ''

      for entry in selectedEntries
        relativePath = path.relative(''+editor.getPath,''+entry.getPath())

        entryCounter++
        if entryCounter > 1 then newLine = '\n'

        # includes the proper tag depending on the extension
        switch path.extname(entry.getPath())
          when '.js','.coffee' then htmlTags += newLine+'<script src="'+relativePath+'"></script>'
          when '.css' then htmlTags += newLine+'<link rel="stylesheet" href="'+relativePath+'">'

      selection.insertText(htmlTags)

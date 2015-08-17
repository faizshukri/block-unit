'use strict'

goog.provide('Blockly.Blocks.methods')

goog.require('Blockly.Blocks')

Blockly.Blocks.methods.addMethod = (name, params = "", hasReturn = false, returnType = "") ->

  if(_.isString(params))
    # Remove space, and split text into array by comma
    params = params.replace(' ', '').split(',')

    # Remove empty space from array
    params = $.grep(params, (n) ->
      return(n)
    )

  block_name = 'methods_' + name

  Blockly.Blocks[block_name] =
    init: () ->

      # Add method name to the block
      this.appendDummyInput()
      .appendField(name)

      # For each params, add to the blockly
      params.forEach(((param) ->
        this.appendValueInput(param)
        .setCheck(null)
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField(param)
      ).bind(this))

      # Set input params as inline
      this.setInputsInline(true)

      # Check if method has return
      if hasReturn
        if _.isEmpty(returnType)
          this.setOutput(true)
        else
          this.setOutput(true, returnType)
      else
        this.setPreviousStatement(true);
        this.setNextStatement(true)

      this.setTooltip('')
      this.setHelpUrl('http://www.example.com/')
      this.setColour(290)

  $('#toolbox').find("category[name='Methods']").append('<block type="' + block_name + '"></block>')
  workspace.updateToolbox(document.getElementById('toolbox'));
  scope = angular.element($('#blockly')).scope()
  scope.blockly.createMethod(name)
  scope.$apply()
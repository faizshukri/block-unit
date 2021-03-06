'use strict'

goog.provide('Blockly.Blocks.methods')

goog.require('Blockly.Blocks')

# Create method from interface
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

      # Hold color for this blocks
      Blockly.Blocks.methods.HUE = 290

      # If method not constructor, we need to make sure user put object first
      if name != returnType
        this.appendValueInput("OBJ_VAR")
            .setCheck(null)
            .setAlign(Blockly.ALIGN_RIGHT)
            .appendField("Using obj");

        this.appendDummyInput().appendField(", " + name)

      else
        this.appendDummyInput().appendField(name)

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
      this.setColour(Blockly.Blocks.methods.HUE)

    onchange: () ->

      if name != returnType
        obj_var = this.getInputTargetBlock('OBJ_VAR')

        if _.isEmpty(obj_var)
          this.setWarningText("Error: You need to create object and put its instance here.")
        else
          this.setWarningText(null)

  # Add generator implementation
  Blockly.Java.addGenerator(name, params, hasReturn, returnType)

  $('#toolbox').find("category[name='Methods']").append('<block type="' + block_name + '"></block>')
  workspace.updateToolbox(document.getElementById('toolbox'));
  scope = angular.element($('#blockly')).scope()
  scope.blockly.createMethod(name)

  # Apply only if not in progress
  if(!scope.$$phase)
    scope.$apply()

# Create class from interface
Blockly.Blocks.methods.addClass = (name, params = "") ->

  scope = angular.element($('#blockly')).scope()
  scope.blockly.createClass(name)

  # Apply only if not in progress
  if(!scope.$$phase)
    scope.$apply()

  # Create constructor block
  Blockly.Blocks.methods.addMethod(name, params, true, name)

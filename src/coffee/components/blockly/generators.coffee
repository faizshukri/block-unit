'use strict'

goog.provide('Blockly.Java.methods')

goog.require('Blockly.Java')

Blockly.Java.addGenerator = ( name, params = [], hasReturn = false, returnType = "" ) ->

  method_name = "methods_" + name

  console.log "Add generator for " + method_name

  Blockly.Java[method_name] = (block) ->

    variables = _.map(_.compact(_.pluck(block.inputList, 'name')), (variable) ->
      return Blockly.Java.valueToCode(block, variable, Blockly.Java.ORDER_ATOMIC)
    )

    if variables.length > 0
      variables = " " + variables.join(', ') + " "
    else
      variables = ""

    # Initialize code as empty string
    code = ""

    if returnType==name
      # If constructor block, add new keywork
      code = "new "

    code += name + "(" + variables + ")"

    return [code, Blockly.Java.ORDER_ATOMIC]
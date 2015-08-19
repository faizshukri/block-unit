'use strict'

goog.provide('Blockly.Java.methods')

goog.require('Blockly.Java')

Blockly.Java.addGenerator = ( name, params = [], hasReturn = false, returnType = "" ) ->

  method_name = "methods_" + name

  console.log "Add generator for " + method_name

  Blockly.Java[method_name] = (block) ->

    obj_var = Blockly.Java.valueToCode(block, 'OBJ_VAR', Blockly.Java.ORDER_ATOMIC)

    # Pluck name, remove empty value, and for each input name, we get its vlaue
    variables = _.map(_.compact(_.pluck(block.inputList, 'name')), (variable) ->

      # If the input name is obj var, we skip
      if variable == 'OBJ_VAR'
        return null

      return Blockly.Java.valueToCode(block, variable, Blockly.Java.ORDER_ATOMIC)
    )

    # Again, compact variable to remove if we have null value
    variables = _.compact(variables)

    if variables.length > 0
      variables = " " + variables.join(', ') + " "
    else
      variables = ""

    # Initialize code as empty string
    code = ""

    if returnType==name
      # If constructor block, add new keywork
      code = "new "

    if obj_var
      name = obj_var + "." + name

    code += name + "(" + variables + ")"

    return [code, Blockly.Java.ORDER_ATOMIC]
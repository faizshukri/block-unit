Blockly.Blocks.assert_true =
  init: () ->
    this.appendValueInput "VAR"
      .setCheck null
      .appendField "Assert that"
    this.appendDummyInput()
      .appendField "is TRUE"
    this.setPreviousStatement true
    this.setNextStatement true
    this.setColour 40
    this.setTooltip ''
    this.setHelpUrl 'http://www.example.com/'

Blockly.Blocks.assert_false = 
  init: () ->
    this.appendValueInput "VAR"
        .setCheck null
        .appendField "Assert that"
    this.appendDummyInput() 
        .appendField "is FALSE"
    this.setPreviousStatement true
    this.setNextStatement true
    this.setColour 40
    this.setTooltip ''
    this.setHelpUrl 'http://www.example.com/'

Blockly.Blocks.assert_equals =
  init: () ->
    this.appendValueInput "VAR"
        .setCheck null
        .appendField "Assert that"
    this.appendDummyInput()
        .appendField "is equals"
    this.appendValueInput "VAR2"
        .setCheck null
    this.setPreviousStatement true
    this.setNextStatement true
    this.setColour 40
    this.setTooltip ''
    this.setHelpUrl 'http://www.example.com/'

Blockly.Blocks.assert_null =
  init: () ->
    this.appendValueInput "VAR"
        .setCheck null
        .appendField "Assert that"
    this.appendDummyInput()
        .appendField "is NULL"
    this.setPreviousStatement true
    this.setNextStatement true
    this.setColour 40
    this.setTooltip ''
    this.setHelpUrl 'http://www.example.com/'

Blockly.Blocks.assert_notnull =
  init: () ->
    this.appendValueInput "VAR"
        .setCheck null
        .appendField "Assert that"
    this.appendDummyInput()
        .appendField "is NOT NULL"
    this.setPreviousStatement true
    this.setNextStatement true
    this.setColour 40
    this.setTooltip ''
    this.setHelpUrl 'http://www.example.com/'
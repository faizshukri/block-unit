angular.module "app"
  .controller "BlocklyCtrl", [ '$scope', '$cookieStore', 'localStorageService', ($scope, $cookieStore, localStorageService) ->

    this.classes = []

    this.selectedClass = {}
    this.selectedMethod = {}
    this.selectedTest = {}

    this.createClass = (class_name = false) ->
      if(!class_name)
        class_name = prompt "Class names: "

      if _.isEmpty class_name
        return

      # Get id of current selected, and change it to false
      class_index = _.findIndex this.classes, {selected: true}

      if class_index > -1
        this.unselectSelected this.classes, this.classes

      this.selectedClass = { name: class_name, methods: [], tests: [], selected: true }

      # Create new class and mark it as selected
      this.classes.push this.selectedClass

    this.createMethod = (method_name = false) ->
      if(!method_name)
        method_name = prompt "Method name: "

      if _.isEmpty method_name
        return

      # Get index of selected class
      class_index = _.findIndex this.classes, {selected: true}

      if class_index > -1
        # Deselect selected method in the selected class
        this.unselectSelected this.classes, this.classes[class_index].methods, class_index + '.' + 'methods'

      # Set selected method
      this.selectedMethod = { name: method_name, selected: true }
      # Add method to the class
      this.classes[class_index].methods.push this.selectedMethod

    this.createTest = ->
      test_name = prompt "Test method: "
      if _.isEmpty test_name
        return

      # console.log _.isEmpty(this.selectedTest)
      if ! _.isEmpty(this.selectedTest)
        this.saveWorkspace()
        Blockly.mainWorkspace.clear()

      # Get index of selected class
      class_index = _.findIndex this.classes, {selected: true}

      if class_index > -1
        # Deselect selected test in the selected class
        this.unselectSelected this.classes, this.classes[class_index].tests, class_index + '.' + 'tests'

      # Set selected test
      this.selectedTest = { name: test_name, selected: true }
      # Add test to the class
      this.classes[class_index].tests.push this.selectedTest

    this.step = 0

    this.unselectSelected = (target, search = [], base = '', callback = null) ->
      current_selected = _.findIndex(search, {selected: true})
      console.log('3 ', 'unselectSelected: ', this.selectedTest, target, base, current_selected)
      this.step++
      if current_selected > -1
        base = base + '.' + current_selected
        _.set(target, base + '.selected', false)
        console.log('4 ', 'last ', this.selectedTest)

      if callback
        callback()
      this.updatingTest = true
      return

    this.updateClass = (class_name) ->
      this.unselectSelected this.classes, this.classes
      class_index = _.findIndex( this.classes, {name: class_name.name} )
      _.set(this.classes, class_index + '.selected', true)


    this.updateTest = (test_name) ->

      # if this.updatingTest
      #   console.log('updating test')
      #   this.updatingTest = false
      #   return

      console.log('1 ', this.selectedTest)
      class_index = _.findIndex( this.classes, {selected: true} )
      test_index = _.findIndex( this.classes[ class_index ].tests, {name: test_name.name})
      console.log('2 ', 'updateTest: ', this.selectedTest, class_index, test_index)
      this.step++
      this.unselectSelected this.classes, this.classes[class_index].tests, class_index + '.' + 'tests'
      console.log('5 ', this.selectedTest)
      # _.set(this.classes, class_index+'.tests.'+test_index+'.selected', true)
      # this.classes[class_index].tests[test_index].selected = true
      console.log('6 ', this.selectedTest)
      # this.updatingTest = false
      return
      # this.selectedTest.selected = true

    this.getClassIndex = ->
      _.findIndex this.classes, this.selectedClass

    this.getMethodIndex = ->
      _.findIndex this.classes[this.getClassIndex()].methods, this.selectedMethod

    this.populateClass = (obj) ->
      this.createClass obj.class_name

      _.each obj.methods, (method_name) ->
        this.createMethod method_name
      , this

      console.log obj


    this.saveWorkspace = (name = null) ->
      if _.isNull name
        name = this.selectedTest.name
      # Build cookie name
      data_item = _.snakeCase(this.selectedClass.name) + '_' + _.snakeCase(name)
      
      # Get blockly representative in xml string
      xml = Blockly.Xml.workspaceToDom Blockly.mainWorkspace
      xmlString = Blockly.Xml.domToText xml 

      # Store the string into cookie
      # $cookieStore.put(data_item, xmlString);
      localStorageService.set(data_item, xmlString)

    this.loadWorkspace = ->
      # Build cookie name
      data_item = _.snakeCase(this.selectedClass.name) + '_' + _.snakeCase(this.selectedTest.name)

      # Retrieve the xml string from cookie
      # xmlString = $cookieStore.get data_item
      xmlString = localStorageService.get data_item;

      # Restore the block structure to the blockly workspace
      xml = Blockly.Xml.textToDom xmlString;
      Blockly.Xml.domToWorkspace( Blockly.mainWorkspace, xml )

    # Watch selectedClass value. If has any changes, reset selectedMethod and selectedTest
    $scope.$watch(angular.bind this, () -> this.selectedClass
    (newVal, oldVal) ->
      console.log('class change')
      this.selectedMethod = { }
      this.selectedTest = { }
    )

    this.updatingTest = false

    $scope.$watch(angular.bind this, () -> this.selectedTest
    angular.bind this, (newVal, oldVal) ->

      if _.isEmpty(newVal) or _.isEqual(newVal, oldVal)
        return
      if this.updatingTest
        this.updatingTest = false
        console.log('stop here, ', this.updatingTest)
        return

      console.log('testChanged: ', newVal, oldVal)
      # console.log('changed')
      console.log('1 ', this.selectedTest)
      class_index = _.findIndex( this.classes, {selected: true} )
      test_index_selected = _.findIndex( this.classes[ class_index ].tests, {selected: true})
      test_index = _.findIndex( this.classes[ class_index ].tests, newVal)
      console.log('2 ', 'updateTest: ', this.selectedTest, class_index, test_index, test_index_selected)

      this.saveWorkspace(oldVal.name)
      Blockly.mainWorkspace.clear()

      this.classes[class_index].tests[test_index_selected].selected = false
      this.classes[class_index].tests[test_index].selected = true
      this.selectedTest = this.classes[class_index].tests[test_index]

      Blockly.mainWorkspace.clear()
      this.loadWorkspace()

      console.log('6 ', this.selectedTest)
      this.updatingTest = true
      # return
    )

    this.blocks =
      Assert: [
        "assert_true",
        "assert_false",
        "assert_equals",
        "assert_null",
        "assert_notnull"
      ],
      Colour: [
        "colour_picker",
        "colour_random",
        "colour_rgb",
        "colour_blend"
      ],
      Control: [
        "controls_repeat",
        "controls_repeat_ext",
        "controls_whileUntil",
        "controls_for",
        "controls_forEach",
        "controls_flow_statements"
      ],
      List: [
        "lists_create_empty",
        "lists_create_with",
        "lists_repeat",
        "lists_length",
        "lists_isEmpty",
        "lists_indexOf",
        "lists_getIndex",
        "lists_setIndex",
        "lists_getSublist",
        "lists_split",
      ],
      Logic: [
        "controls_if",
        "logic_compare",
        "logic_operation",
        "logic_negate",
        "logic_boolean",
        "logic_null",
        "logic_ternary"
      ],
      Math: [
        "math_number",
        "math_arithmetic",
        "math_single",
        "math_constant",
        "math_number_property",
        "math_change",
        "math_round",
        "math_trig",
        "math_on_list",
        "math_modulo",
        "math_constrain",
        "math_random_int",
        "math_random_float"
      ],
      Text: [
        "text",
        "text_join",
        "text_append",
        "text_length",
        "text_isEmpty",
        "text_indexOf",
        "text_charAt",
        "text_getSubstring",
        "text_changeCase",
        "text_trim",
        "text_print",
        "text_prompt",
        "text_prompt_ext",
      ]

    return
  ]

angular.module "app"
  .controller "BlocklyCtrl", [ '$scope', '$cookieStore', 'localStorageService', ($scope, $cookieStore, localStorageService) ->

    # Remove all local storage
    localStorageService.clearAll()

    this.classes = []

    this.selectedClass = {}
    this.selectedMethod = {}
    this.selectedTest = {}

    this.createClass = (class_name = false) ->
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

      # Remove existing data in local storage for this test name
      this.removeFromStorage test_name

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
      this.step++
      if current_selected > -1
        base = base + '.' + current_selected
        _.set(target, base + '.selected', false)

      if callback
        callback()
      this.updatingTest = true
      return

    this.updateClass = (class_name) ->
      this.unselectSelected this.classes, this.classes
      class_index = _.findIndex( this.classes, {name: class_name.name} )
      _.set(this.classes, class_index + '.selected', true)


    this.updateTest = (test_name) ->

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

      if(!$scope.$$phase)
        $scope.$apply()

      _.each obj.methods, (method) ->
        Blockly.Blocks.methods.addMethod(method.name, method.parameters, method.return, method.returnType)
      , this

    ###
    #  Save workspace for current test name
    ###
    this.saveWorkspace = (storage_key = this.selectedTest.name) ->

      if this.selectedClass.tests.length <= 0
        return

      # Build cookie name
      data_item = _.snakeCase(this.selectedClass.name) + '_' + _.snakeCase(storage_key)

      console.log("saveWorkspace: ", data_item)

    # Get blockly representative in xml string
      xml = Blockly.Xml.workspaceToDom Blockly.mainWorkspace
      xmlString = Blockly.Xml.domToText xml

      # Store the string into cookie
      # $cookieStore.put(data_item, xmlString);
      localStorageService.set(data_item, xmlString)

    ###
    #  Load workspace for current selected class and current selected test
    ###
    this.loadWorkspace = (workspace = Blockly.mainWorkspace, storage_key = this.selectedTest.name) ->

      # Build cookie name
      if _.isEmpty(storage_key)
        return

      data_item = _.snakeCase(this.selectedClass.name) + '_' + _.snakeCase(storage_key)

      # Retrieve the xml string from cookie
      # xmlString = $cookieStore.get data_item
      xmlString = localStorageService.get data_item

      if !_.isEmpty xmlString
        console.log("loadWorkspace: ", data_item)
        # Restore the block structure to the blockly workspace
        xml = Blockly.Xml.textToDom xmlString;
        Blockly.Xml.domToWorkspace( workspace, xml )

    ###
    #  Remove item from local storage
    ###
    this.removeFromStorage = (storage_key, class_prefix = this.selectedClass.name) ->
      data_item = _.snakeCase(class_prefix) + '_' + _.snakeCase(storage_key)
      localStorageService.remove data_item

    ###
    #  Save the toolbox for class
    ###
    this.saveToolbox = (class_name) ->
      data_item = 'toolbox_' + _.snakeCase(class_name)
      xmlString = Blockly.Xml.domToText(document.getElementById('toolbox'))
      localStorageService.set(data_item, xmlString)

    ###
    #  Load the toolbox for class
    ###
    this.loadToolbox = (class_name) ->
      data_item = 'toolbox_' + _.snakeCase(class_name)
      xmlString = localStorageService.get(data_item)
      if !_.isEmpty(xmlString)
        $('#toolbox').replaceWith(Blockly.Xml.textToDom(xmlString))
        workspace.updateToolbox document.getElementById("toolbox")

    ###
    #  Reset the toolbox
    ###
    this.resetToolbox = () ->
      $('#toolbox').find("category[name='Methods']").html("")
      workspace.updateToolbox document.getElementById('toolboxOriginal')


    this.generateCode = (selector) ->

      # First, let's save this workspace first before generating any code
      this.saveWorkspace()

      # Start of jUnit class
      code = "// Code generated at " + Date() + " using Blockly\n"+
             "import static org.junit.Assert.*;\n\n" +
             "import org.junit.Test;\n\n" +

             "public class test" + this.selectedClass.name + " {\n\n";

      # Loop through tests
      this.selectedClass.tests.forEach( ((test) ->

        # Clear the workspace before load anything to it
        workspaceHidden.clear()

        # Use workspace hidden to generate code
        this.loadWorkspace(workspaceHidden, test.name)

        # Get the generated code from hidden workspace
        testCode = Blockly.Java.workspaceToCode(workspaceHidden);
        testCode = testCode
                    .replace(/^(.)/gm,"\t\t$1")     # Add tab at every starting text in every line
                    .replace(/(\r\n|\n|\r)+$/, "")  # Remove end empty line

        code += "\t@Test\n" +
                "\tpublic void " + test.name + "() {\n" +
                testCode +
                "\n\t}\n\n"

      ).bind(this))

      # End of jUnit class
      code += "}\n";

      $(selector).text(code)
      hljs.highlightBlock($(selector)[0])

    # Watch selectedClass value. If has any changes, reset selectedMethod and selectedTest
    $scope.$watch(angular.bind this, () -> this.selectedClass
    angular.bind this, (newVal, oldVal) ->
      this.selectedMethod = { }
      this.selectedTest = { }
      # Update workspace toolbox
      if Blockly.mainWorkspace and !_.isEmpty(oldVal.name)

        # Save toolbox
        this.saveToolbox(oldVal.name)
        this.resetToolbox()

        # Load new toolbox
        this.loadToolbox(newVal.name)
    )

    ###
    #  This variable is to prevent test being call in infinite loops
    ###
#    this.updatingTest = false

    $scope.$watch(angular.bind this, () -> this.selectedTest
    angular.bind this, (newVal, oldVal) ->

      if _.isEqual(newVal, oldVal)
        return

      console.log('testChanged: ', newVal, oldVal)
      class_index = _.findIndex( this.classes, {selected: true} )
      test_index_selected = _.findIndex( this.classes[ class_index ].tests, {selected: true})
      test_index = _.findIndex( this.classes[ class_index ].tests, newVal)

      # Save workspace and clear it
      this.saveWorkspace(oldVal.name)
      Blockly.mainWorkspace.clear()

      if this.classes[class_index].tests.length > 0
        this.classes[class_index].tests[test_index_selected].selected = false
        this.classes[class_index].tests[test_index].selected = true
        this.selectedTest = this.classes[class_index].tests[test_index]

      this.loadWorkspace()

    )

    this.customDialogButtons =
      createClass:
        success:
          label: 'Add'
          className: 'btn-success'
          callback: () ->
            class_name = $('#class_name').val()
            class_parameters = $('#class_parameters').val()

            Blockly.Blocks.methods.addClass(class_name, class_parameters)

      createMethod:
        success:
          label: 'Add'
          className: 'btn-success'
          callback: () ->
            method_name = $('#method_name').val()
            method_parameters = $('#method_parameters').val()
            method_return = $('#method_return').prop('checked')

            Blockly.Blocks.methods.addMethod(method_name, method_parameters, method_return)

    this.blocks =
      Assert: [
        "assert_true",
        "assert_false",
        "assert_equals",
        "assert_null",
        "assert_notnull"
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

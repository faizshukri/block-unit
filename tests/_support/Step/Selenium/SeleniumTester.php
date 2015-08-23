<?php
namespace Step\Selenium;

class SeleniumTester extends \SeleniumGuyTester
{

    public function createClass($class_name = 'Person')
    {
        $I = $this;
        $I->click('button.button-new-class');
        $I->waitForElementVisible('input[name="class_name"]', 3);
        $I->fillField(['name' => 'class_name'], $class_name);
        $I->click('Add', '.modal-footer');
        $I->waitForElementNotVisible('.bootbox .modal-body');
    }

    public function createMethod($method_name = 'getAge')
    {
        $I = $this;
        $I->click('button.button-new-method');
        $I->waitForElementVisible('input[name="method_name"]', 3);
        $I->fillField(['name' => 'method_name'], $method_name);
        $I->click('Add', '.modal-footer');
        $I->waitForElementNotVisible('.bootbox .modal-body');
    }

    public function createTest($test_name = 'test1')
    {
        $I = $this;
        $I->click('button.button-new-test');
        $I->typeInPopup($test_name);
        $I->acceptPopup();
    }

}
<?php
namespace Step\Selenium;

class SeleniumTester extends \SeleniumGuyTester
{

    public function createClass()
    {
        $I = $this;
        $I->click('button.button-new-class');
        $I->waitForElementVisible('input[name="class_name"]', 3);
        $I->fillField(['name' => 'class_name'], 'Person');
        $I->click('Add', '.modal-footer');
        $I->waitForElementNotVisible('.bootbox .modal-body');
    }

    public function createMethod()
    {
        $I = $this;
    }

    public function createTest()
    {
        $I = $this;
        $I->click('button.button-new-test');
        $I->typeInPopup('test1');
        $I->acceptPopup();
    }

}
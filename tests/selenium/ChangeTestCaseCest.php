<?php

use Step\Selenium\SeleniumTester;

class ChangeTestCaseCest
{
    public function _before(SeleniumGuyTester $I)
    {
        $I->maximizeWindow();
        $I->amOnPage('/');
    }

    public function _after(SeleniumGuyTester $I)
    {
    }

    // tests
    public function tryChangeTest(SeleniumTester $I)
    {
        $I->wantTo("Change test case and reset workspace.");
        $I->createClass();
        $I->createTest("test1");
    }
}
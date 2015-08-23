<?php

use Step\Selenium\SeleniumTester;

class ButtonStateChangeCest
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
    public function tryEnableNewMethodButton(SeleniumTester $I)
    {
        $I->wantTo("Enable new method button after creating class.");

        $I->createClass();

        $I->dontSeeElement('button.button-new-method:disabled'); // New method button
        $I->dontseeElement('button.button-new-test:disabled'); // New test button
        $I->dontseeElement('button.button-generate-code:disabled'); // Generate code button

        // Still see workspace overlay
        $I->seeElement('.workspace-overlay'); // Workspace overlay
    }

    // tests
    public function tryEnableWorkspaceOverlay(SeleniumTester $I)
    {
        $I->wantTo("Enable workspace overlay after creating test.");

        $I->createClass();
        $I->createTest();

        // Dont see workspace anymore
        $I->dontSeeElement('.workspace-overlay'); // Workspace overlay
    }
}

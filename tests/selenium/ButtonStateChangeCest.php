<?php

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

    private function createClass(SeleniumGuyTester $I)
    {
        $I->click('button.button-new-class');
        $I->waitForElementVisible('input[name="class_name"]', 3);
        $I->fillField(['name' => 'class_name'], 'Person');
        $I->click('Add', '.modal-footer');
        $I->waitForElementNotVisible('.bootbox .modal-body');
    }

    private function createTest(SeleniumGuyTester $I)
    {
        $I->click('button.button-new-test');
        $I->typeInPopup('test1');
        $I->acceptPopup();
    }

    // tests
    public function tryEnableNewMethodButton(SeleniumGuyTester $I)
    {
        $I->wantTo("Enable new method button after creating class.");

        $this->createClass($I);

        $I->dontSeeElement('button.button-new-method:disabled'); // New method button
        $I->dontseeElement('button.button-new-test:disabled'); // New test button
        $I->dontseeElement('button.button-generate-code:disabled'); // Generate code button

        // Still see workspace overlay
        $I->seeElement('.workspace-overlay'); // Workspace overlay
    }

    // tests
    public function tryEnableWorkspaceOverlay(SeleniumGuyTester $I)
    {
        $I->wantTo("Enable workspace overlay after creating test.");

        $this->createClass($I);
        $this->createTest($I);

        // Dont see workspace anymore
        $I->dontSeeElement('.workspace-overlay'); // Workspace overlay
    }
}

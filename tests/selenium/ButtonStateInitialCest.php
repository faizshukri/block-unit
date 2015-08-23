<?php

class ButtonStateInitialCest
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
    public function tryNewAndUploadButton(SeleniumGuyTester $I)
    {
        $I->wantTo('See new class and upload class button is enabled by default.');
        $I->dontSeeElement('button.button-new-class:disabled'); // New button
        $I->dontSeeElement('button.button-upload-class:disabled'); // Upload button
    }

    // tests
    public function tryNewMethodButton(SeleniumGuyTester $I)
    {
        $I->wantTo('See new method button is disabled by default');
        $I->seeElement('button.button-new-method:disabled'); // New method button
    }

    // tests
    public function tryNewTestButton(SeleniumGuyTester $I)
    {
        $I->wantTo('See new test button is disabled by default');
        $I->seeElement('button.button-new-test:disabled'); // New test button
    }

    // tests
    public function tryGenerateButton(SeleniumGuyTester $I)
    {
        $I->wantTo('See generate code button is disabled by default');
        $I->seeElement('button.button-generate-code:disabled'); // Generate code button
    }

    // tests
    public function tryWorkspaceOverlay(SeleniumGuyTester $I)
    {
        $I->wantTo('See workspace panel is disabled by default');
        $I->dontSeeElement('.workspace-overlay.ng-hide'); // Workspace overlay
    }

}

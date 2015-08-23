<?php 
$I = new SeleniumGuyTester($scenario);
$I->maximizeWindow();

$I->wantTo('See homepage');
$I->amOnPage('/');
$I->see('Home', '.navbar li.active a'); // See active "Home" menu in navigation bar
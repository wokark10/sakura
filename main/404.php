<?php
/*
 * Flashii.net Main Index
 */

// Declare Namespace
namespace Sakura;

// Include components
require_once str_replace(basename(__DIR__), '', dirname(__FILE__)) .'_sakura/sakura.php';

// Print page contents
print Main::tplRender('errors/http404.tpl', $renderData);

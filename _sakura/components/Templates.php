<?php
/*
 * Template Engine Wrapper
 */

namespace Sakura;

class Templates {

    // Engine container, template folder name and options
    public static $_ENG;
    public static $_TPL;
    public static $_CFG;

    // Initialise templating engine and data
    public static function init($template) {

        // Set template folder name
        self::$_TPL = $template;

        // Assign config path to a variable so we don't have to type it out twice
        $confPath = ROOT .'_sakura/templates/'. self::$_TPL .'/template.ini';

        // Check if the configuration file exists
        if(!file_exists($confPath))
            trigger_error('Template configuration does not exist', E_USER_ERROR);

        // Parse and store the configuration
        self::$_CFG = parse_ini_file($confPath, true);

        // Make sure we're not using a manage template for the main site or the other way around
        if((bool)self::$_CFG['manage']['mode'] != (bool)Main::$_MANAGE_MODE)
            trigger_error('Incorrect template type', E_USER_ERROR);

        // Start Twig
        self::twigLoader();

    }

    // Twig Loader
    private static function twigLoader() {

        // Initialise Twig Filesystem Loader
        $twigLoader = new \Twig_Loader_Filesystem(ROOT .'_sakura/templates/'. self::$_TPL);

        // And now actually initialise the templating engine
        self::$_ENG = new \Twig_Environment($twigLoader, array(

           // 'cache' => SATOKO_ROOT_DIRECTORY. self::getConfig('path', 'cache') // Set cache directory

        ));

        // Load String template loader
        self::$_ENG->addExtension(new \Twig_Extension_StringLoader());

    }

    // Render template
    public static function render($file, $tags) {

        return self::$_ENG->render($file, $tags);

    }

}

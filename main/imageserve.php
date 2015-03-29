<?php
/*
 * Sakura user image serving
 */

// Declare Namespace
namespace Sakura;

// Define Sakura Path
define('ROOT_DIRECTORY', str_replace('main', '', dirname(__FILE__)));

// Set Content type
header('Content-Type: application/octet-stream');

// Check if the m(ode) GET request is set
if(isset($_GET['m'])) {
    switch($_GET['m']) {
        case 'avatar':
            // Set path to no avatar picture
            $noAvatar = ROOT_DIRECTORY .'content/img/no-av.png';

            // If ?u= isn't set or if it isn't numeric
            if(!isset($_GET['u']) || !is_numeric($_GET['u'])) {
                $serveImage = $noAvatar;
                break;
            }

            // Check if the avatar exist and assign it to a value
            $serveImage = empty(Users::getUser($_GET['u'])['avatar_url']) ? $noAvatar : Users::getUser($_GET['u'])['avatar_url'];
        break;
        
        case 'background':
            // Set path to no avatar picture
            $noBackground = ROOT_DIRECTORY .'content/pixel.png';

            // If ?u= isn't set or if it isn't numeric
            if(!isset($_GET['u']) || !is_numeric($_GET['u'])) {
                $serveImage = $noBackground;
                break;
            }

            // Check if the avatar exist and assign it to a value
            $serveImage = empty(Users::getUser($_GET['u'])['profilebg']) ? $noBackground : Users::getUser($_GET['u'])['profilebg'];
        break;
        
        default:
            $serveImage = ROOT_DIRECTORY .'content/pixel.png';
    }
} else {
    $serveImage = ROOT_DIRECTORY .'content/pixel.png';
}

$serveImage = file_get_contents($serveImage);

header('Content-Type: ' .getimagesizefromstring($serveImage)['mime']);

print $serveImage;

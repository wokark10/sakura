<?php
/*
 * Sakura user image serving
 */

// Declare Namespace
namespace Sakura;

// Include components
require_once str_replace(basename(__DIR__), '', dirname(__FILE__)) .'_sakura/sakura.php';

// Set Content type
header('Content-Type: application/octet-stream');

// Path to user uploads
$userDirPath = ROOT .'content/images/user/';

// Check if the m(ode) GET request is set
if(isset($_GET['m'])) {

    switch($_GET['m']) {

        case 'avatar':
            // Set paths
            $noAvatar       = ROOT .'content/images/no-av.png';
            $deactiveAvatar = ROOT .'content/images/deactivated-av.png';
            $bannedAvatar   = ROOT .'content/images/banned-av.png';

            // If ?u= isn't set or if it isn't numeric
            if(!isset($_GET['u']) || !is_numeric($_GET['u'])) {
                $serveImage = $noAvatar;
                break;
            }

            // Get user data
            $user = Users::getUser($_GET['u']);
            $data = Users::getUserProfileData($user, true);

            // If user is deactivated use deactive avatar
            if(Users::checkIfUserHasRanks([0, 1], $user, true)) {
                $serveImage = $deactiveAvatar;
                break;
            }

            // Check if user is banned
            if(false) { // [Flashwave 2015-04-27] Banning isn't implemented yet
                $serveImage = $bannedAvatar;
                break;
            }

            // Check if user has an avatar set
            if(empty($data['userAvatar']) || !file_exists($userDirPath . $data['userAvatar'])) {
                $serveImage = $noAvatar;
                break;
            }

            // Check if the avatar exist and assign it to a value
            $serveImage = $userDirPath . $data['userAvatar'];
            break;

        case 'background':
            // Set paths
            $noBackground = ROOT .'content/pixel.png';

            // If ?u= isn't set or if it isn't numeric
            if(!isset($_GET['u']) || !is_numeric($_GET['u'])) {
                $serveImage = $noBackground;
                break;
            }

            // Get user data
            $user = Users::getUser($_GET['u']);
            $data = Users::getUserProfileData($user, true);

            // If user is deactivated use deactive avatar
            if(Users::checkIfUserHasRanks([0, 1], $user, true)) {
                $serveImage = $noBackground;
                break;
            }

            // Check if user is banned
            if(false) { // [Flashwave 2015-04-27] Banning isn't implemented yet
                $serveImage = $noBackground;
                break;
            }

            // Check if user has a background set
            if(empty($data['profileBackground']) || !file_exists($userDirPath . $data['profileBackground'])) {
                $serveImage = $noBackground;
                break;
            }

            // Check if the avatar exist and assign it to a value
            $serveImage = $userDirPath . $data['profileBackground'];
            break;

        case 'header':
            // Set paths
            $noHeader = ROOT .'content/images/triangles.png';

            // If ?u= isn't set or if it isn't numeric
            if(!isset($_GET['u']) || !is_numeric($_GET['u'])) {
                $serveImage = $noHeader;
                break;
            }

            // Get user data
            $user = Users::getUser($_GET['u']);
            $data = Users::getUserProfileData($user, true);

            // If user is deactivated use deactive avatar
            if(Users::checkIfUserHasRanks([0, 1], $user, true)) {
                $serveImage = $noHeader;
                break;
            }

            // Check if user is banned
            if(false) { // [Flashwave 2015-04-27] Banning isn't implemented yet
                $serveImage = $noHeader;
                break;
            }

            // Check if user has a background set
            if(empty($data['profileHeader']) || !file_exists($userDirPath . $data['profileHeader'])) {
                $serveImage = $noHeader;
                break;
            }

            // Check if the avatar exist and assign it to a value
            $serveImage = $userDirPath . $data['profileHeader'];
            break;

        default:
            $serveImage = ROOT .'content/pixel.png';

    }

} else
    $serveImage = ROOT .'content/pixel.png';

$serveImage = file_get_contents($serveImage);

header('Content-Type: ' .getimagesizefromstring($serveImage)['mime']);

print $serveImage;

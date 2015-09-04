<?php
/*
 * Sakura Main Index
 */

// Declare Namespace
namespace Sakura;

// Include components
require_once str_replace(basename(__DIR__), '', dirname(__FILE__)) .'_sakura/sakura.php';

// Info pages
if(isset($_GET['p'])) {

    // Set default variables
    $renderData['page'] = [
        'title'     => 'Info pages',
        'content'   => Main::mdParse("# Unable to load the requested info page.\r\n\r\nCheck the URL and try again.")
    ];

    // Set page id
    $pageId = isset($_GET['p']) ? strtolower($_GET['p']) : '';

    // Get info page data from the database
    if($ipData = Main::loadInfoPage($pageId)) {

        // Assign new proper variable
        $renderData['page'] = [

            'id'        => $pageId,
            'title'     => $ipData['pagetitle'],
            'content'   => Main::mdParse($ipData['content'])

        ];

    }

    // Print page contents
    print Templates::render('main/infopage.tpl', $renderData);
    exit;

}

// Are we in forum mode?
$forumMode = isset($_GET['forum']) ? ($_GET['forum'] == true) : false;

// Add page specific things
$renderData['newsPosts'] = ($forumMode ? null : Main::getNewsPosts(Configuration::getConfig('front_page_news_posts')));

$renderData['page'] = [
    'title'         => ($forumMode ? 'Forum Listing' : Configuration::getConfig('sitename')),
    'friend_req'    => Users::getPendingFriends()
];

$renderData['board'] = [
    'forums'    => ($forumMode ? Forum::getForumList() : null),
    'viewforum' => false,
    'viewtopic' => false
];

$renderData['stats'] = [
    'userCount'     => ($_INDEX_USER_COUNT      = count($_INDEX_USERS = Users::getAllUsers(false))),
    'newestUser'    => ($_INDEX_NEWEST_USER     = new User(Users::getNewestUserId())),
    'lastRegDate'   => ($_INDEX_LAST_REGDATE    = date_diff(date_create(date('Y-m-d', $_INDEX_NEWEST_USER->data['regdate'])), date_create(date('Y-m-d')))->format('%a')) .' day'. ($_INDEX_LAST_REGDATE == 1 ? '' : 's'),
    'onlineUsers'   => Users::checkAllOnline(),
    'topicCount'    => ($_TOPICS    = count(Database::fetch('topics'))),
    'postCount'     => ($_POSTS     = count(Database::fetch('posts')))
];

// Print page contents
print Templates::render(($forumMode ? 'forum' : 'main') .'/index.tpl', $renderData);

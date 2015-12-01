<?php
/*
 * Discussion Board
 */

namespace Sakura\Forum;

use Sakura\Main;
use Sakura\Database;
use Sakura\User;
use Sakura\BBcode\BBcode;

/**
 * Class Forums
 * @package Sakura
 */
class Forums
{
    // Empty forum template
    public static $emptyForum = [
        'forum_id' => 0,
        'forum_name' => 'Forum',
        'forum_desc' => '',
        'forum_link' => '',
        'forum_category' => 0,
        'forum_type' => 1,
        'forum_posts' => 0,
        'forum_topics' => 0,
    ];

    // Get a forum or category
    public static function getForum($id)
    {

        // Get the forumlist from the database
        $forums = Database::fetch('forums');

        // Sneak the template in the array
        $forums['fb'] = self::$emptyForum;

        // Create an array to store the forum once we found it
        $forum = [];

        // Try to find the requested forum
        foreach ($forums as $list) {
            // Once found set $forum to $list and break the loop
            if ($list['forum_id'] == $id) {
                $forum['forum'] = $list;
                break;
            }
        }

        // If $forum is still empty after the foreach return false
        if (empty($forum)) {
            return false;
        }

        // Create conditions for fetching the forums
        $conditions['forum_category'] = [$id, '='];

        // If the current category is 0 (the built in fallback) prevent getting categories
        if ($id == 0) {
            $conditions['forum_type'] = ['1', '!='];
        }

        // Check if this forum/category has any subforums
        $forum['forums'] = Database::fetch('forums', true, $conditions);

        // Get the userdata related to last posts
        foreach ($forum['forums'] as $key => $sub) {
            // Get last post in forum
            $lastPost = Database::fetch('posts', false, [
                'forum_id' => [$sub['forum_id'], '='],
            ], ['post_id', true]);

            $forum['forums'][$key]['last_poster'] = new User($lastPost['poster_id']);
            $forum['forums'][$key]['last_post'] = array_merge(
                empty($lastPost) ? [] : $lastPost,
                ['elapsed' => Main::timeElapsed($lastPost['post_time'])]
            );
        }

        // Lastly grab the topics for this forum
        $forum['topics'] = self::getTopics($forum['forum']['forum_id']);

        // Return the forum/category
        return $forum;
    }

    // Getting all topics from a forum
    public static function getTopics($id)
    {

        // Get the topics from the database
        $topics = Database::fetch('topics', true, [
            'forum_id' => [$id, '='],
        ]);

        // Get the userdata related to last posts
        foreach ($topics as $key => $topic) {
            // Get the reply count
            $topics[$key]['reply_count'] = Database::count('posts', [
                'topic_id' => [$topic['topic_id'], '='],
            ])[0];

            // Get first post in topics
            $firstPost = Database::fetch('posts', false, [
                'topic_id' => [$topic['topic_id'], '='],
            ]);

            $topics[$key]['first_poster'] = new User($firstPost['poster_id']);

            $topics[$key]['first_post'] = array_merge(
                empty($firstPost) ? [] : $firstPost,
                ['elapsed' => Main::timeElapsed($firstPost['post_time'])]
            );

            // Get last post in topics
            $lastPost = Database::fetch('posts', false, [
                'topic_id' => [$topic['topic_id'], '='],
            ], ['post_id', true]);

            $topics[$key]['last_poster'] = new User($lastPost['poster_id']);

            $topics[$key]['last_post'] = array_merge(
                empty($lastPost) ? [] : $lastPost,
                ['elapsed' => Main::timeElapsed($lastPost['post_time'])]
            );
        }

        return $topics;
    }

    // Get posts of a thread
    public static function getTopic($id, $ignoreView = false)
    {

        // Get the topic data from the database
        $topicInfo = Database::fetch('topics', false, [
            'topic_id' => [$id, '='],
        ]);

        // Check if there actually is anything
        if (empty($topicInfo)) {
            return false;
        }

        // Up the view count
        if (!$ignoreView) {
            // Get the new count
            $topicInfo['topic_views'] = $topicInfo['topic_views'] + 1;

            // Update the count
            Database::update('topics', [
                [
                    'topic_views' => $topicInfo['topic_views'],
                ],
                [
                    'topic_id' => [$id, '='],
                ],
            ]);
        }

        // Get the posts from the database
        $rawPosts = Database::fetch('posts', true, [
            'topic_id' => [$id, '='],
        ]);

        // Create storage array
        $topic = [];

        // Add forum data
        $topic['forum'] = self::getForum($topicInfo['forum_id']);

        // Store the topic info
        $topic['topic'] = $topicInfo;

        // Get first post in topics
        $firstPost = Database::fetch('posts', false, [
            'topic_id' => [$topic['topic']['topic_id'], '='],
        ]);

        $topic['topic']['first_poster'] = new User($firstPost['poster_id']);

        $topic['topic']['first_post'] = array_merge(
            empty($firstPost) ? [] : $firstPost,
            ['elapsed' => Main::timeElapsed($firstPost['post_time'])]
        );

        // Get last post in topics
        $lastPost = Database::fetch('posts', false, [
            'topic_id' => [$topic['topic']['topic_id'], '='],
        ], ['post_id', true]);

        $topic['topic']['last_poster'] = new User($lastPost['poster_id']);

        $topic['topic']['last_post'] = array_merge(
            empty($lastPost) ? [] : $lastPost,
            ['elapsed' => Main::timeElapsed($lastPost['post_time'])]
        );

        // Create space for posts
        $topic['posts'] = [];

        // Parse the data of every post
        foreach ($rawPosts as $post) {
            // Add post and metadata to the global storage array
            $topic['posts'][$post['post_id']] = array_merge($post, [
                'user' => (new User($post['poster_id'])),
                'elapsed' => Main::timeElapsed($post['post_time']),
                'is_op' => ($post['poster_id'] == $firstPost['poster_id'] ? '1' : '0'),
                'parsed_post' => self::parseMarkUp($post['post_text'], 1, 1),
            ]);

            // Just in case
            unset($_POSTER);
        }

        // Return the compiled topic data
        return $topic;
    }

    // Get a forum ID from a topic ID
    public static function getForumIdFromTopicId($id)
    {

        // Get the topic
        $topic = Database::fetch('topics', false, [
            'topic_id' => [$id, '='],
        ]);

        // Return false if nothing was returned
        if (empty($topic)) {
            return false;
        }

        // Return the forum id
        return $topic['forum_id'];
    }

    // Get a topic ID from a post ID
    public static function getTopicIdFromPostId($id)
    {

        // Get the post
        $post = Database::fetch('posts', false, [
            'post_id' => [$id, '='],
        ]);

        // Return false if nothing was returned
        if (empty($post)) {
            return false;
        }

        // Return the topic id
        return $post['topic_id'];
    }

    // Parse different markup flavours
    public static function parseMarkUp($text, $mode, $emotes = 1)
    {

        // Clean string
        $text = Main::cleanString($text);

        // Parse emotes
        if ($emotes) {
            $text = Main::parseEmotes($text);
        }

        // Switch between modes
        switch ($mode) {
            case 1:
            case 2:
                return Main::bbParse($text);

            case 0:
            default:
                return $text;
        }
    }

    // Get forum statistics of a user
    public static function getUserStats($uid)
    {

        // Collect the stats
        return [
            'posts' => Database::count(
                'posts',
                ['poster_id' => [$uid, '=']]
            )[0],
            'topics' => count(Database::fetch(
                'posts',
                true,
                ['poster_id' => [$uid, '=']],
                ['post_time'],
                null,
                ['topic_id']
            )),
        ];
    }

    // Creating a new post
    public static function createPost($poster, $title, $text, $forum, $topic = 0, $parse = 0, $signature = 0, $emotes = 0, $type = 0, $status = 0)
    {

        // Check if we're replying to a thread
        $getThread = Database::fetch('topics', false, ['topic_id' => [$topic, '=']]);

        // Convert the text to storage format
        $bbcode = new BBcode($text);
        $text = $bbcode->toStore();

        // If nothing was returned create a new thread
        if (!$getThread) {
            // Insert the required data
            Database::insert('topics', [
                'forum_id' => $forum,
                'topic_title' => $title,
                'topic_time' => time(),
                'topic_status' => $status,
                'topic_type' => $type,
            ]);

            // Fetch the last insert
            $getThread = Database::fetch('topics', false, [
                'topic_id' => [Database::lastInsertID(), '='],
            ]);
        }

        // Insert the post
        Database::insert('posts', [
            'topic_id' => $getThread['topic_id'],
            'forum_id' => $getThread['forum_id'],
            'poster_id' => $poster,
            'post_time' => time(),
            'post_signature' => $signature,
            'post_subject' => $title,
            'post_text' => $text,
        ]);

        // Fetch the last insert
        $getPost = Database::fetch('posts', false, [
            'post_id' => [Database::lastInsertID(), '='],
        ]);

        // Update the topic with the last details
        Database::update('topics', [
            [
                'topic_last_reply' => time(),
            ],
            [
                'topic_id' => [$getPost['topic_id'], '='],
            ],
        ]);

        // Return success
        return [1, 'SUCCESS', $getPost['forum_id'], $getPost['topic_id'], $getPost['post_id']];
    }
}

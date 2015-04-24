<?php


namespace yiiunit\framework\log;

/**
 * @group log
 * @group db
 * @group sqlite
 */
class SQliteTargetTest extends DbTargetTest
{
    protected static $driverName = 'sqlite';
}
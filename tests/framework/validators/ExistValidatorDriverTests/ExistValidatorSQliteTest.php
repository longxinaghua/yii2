<?php
namespace yiiunit\framework\validators\ExistValidatorDriverTests;

use yiiunit\framework\validators\ExistValidatorTest;

/**
 * @group validators
 * @group sqlite
 * @group db
 */
class ExistValidatorSQliteTest extends ExistValidatorTest
{
    protected $driverName = 'sqlite';
}

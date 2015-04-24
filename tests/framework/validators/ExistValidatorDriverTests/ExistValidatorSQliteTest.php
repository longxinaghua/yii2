<?php
namespace yiiunit\framework\validators\ExistValidatorDriverTests;

use yiiunit\framework\validators\ExistValidatorTest;

/**
 * @group validators
 * @group sqlite
 */
class ExistValidatorSQliteTest extends ExistValidatorTest
{
    protected $driverName = 'sqlite';
}

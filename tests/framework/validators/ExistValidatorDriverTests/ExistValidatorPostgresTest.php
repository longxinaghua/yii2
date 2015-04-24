<?php
namespace yiiunit\framework\validators\ExistValidatorDriverTests;

use yiiunit\framework\validators\ExistValidatorTest;

/**
 * @group validators
 * @group pgsql
 */
class ExistValidatorPostgresTest extends ExistValidatorTest
{
    protected $driverName = 'pgsql';
}

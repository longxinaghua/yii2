<?php

namespace yiiunit\framework\validators\UniqueValidatorDriverTests;

use yiiunit\framework\validators\UniqueValidatorTest;

/**
 * @group validators
 * @group pgsql
 */
class UniqueValidatorPostgresTest extends UniqueValidatorTest
{
    protected $driverName = 'pgsql';
}


# the php version to run tests against
# this must be a tag or branch name from the https://github.com/php/php-src repository
PHP_VERSON=php-5.6.8

# options to pass to phpunit
PHPUNIT_OPTIONS=--color
PHPUNIT_EXCLUDE=zenddata,wincache,xcache

# options to pass to the main docker command
DOCKER_OPTIONS=--rm=true

help:
	@echo "This Makefile is mainly used for test execution using docker (https://www.docker.com/)."
	@echo ""
	@echo "Note: If you want to run the tests in your native environment, just run phpunit instead."
	@echo ""
	@echo "The following targets are available (run them as make <target>):"
	@echo ""
	@echo "test          - run all available tests"
	@echo "                this includes building all the docker images"
	@echo "                for several DBMS, which may take a long time"
	@echo "test-nodb     - run all tests that do not need an external database or service"
	@echo "test-<dbms>   - run tests for DBMS <dbms> which can be one of the following:"
	@echo "                cubrid, oci, pgsql, mysql, mssql, memcache, memcached"
	@echo "clean         - stop and remove all test related docker containers"
	@echo "docker-php    - build the docker environment for PHP"
	@echo "docker-<dbms> - build the docker environment for <dbms> which can be one of the following:"
	@echo "                - none available right now -"
	@echo "                TODO: cubrid, oci, pgsql, mysql, mssql, memcache, memcached"


# testing targets

test: test-nodb test-cubrid test-oci test-pgsql test-mysql test-mssql test-memcache test-memcached

test-nodb: composer docker-php
	# this only excludes external databases, so sqlite is included
	docker run -v $(shell pwd):/opt/test ${DOCKER_OPTIONS} yiitest/php:${PHP_VERSION} vendor/bin/phpunit --exclude-group=db,cubrid,oci,pgsql,mysql,mssql,memcache,memcached,${PHPUNIT_EXCLUDE} ${PHPUNIT_OPTIONS}

test-%: composer docker-php run-docker-%
	if test -f tests/dockerids/$* ; then \
		# link test container against db container
		docker run -v $(shell pwd):/opt/test --link $(shell cat tests/dockerids/$*):$* ${DOCKER_OPTIONS} yiitest/php:${PHP_VERSION} vendor/bin/phpunit --group=$% ${PHPUNIT_OPTIONS}
	else
		docker run -v $(shell pwd):/opt/test ${DOCKER_OPTIONS} yiitest/php:${PHP_VERSION} vendor/bin/phpunit --group=$% ${PHPUNIT_OPTIONS}
	fi


# setup targets

composer:
	#composer install --prefer-dist


run-docker-%: docker-%
	docker run -d -P yiitest/$*:latest > tests/dockerids/$*

run-docker-oci: dockerfiles
	docker run -d -P alexeiled/docker-oracle-xe-11g > tests/dockerids/oci


docker-php: dockerfiles
	cd tests/docker/php && sh build.sh

docker-%: dockerfiles
	(test -d tests/docker/$* && cd tests/docker/$* && sh build.sh) || echo "there is no docker available for $*" && exit 1

dockerfiles:
	test -d tests/docker || git clone https://github.com/cebe/jenkins-test-docker tests/docker
	cd tests/docker && git checkout -- . && git pull
	mkdir -p tests/dockerids

clean:
	docker stop $(shell cat tests/dockerids/*)
	docker rm $(shell cat tests/dockerids/*)
	rm tests/dockerids/*


setup-zoo:
        @echo 'deploying a kafka cluster into ${SERVER_IP}'
        -eval "$(docker-machine env default)"
        @docker-compose down -v
        @docker-compose build
        @docker-compose up -d zoo1 zoo2 zoo3

up: setup-zoo
        @echo '=== Sleeping for 15s while Zookeeper initialises ===' && sleep 15
        -docker-compose up
        @docker-compose down

reset:
        @docker-compose stop
        @docker-compose rm -vf

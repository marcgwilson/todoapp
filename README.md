# TODO app
```bash
git clone --recursive git@github.com:marcgwilson/todoapp.git
```

## Build Docker container
```bash
make
```

## Run with `docker-compose`    
```bash
docker-compose up -d    # start
docker-compose down     # stop
```

## Run with `docker-compose` development file
```bash
docker-compose -f docker-compose-dev.yml up -d      # start
docker-compose -f docker-compose-dev.yml down       # stop
```

## Connect to running container
```bash
./shell
```

## `curl.sh`
```bash
export TODO_ADDR="0.0.0.0:8000"
./curl.sh
```

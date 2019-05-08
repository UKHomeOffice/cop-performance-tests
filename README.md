# COP Performance Tests

## Dependencies

- [Docker](https://www.docker.com/)

## Usage

```
git clone git@github.com:UKHomeOffice/cop-performance-tests.git

cd cop-performance-tests

docker build .

docker run -e POSTGREST_DOMAIN='<POSTGREST_DOMAIN>' -e POSTGREST_PATH='<POSTGREST_PATH>' <CONTAINER_NAME>
```

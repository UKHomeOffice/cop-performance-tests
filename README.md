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

# Drone secrets

Name|Example
---|---
dev_drone_aws_access_key_id|https://console.aws.amazon.com/iam/home?region=eu-west-2#/users/bf-it-devtest-drone?section=security_credentials
dev_drone_aws_secret_access_key|https://console.aws.amazon.com/iam/home?region=eu-west-2#/users/bf-it-devtest-drone?section=security_credentials
env_keycloak_realm|cop-dev, cop-staging, cop
env_keycloak_url|sso-dev.notprod.homeoffice.gov.uk/auth, sso.digital.homeoffice.gov.uk/auth
env_kube_namespace|private-cop-dev
env_kube_server|https://kube-api-notprod.notprod.acp.homeoffice.gov.uk, https://kube-api-prod.prod.acp.homeoffice.gov.uk
env_kube_token|xxx
env_perf_test_s3_kms_key_id|8xx10gh8-88bc-742s-9314-2xdklak8j391
env_perf_test_s3_access_key|xxx
env_perf_test_s3_bucket_name|private-cop-s3
env_perf_test_s3_secret_key|xxx
env_perf_test_refdata_url|api.xxx.xxxx.xxxx.gov.uk
env_perf_test_refdata_base_url|www.xxx.xxx.xxx.gov.uk
env_perf_test_refdata_username|acceptance-xxx-user
env_perf_test_refdata_password|WstcAxcGYFXD4rXN
env_perf_test_reprt_base_url|https://cop-test-xxxx.xxx.xxx.xxx.gov.uk
slack_webhook|https://hooks.slack.com/services/xxx/yyy/zzz (Global for all repositories and environments)

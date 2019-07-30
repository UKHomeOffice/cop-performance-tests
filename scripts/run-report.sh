#!/usr/bin/env bash

runTests()
{
    bzt -l bzt.log /bzt/config/config.yml

    TEST_RUN_STATUS=$?

    echo "######## TEST RUN STATUS : $TEST_RUN_STATUS #######"

    cat /bzt/bzt_artifacts/bzt.log

    ls -lrt /bzt/bzt_artifacts/

#    cat /bzt/bzt_artifacts/summary-report.csv
}

uploadReport()
{
    REPORT_DATE_TIME=$(date +%Y%m%d%H%M%S)

    echo ${TAURUS_ARTIFACTS_DIR}

    s3cmd --region=eu-west-2 --server-side-encryption --server-side-encryption-kms-id=${S3_KMS_KEY_ID} --access_key=${S3_ACCESS_KEY} --secret_key=${S3_SECRET_KEY} put --recursive /bzt/bzt_artifacts/report/ s3://${S3_BUCKET_NAME}/test-reports/perf-${REPORT_DATE_TIME}/ --no-mime-magic --guess-mime-type
#    s3cmd --region=eu-west-2 --server-side-encryption --server-side-encryption-kms-id=${S3_KMS_KEY_ID} --access_key=${S3_ACCESS_KEY} --secret_key=${S3_SECRET_KEY} --recursive modify --add-header='content-type':'text/css' --exclude '' --include '.css' s3://${S3_BUCKET_NAME}/test-reports/perf-${REPORT_DATE_TIME}/

    REPORT_UPLOAD_STATUS=$?

    echo "######## REPORT UPLOAD STATUS : $REPORT_UPLOAD_STATUS #######"
}


createReportUrl()
{
    REPORT_BASE_URL="https://cop-test-reports.cop.dev.homeoffice.gov.uk"
    REPORT_FULL_URL="${REPORT_BASE_URL}/perf-$REPORT_DATE_TIME/index.html"
}

createSlackMessage()
{

    if [ ${TEST_RUN_STATUS} = 0 ]; then
        SLACK_TEST_STATUS=" Test Execution *Successful*"
        SLACK_COLOR="good"
    else
        SLACK_TEST_STATUS=" Test Execution *Failed*"
        SLACK_COLOR="danger"
    fi

    SLACK_FALLBACK="${SLACK_TEST_STATUS} on ${KUBE_NAMESPACE}\nTest Execution Report URL - ${REPORT_FULL_URL}"
    SLACK_TEXT="${SLACK_TEST_STATUS} on ${KUBE_NAMESPACE}"

    echo "###### Slack Message :: ${SLACK_FALLBACK}"

}

sendSlackMessage()
{
    curl -X POST --data-urlencode \
    "payload={
           \"channel\": \"#cop-test-report\",
           \"username\": \"Performance Test\",
           \"attachments\":
                [
					{
						\"fallback\": \"${SLACK_FALLBACK}\",
						\"text\": \"${SLACK_TEXT}\",
						\"color\": \"${SLACK_COLOR}\",
						\"title\": \"Test Report\",
						\"title_link\": \"${REPORT_FULL_URL}\",
						\"mrkdwn_in\": [\"text\", \"pretext\"]
					}
				]
        }" ${SLACK_WEB_HOOK}

}

runTests
uploadReport
createReportUrl
createSlackMessage
sendSlackMessage
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

    s3cmd --region=eu-west-2 --server-side-encryption --server-side-encryption-kms-id=${S3_KMS_KEY_ID} --access_key=${S3_ACCESS_KEY} --secret_key=${S3_SECRET_KEY} put --recursive /bzt/bzt_artifacts/report/ s3://${S3_BUCKET_NAME}/test-reports/perf-${REPORT_DATE_TIME}/
    s3cmd --region=eu-west-2 --server-side-encryption --server-side-encryption-kms-id=${S3_KMS_KEY_ID} --access_key=${S3_ACCESS_KEY} --secret_key=${S3_SECRET_KEY} cp s3://${S3_BUCKET_NAME}/test-reports/perf-${REPORT_DATE_TIME}/content/css s3://${S3_BUCKET_NAME}/test-reports/perf-${REPORT_DATE_TIME}/content/css --content-type="text/css" --metadata-directive REPLACE

    REPORT_UPLOAD_STATUS=$?

    echo "######## REPORT UPLOAD STATUS : $REPORT_UPLOAD_STATUS #######"
}


createReportUrl()
{
    REPORT_BASE_URL="https://cop-s3-proxy.cop-test.homeoffice.gov.uk"
    REPORT_FULL_URL="${REPORT_BASE_URL}/perf-$REPORT_DATE_TIME/index.html"
}

createSlackMessage()
{
    TEST_ENV="[COP-Test]"

    SLACK_MESSAGE="$TEST_ENV"

    if [ ${TEST_RUN_STATUS} = 0 ]; then
        SLACK_MESSAGE+=" Test Execution Successful"
        SLACK_EMOJI=":white_check_mark:"
    else
        SLACK_MESSAGE+=" Test Execution Failed"
        SLACK_EMOJI=":x:"
    fi
    SLACK_MESSAGE+="\n"

    SLACK_MESSAGE+="Test Execution Report URL - ${REPORT_FULL_URL}"

    echo "###### Slack Message :: ${SLACK_MESSAGE}"
}

sendSlackMessage()
{
    curl -X POST --data-urlencode \
    "payload={
           \"channel\": \"#cop-test-report\",
           \"username\": \"TestReporter\",
           \"text\": \"${SLACK_MESSAGE}\",
           \"icon_emoji\": \"${SLACK_EMOJI}\"
        }" ${SLACK_WEB_HOOK}
}

runTests
uploadReport
createReportUrl
createSlackMessage
sendSlackMessage
$mappingsPath = Join-Path $PSScriptRoot "wiremock"

docker run --rm `
    --name mechanics-wiremock `
    -p 9091:8080 `
    -v "${mappingsPath}:/home/wiremock/mappings" `
    wiremock/wiremock `
    --verbose --global-response-templating

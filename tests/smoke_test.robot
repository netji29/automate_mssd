*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}     https://volunteer-smart-beta.nu.ac.th/mssdTest/login

*** Test Cases ***
Open Homepage And Check Title
    [Documentation]    เปิดหน้า example.com แล้วตรวจสอบ title
    Open Browser    ${URL}    chrome
    Title Should Be    Example Domain
    [Teardown]    Close Browser

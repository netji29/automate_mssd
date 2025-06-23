*** Keywords ***
Login To Application
    Open Browser    $https://volunteer-smart-beta.nu.ac.th/mssdTest/login    chrome
    Input Text      id=username      ptnUserdistrict
    Input Text      id=password      ptnUserdistrict
    Click Button    type="submit"
    Wait Until Page Contains    Welcome

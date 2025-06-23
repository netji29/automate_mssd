*** Settings ***
Library           RPA.Playwright
Library           Collections
Library           FakerLibrary
Suite Setup       Setup Browser
Suite Teardown    Teardown Browser
Test Setup        New Context    headless=True
Test Teardown     Close Context

*** Variables ***
${BASE_URL}       https://volunteer-smart-beta.nu.ac.th/mssdTest
${USERNAME}       ptnUserdistrict
${PASSWORD}       ptnUserdistrict
${PDF_PATH}       ${CURDIR}/testfiles/เฉลย.pdf
${PDF_PATH}       ${CURDIR}/testfiles/เฉลย.pdf

*** Test Cases ***
กรอกข้อมูลและตรวจสอบ LocalStorage รวมทั้งเพิ่มข้อมูลผู้ได้รับผลกระทบ
    [Documentation]    1. Login  2. เลือก impact type widow  3. กรอกฟอร์ม 1.1.1–1.1.3  4. อัพโหลดไฟล์ & verify localStorage  
    Login To Application
    Add Impact Type Widow
    Fill Form 1.1.1
    Fill Form 1.1.2
    Verify LocalStorage Uploaded File
    Fill Form 1.1.3
    Fill Form 3.1.1
    Fill Form 3.1.2
    Fill Form 3.1.3
    Fill Form 3.1.4
    Fill Form 3.1.5
    Fill Form 4.1.1
    

*** Keywords ***
Setup Browser
    Open Browser    ${BASE_URL}    chromium

Teardown Browser
    Close All Browsers

Login To Application
    Go To    ${BASE_URL}/login
    Wait Until Element Is Visible    css=input#username    timeout=60s
    Fill Text    css=input#username    ${USERNAME}
    Fill Text    css=input#password    ${PASSWORD}
    Click Button    css=button:has-text("เข้าสู่ระบบ")
    Wait Until Location Is    ${BASE_URL}/    timeout=60s

Add Impact Type Widow
    Click Button    css=.bg-buttonhome
    Wait Until Element Is Visible    css=#selectimpact    timeout=30s
    Select From List By Value    css=#selectimpact    widow
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    /widowed    timeout=60s

Fill Form 1.1.1
    [Documentation]    ถ้ามีฟอร์มแรก (form1_1.1) ให้ระบุขั้นตอนที่นี่
    # ตัวอย่าง
    # Wait Until Element Is Visible    css=#some_field
    # Fill Text    css=#some_field    ค่าใดๆ

Fill Form 1.1.2
    [Documentation]    กรอกข้อมูลฟอร์ม 1.1.2 ด้วยข้อมูลสุ่ม
    ${house_code}=       Evaluate    str(__import__('random').randint(100000,999999))
    Fill Text            css=#house_code    ${house_code}
    ${latitude}=         Evaluate    "{:.6f}".format(__import__('random').uniform(16,17))
    Fill Text            css=#latitude      ${latitude}
    ${longitude}=        Evaluate    "{:.6f}".format(__import__('random').uniform(100,101))
    Fill Text            css=#longitude     ${longitude}
    # … (กรอก moo, soi_trong, street, newHouseNumber, newRoad, ฯลฯ ตามต้นฉบับ)
    Upload File          css=input[type="file"]    ${PDF_PATH}
    Wait Until Element Is Visible    xpath=//text()[contains(.,'เฉลย.pdf')]    timeout=20s
    Click Button         css=button:has-text("ถัดไป")
    Wait Until Location Contains    /form1_1.2    timeout=60s

Verify LocalStorage Uploaded File
    [Documentation]    ตรวจสอบ key `uploaded_file` ใน localStorage
    ${uploaded_file}=   Execute JavaScript    return window.localStorage.getItem('uploaded_file');
    Should Not Be Empty    ${uploaded_file}
    Should Contain         ${uploaded_file}    เฉลย.pdf

Fill Form 1.1.3
    Go To    ${BASE_URL}/widowed/form1_1.3
    Wait Until Element Is Visible    css=#day    timeout=30s
    # … (กรอก fields ที่เหลือทั้งหมดใน form1_1.3 ตามต้นฉบับ)
    Click Button    css=button:has-text("ถัดไป")
    Wait Until Location Contains    /form3_1.1    timeout=60s

Fill Form 3.1.1
    Go To    ${BASE_URL}/widowed/form3_1.1
    Wait Until Element Is Visible    xpath=//div[contains(text(),"ส่วนที่ 3 ข้อมูลครอบครัวและความสัมพันธ์")]
    # เลือก checkbox หรือกรอกข้อมูลตามต้นฉบับ
    Click Element   css=#isDisabled
    # … (กรอก fields อื่นๆ แล้วบันทึก)
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    /form3_1.2    timeout=60s

Fill Form 3.1.2
    Go To    ${BASE_URL}/widowed/form3_1.2
    Wait Until Element Is Visible    xpath=//div[contains(text(),"ส่วนที่ 3 ข้อมูลครอบครัวและความสัมพันธ์")]
    # สุ่มเลือก has_system_debt, has_informal_debt, has_saving_money พร้อมกรอกตัวเลข
    ${has_system_debt}=    Evaluate    __import__('random').choice(['yes','no'])
    Click Radio Button     css=#has_system_debt_${has_system_debt}
    Run Keyword If    '${has_system_debt}'=='yes'    Fill System Debt Details
    # … (ดำเนินการคล้ายกันกับ informal_debt และ saving_money)
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    /child    timeout=60s


Fill System Debt Details
    ${amount}=    Evaluate    str(__import__('random').randint(1000,100000))
    Fill Text     css=#system_debt_total          ${amount}
    ${per_month}= Evaluate    str(__import__('random').randint(100,10000))
    Fill Text     css=#system_debt_per_month      ${per_month}


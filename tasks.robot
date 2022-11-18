*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.

Library    RPA.Browser    auto_close=${false}
Library    RPA.Excel.Files

Library     RPA.Tables
Library    RPA.HTTP
Library    RPA.Windows
Library    RPA.PDF
Library    RPA.Desktop
Library    Screenshot
Library    RPA.Email.ImapSmtp
Library    RPA.Outlook.Application

*** Variables ***
${ordees}=    Create List    kamma.naveen@yash.com
${paths}    C:\Users\putta.rakesh\Documents\Robocorp\robocorplevel2\orders.csv

*** Keywords ***
getting table

    

*** Tasks ***
Orders robots from RobotSpareBin Industries Inc.
    Send Email    ${ordees}    about_taskss    hi hello
    Open Available Browse   https://robotsparebinindustries.com/#/robot-order    
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True
    Click Button When Visible    Xpath://button[contains(text(),'OK')]
    ${table}=    Read table from CSV    Orders.csv    header=True
    FOR    ${i}    IN    @{table}
        Select From List By Value    head    ${i}[Head]
        Select Radio Button    body    ${i}[Body]
        Input Text    css:Input[class='form-control']    ${i}[Legs]
        Input Text    address  ${i}[Address]
        Click Button    preview 
        Click Button    order
        Sleep    2s
        WHILE    True
             TRY
                 ${result}=    Get Element Attribute     id:order-completion    outerHTML
             EXCEPT 
                 Click Button    order
             ELSE
                ${re}=    Html To Pdf    ${result}       pdf${/}${i}[Order number].pdf
                 BREAK
             END
        END
        ${screen}=    Capture Element Screenshot    id:robot-preview-image    pdf${/}${i}[Order number].png 
        
       ${files}=    Create List
    ...    pdf${/}${i}[Order number].pdf
    ...    pdf${/}${i}[Order number].png:align=center
   
    Add Files To PDF    ${files}    newdoc${i}[Order number].pdf    append=True
    Click Button    order-another     
    Sleep    3s
    Click Button When Visible    Xpath://button[contains(text(),'OK')]    

    END



        

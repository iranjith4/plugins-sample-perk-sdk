
local perk = require "plugin.perk"
local widget = require( "widget" )

local PERK_APP_KEY = "daee393f1b55f99f410c17259172fef9db7b2480"
local PERK_EVENT_ID = "102baba4474a87b8075b65e8aae2473ca510b3b4"
local PERK_AD_EVENT_ID = "dad4e9b6c976ce85c959f9b1d08f459049461b5a"

local PERK_ANDROID_APP_KEY = "81000a9d5407667548eb3ceec9dc699823a02ba9"
local PERK_TAP_ONCE_ANDROID_EVENT_ID = "1037c884e25ac9faa84986c38bca8e99ccc07340"
local PERK_ANDROID_DISPLAY_EVENT_ID = "f0c902bd33a74e7d6504696dffedc66e5dbdb47c"
local PERK_ANDROID_AD_EVENT_ID = "05536119cdbdf1c7baff4c0427a467c5a1745ff7"

display.setStatusBar(display.HiddenStatusBar)

local displayText
local hideNotifications = true
local toggleNotificationsButton

local function perkListener( event )

    if (event.phase == 'init') then
        displayText.text = "init status : "..tostring(event.data)
    elseif (event.phase == 'sdk_event_callbacks') then
    --native.showAlert( event.phase,event.data, { "OK" } )
    displayText.text = tostring(event.data)

    elseif (event.phase == 'sdk_adserver_callbacks') then
    --native.showAlert( event.phase,event.data, { "OK" } )
    displayText.text = tostring(event.data)

    elseif (event.phase == 'sdk_user_info') then
        for k, v in pairs( event.data ) do
            print(k, v)
        end
    displayText.text = "Points:"..event.data.available_points..":".. event.data.first_name..":".. event.data.last_name

    elseif (event.phase == 'sdk_supported_country_list') then
        native.showAlert( event.phase, table.concat(event.data,","), { "OK" } )

    elseif (event.phase == 'sdk_toggle_status') then
    native.showAlert( event.phase,tostring(event.data), { "OK" } )

    elseif (event.phase == 'sdk_user_status') then
    native.showAlert( event.phase,tostring(event.data), { "OK" } )

    elseif (event.phase == 'sdk_publisher_points') then
    native.showAlert( event.phase,tostring(event.data), { "OK" } )

    elseif (event.phase == 'sdk_fetch_unclaimed_notification') then
    native.showAlert( event.phase,tostring(event.data), { "OK" } )

    elseif (event.phase == 'sdk_track_event') then
    displayText.text = "Points Earned:"..event.data.point_earned..":".. event.data.notification_text

    elseif (event.phase == 'sdk_event_callbacks') then
    displayText.text = tostring(event.data)

    end
end


-- PJ: Added these functions for getting callbacks. A must call if user wants call back.
-- Call Back setting for normal SDK related callbacks.
--perk.receivePerkPointCallBacks( )

-- callbacks for Adserver advance call backs. IF required please uncomment.
--perk.receiveAdServerCallBacks( )

local function onPortalButton()
    perk.showPortal( )
end

----------

-- perk.init("daee393f1b55f99f410c17259172fef9db7b2480")
perk.init(PERK_ANDROID_APP_KEY,perkListener)

-- Runtime:addEventListener( "perk", perkListener )
---------

local function onUnclaimedPage()
    perk.launchUnclaimedPage( )
end

local function onTrackEvent()
    perk.trackEvent(PERK_TAP_ONCE_ANDROID_EVENT_ID, false)
-- "false" is if user does not want custom notification and want to use SDK notification.
-- "true" for hide SDK notification and design App specific notification.
-- PJ: Created a SUB ID section param in track event, I can change this as per planning or what ever you recommend.
end


-- PJ: New functions for Ad server calls

local function onLaunchDatapoints()
    perk.showSurveyAds(PERK_ANDROID_AD_EVENT_ID)
end

local function onLaunchAdbutton()
    perk.showAds(PERK_ANDROID_AD_EVENT_ID,1,true,true)
end

local function onLaunchDisplay()
    perk.showDisplayAds(PERK_ANDROID_DISPLAY_EVENT_ID)
end

local function onLaunchVideo()
    perk.showVideoAds(PERK_ANDROID_AD_EVENT_ID,3,true,true)
end


local function supportedCountryList()
    perk.fetchSupportedCountries()
end

local function onLoginButton()
    local ret = perk.launchLoginPage()
    if(ret == 1) then
        native.showAlert("Plugin Eevent","User is Already Loggedin.", { "OK" } )
    end
end

local function onLogoutButton()
    local ret = perk.isUserLoggedIn()
    if(ret == 1) then
        perk.logoutUser()
        native.showAlert("Plugin Eevent","User is logged out.", { "OK" } )
    else
        native.showAlert("Plugin Eevent","User not logged in.", { "OK" } )
    end
end


local function isUserLoggedIn()
   local ret = perk.isUserLoggedIn()
    print("CORONA isUserLoggedIn:",ret)
    displayText.text = tostring(ret)
end


local function onUnclaimedCountButton()
    perk.fetchNotifications()
end

local function onToggleSDKStatus()
    perk.toggleStatus( )
end


local function fetchUserPointsNumber()
    local ret = perk.isUserLoggedIn()
    if(ret == 1) then
        perk.fetchUserInfo()
    else
        native.showAlert("Plugin Eevent","User not logged in.", { "OK" } )
    end
end

------

local function onRedeemCall()
    print("i am here")
    perk.showPrizePage( )
end

local function onLaunchPrepaidPoints()
    perk.fetchPublisherPrepaidPoints()
end
----
local function onRetrieveSDKStatus()
    perk.getUserSDKStatus()
end

local options =
{
    --parent = textGroup,
    text = "Message Text",
    x = display.contentWidth/2,
    y = 10,
    width = 256,     --required for multi-line and alignment
    font = native.systemFontBold,
    fontSize = 12,
    align = "right"  --new alignment parameter
}
displayText = display.newText( options )
displayText:setFillColor( 1, 1, 1 )

local defaultFontSize = 12

local showPortalButton = widget.newButton {
    left = 50,
    top = 20,
    label = "Show Portal",
    fontSize = defaultFontSize,
    onRelease = onPortalButton,
}
showPortalButton.x = (display.contentWidth/2)

local loginButton = widget.newButton {
    left = 40,
    top = 60,
    width = 70,
    label = "Login",
    fontSize = defaultFontSize,
    onRelease = onLoginButton,
}

local logoutButton = widget.newButton {
    left = 120,
    top = 60,
    width = 70,
    label = "Logout",
    fontSize = defaultFontSize,
    onRelease = onLogoutButton,
}

local loginCheckButton = widget.newButton {
    left = 200,
    top = 60,
    width = 90,
    label = "Login Status",
    fontSize = defaultFontSize,
    onRelease = isUserLoggedIn,
}

local fetchUserPoints = widget.newButton {
    left = 20,
    top = 100,
    width = 100,
    label = "User Info",
    fontSize = defaultFontSize,
    onRelease = fetchUserPointsNumber,
}
fetchUserPoints.x = showPortalButton.x - 60

local showUnclaimedPageButton = widget.newButton {
    left = 120,
    top = 100,
    width = 100,
    label = "Unclaimed Page",
    fontSize = defaultFontSize,
    onRelease = onUnclaimedPage,
}
showUnclaimedPageButton.x = showPortalButton.x + 50

local trackEventButton = widget.newButton {
    left = 10,
    top = 140,
    label = "Track Event",
    fontSize = defaultFontSize,
    onRelease = onTrackEvent,
}


--------------------
local redeemButton = widget.newButton {
left = 150,
top = 140,
label = "Redeem Points",
fontSize = defaultFontSize,
onRelease = onRedeemCall,
}


--------------
local launchPrepaindPoints = widget.newButton {
left = 150,
top = 180,
label = "Prepaid Points",
onRelease = onLaunchPrepaidPoints,
fontSize = defaultFontSize,
}


--------------
local launchDatapointsButton = widget.newButton {
    left = 10,
    top = 180,
    label = "Show Survey",
    onRelease = onLaunchDatapoints,
    fontSize = defaultFontSize,
}


------
local launchAdbutton = widget.newButton {
    left = 10,
    top = 220,
    label = "Show Ad",
    onRelease = onLaunchAdbutton,
    fontSize = defaultFontSize,
}
launchAdbutton.x = showPortalButton.x

----
local launchDisplay = widget.newButton {
    left = 10,
    top = 260,
    label = "Show Display",
    onRelease = onLaunchDisplay,
    fontSize = defaultFontSize,
}
launchDisplay.x = showPortalButton.x
-----------
local launchVideo = widget.newButton {
    left = 10,
    top = 300,
    label = "Show Video",
    onRelease = onLaunchVideo,
    fontSize = defaultFontSize,
}
launchVideo.x = showPortalButton.x

-------------

toggleNotificationsButton = widget.newButton {
    left = 10,
    top = 340,
    label = "Supported Countries List",
    onRelease = supportedCountryList,
    fontSize = defaultFontSize,
}
toggleNotificationsButton.x = showPortalButton.x

local unclaimedCountButton = widget.newButton {
    left = 10,
    top = 380,
    label = "Unclaimed Count",
    fontSize = defaultFontSize,
    onRelease = onUnclaimedCountButton,
}
unclaimedCountButton.x = showPortalButton.x

local toggleSDKStatus = widget.newButton {
    left = display.contentWidth/3,
    top = 420,
    width = 100,
    label = "Toggle SDK Status",
    fontSize = defaultFontSize - 1,
    onRelease = onToggleSDKStatus,
}

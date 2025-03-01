function Angleur_SetTab1(self)
    local colorYello = CreateColor(1.0, 0.82, 0.0)
    local colorGrae = CreateColor(0.85, 0.85, 0.85)
    local colorBlu = CreateColor(0.61, 0.85, 0.92)
    self.baitEnable.text:SetText("Bait")
    self.baitEnable.disabledText:SetText("Couldn't find any bait \n in your bags, feature disabled")
    self.baitEnable:SetScript("OnClick", function(self)
        if self:GetChecked() then
            AngleurConfig.baitEnabled = true
            self.dropDown:Show()
        elseif self:GetChecked() == false then
            AngleurConfig.baitEnabled = false
            self.dropDown:Hide()
        end
    end)

    UIDropDownMenu_Initialize(self.baitEnable.dropDown, Angleur_InitializeDropDownBait)
    UIDropDownMenu_SetWidth(self.baitEnable.dropDown, 100)
    UIDropDownMenu_SetButtonWidth(self.baitEnable.dropDown, 124)
    UIDropDownMenu_SetSelectedID(self.baitEnable.dropDown, 1)
    UIDropDownMenu_JustifyText(self.baitEnable.dropDown, "LEFT")
    if AngleurConfig.baitEnabled == true then
        self.baitEnable:SetChecked(true)
        self.baitEnable.dropDown:Show()
    end
    Angleur_DropDown_CreateTitle(self.baitEnable.dropDown, "Bait")

    self.ultraFocus.audio.text:SetText("Audio")
    self.ultraFocus.audio.text:SetFontObject(SpellFont_Small)
    self.ultraFocus.audio.text:ClearAllPoints()
    self.ultraFocus.audio.text:SetPoint("LEFT", self.ultraFocus.audio, "RIGHT")
    self.ultraFocus.audio:SetScript("OnClick", function(self)
        if self:GetChecked() then
            AngleurConfig.ultraFocusAudioEnabled = true
            if AngleurCharacter.sleeping == false then
                Angleur_UltraFocusBackground(true)
            end
        elseif self:GetChecked() == false then
            AngleurConfig.ultraFocusAudioEnabled = false
            Angleur_UltraFocusAudio(false)
            Angleur_UltraFocusBackground(false)
        end
    end)
    if AngleurConfig.ultraFocusAudioEnabled == true then
        self.ultraFocus.audio:SetChecked(true)
    end

    self.ultraFocus.autoLoot.text:SetText("Temp. Auto Loot ")
    self.ultraFocus.autoLoot.text:SetFontObject(SpellFont_Small)
    self.ultraFocus.autoLoot.text:ClearAllPoints()
    self.ultraFocus.autoLoot.text:SetPoint("LEFT", self.ultraFocus.autoLoot, "RIGHT")
    self.ultraFocus.autoLoot.text.tooltip = "If checked, Angleur will temporarily turn on " .. colorYello:WrapTextInColorCode("Auto-Loot") .. ", then turn it back off after you reel.\n\n" 
    .. colorGrae:WrapTextInColorCode("If you have ") .. colorYello:WrapTextInColorCode("Auto-Loot ") .. colorGrae:WrapTextInColorCode("enabled anyway, this feature will be disabled automatically.")
    self.ultraFocus.autoLoot.disabledText:SetJustifyH("LEFT")
    self.ultraFocus.autoLoot.disabledText:SetWordWrap(true)
    self.ultraFocus.autoLoot.disabledText:SetText("(Already on)")
    self.ultraFocus.autoLoot.disabledText:ClearAllPoints()
    self.ultraFocus.autoLoot.disabledText:SetPoint("LEFT", self.ultraFocus.autoLoot.text, "RIGHT")
    self.ultraFocus.autoLoot:SetScript("OnClick", function(self)
        if self:GetChecked() then
            AngleurConfig.ultraFocusAutoLootEnabled = true
        elseif self:GetChecked() == false then
            AngleurConfig.ultraFocusAutoLootEnabled = false
        end
    end)
    if AngleurConfig.ultraFocusAutoLootEnabled == true then
        self.ultraFocus.autoLoot:SetChecked(true)
    end

    
    if AngleurConfig.angleurKey then 
        self.fishingMethod.oneKey.contents.angleurKey:SetText(AngleurConfig.angleurKey)
    elseif AngleurTutorial.part > 1 then
        self.fishingMethod.oneKey.contents.angleurKey.warning:Show()
    end
    
    self.fishingMethod.oneKey.icon:SetTexture("Interface/AddOns/AngleurClassic/images/onekeyicon.png")
    self.fishingMethod.doubleClick.icon:SetTexture("Interface/AddOns/AngleurClassic/images/doubleclickicon.png")

    UIDropDownMenu_Initialize(self.fishingMethod.doubleClick.contents.dropDownMenu, Angleur_InitializeDropDownDoubleClickSelection)
    UIDropDownMenu_SetWidth(self.fishingMethod.doubleClick.contents.dropDownMenu, 100)
    UIDropDownMenu_SetButtonWidth(self.fishingMethod.doubleClick.contents.dropDownMenu, 124)
    UIDropDownMenu_SetSelectedID(self.fishingMethod.doubleClick.contents.dropDownMenu, 1)
    UIDropDownMenu_JustifyText(self.fishingMethod.doubleClick.contents.dropDownMenu, "LEFT")
    

    Angleur_FishingMethodSetSelected(self.fishingMethod)

    local newFeatureFrame = CreateFrame("Frame", "Angleur_NewFeatureFrame", self.ultraFocus.offInteract)
    newFeatureFrame:SetPoint("RIGHT", self.ultraFocus.offInteract, "LEFT", 7, 0)
    newFeatureFrame:SetSize(48, 32)
    --newFeatureFrame:Raise()
    local newFeatureTexture = newFeatureFrame:CreateTexture("$parent_NewFeatureTexture", "ARTWORK", nil, 1)
    newFeatureTexture:SetPoint("CENTER")
    newFeatureTexture:SetSize(48, 32)
    newFeatureTexture:SetTexture("Interface/AddOns/AngleurClassic/images/newfeature.png")
end

function Angleur_FishingMethodSetSelected(self)
    local methods = {self:GetChildren()}
    for i, button in pairs(methods) do
        if AngleurConfig.chosenMethod == button:GetParentKey() then
            button.selectedTexture:Show()
            button.contents:Show()
        else
            button.selectedTexture:Hide()
            button.contents:Hide()
        end
    end
end

local stiffShownOnce = false
function Angleur_FishingMethodOnClick(self)
    PlaySoundFile(1020201)
    AngleurConfig.chosenMethod = self:GetParentKey()
    Angleur_FishingMethodSetSelected(self:GetParent())
    if AngleurConfig.chosenMethod == "doubleClick" then
        Angleur_RegisterAndHook()
        if stiffShownOnce then return end
        stiffShownOnce = true
        local color1 = CreateColor(1.0, 0.82, 0.0)
        local color2 = CreateColor(0.61, 0.85, 0.92)
        print(color2:WrapTextInColorCode("Angleur: ") .. "If you experience stiffness with the Double-Click, do a " .. color1:WrapTextInColorCode("/reload") .. " to fix it.")
    end
end

function Angleur_BaitDropDownOnClick(self)
    UIDropDownMenu_SetSelectedID(Angleur.configPanel.tab1.contents.baitEnable.dropDown, self:GetID())
    AngleurConfig.chosenBait.dropDownID = self:GetID()
    --AngleurConfig.chosenBait.name = angleurItems.ownedBait[self:GetID()].name --> Changed into the below for localisation
    AngleurConfig.chosenBait.itemID = angleurItems.ownedBait[self:GetID()].itemID
    Angleur_SetSelectedItem(angleurItems.selectedBaitTable, angleurItems.ownedBait, AngleurConfig.chosenBait.itemID)
end

function Angleur_DropDown_CreateTitle(self, titleText)
    local info = UIDropDownMenu_CreateInfo()
    info.text = titleText
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
end

local baitTitleSet = false
function Angleur_InitializeDropDownBait(self, level)
    if not baitTitleSet then
        Angleur_DropDown_CreateTitle(self, "Bait")
        baitTitleSet = true
        return
    end
    Angleur_CheckOwnedItems(angleurItems.selectedBaitTable, angleurItems.ownedBait, angleurItems.baitPossibilities)
    Angleur_SetSelectedItem(angleurItems.selectedBaitTable, angleurItems.ownedBait, AngleurConfig.chosenBait.itemID)
    --Contents
    for i, bait in pairs(angleurItems.ownedBait) do
        info = UIDropDownMenu_CreateInfo()
        info.text = bait.name
        info.value = bait.name
        info.func = Angleur_BaitDropDownOnClick
        UIDropDownMenu_AddButton(info)
    end
    UIDropDownMenu_SetSelectedID(Angleur.configPanel.tab1.contents.baitEnable.dropDown, angleurItems.selectedBaitTable.dropDownID)
end

function Angleur_DoubleClickSelectionDropDownOnClick(self)
    UIDropDownMenu_SetSelectedID(Angleur.configPanel.tab1.contents.fishingMethod.doubleClick.contents.dropDownMenu, self:GetID())
    AngleurConfig.doubleClickChosenID = self:GetID()
end

function Angleur_InitializeDropDownDoubleClickSelection(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "Preferred Mouse Button"
    info.isTitle = true
    UIDropDownMenu_AddButton(info)
    --[[
    info = UIDropDownMenu_CreateInfo()
    info.text = "Left Click"
    info.value = "Left Click"
    info.func = Angleur_DoubleClickSelectionDropDownOnClick
    UIDropDownMenu_AddButton(info)
    ]]--
    info = UIDropDownMenu_CreateInfo()
    info.text = "Right Click"
    info.value = "Right Click"
    info.func = Angleur_DoubleClickSelectionDropDownOnClick
    UIDropDownMenu_AddButton(info)
    UIDropDownMenu_SetSelectedID(Angleur.configPanel.tab1.contents.fishingMethod.doubleClick.contents.dropDownMenu, AngleurConfig.doubleClickChosenID)
end
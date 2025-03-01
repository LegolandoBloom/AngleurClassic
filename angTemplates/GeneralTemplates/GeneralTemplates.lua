Angleur_CheckboxMixin = {};

function Angleur_CheckboxMixin:greyOut()
    self:SetChecked(false)
    self:Disable()
    self.text:SetTextColor(0.9, 0.9, 0.9)
    self.disabledText:Show()
    if self.dropDown then
        self.dropDown:Hide()
    end
end


Angleur_CombatWeaponSwapButtonMixin = {};

function Angleur_CombatWeaponSwapButtonMixin:setMacro(swapTable)
    if not swapTable or next(swapTable) == nil then return end
    local _, firstItemID = next(swapTable)
    local macroBody = ""
    for location, itemID in pairs(swapTable) do
        local GUID = C_TooltipInfo.GetOwnedItemByID(itemID).guid
        if GUID then
            local name = C_Item.GetItemName(C_Item.GetItemLocation(GUID))
            Angleur_BetaPrint("Angleur_CombatWeaponSwapButtonMixin: ", name)
            macroBody = macroBody .. "/equipslot " .. location .. " " .. name
        end
    end
    if not macroBody or not firstItemID then return end
    self.icon:SetTexture(C_Item.GetItemIconByID(firstItemID))
    self:SetAttribute("macrotext", macroBody)
    self:Show()
    Angleur_BetaPrint("Angleur_CombatWeaponSwapButtonMixin:setMacro: MACRO TEXT" , macroBody)
end


--********************************************************
--*TEMPLATES PORTED DIRECTLY FROM BLIZZ RETAIL TO CLASSIC*
--********************************************************

AngleurClassic_NumericInputBoxMixin = {};
function AngleurClassic_NumericInputBoxMixin:OnTextChanged(isUserInput)
	self.valueChangedCallback(self:GetNumber(), isUserInput);
end
function AngleurClassic_NumericInputBoxMixin:OnEditFocusLost()
	EditBox_ClearHighlight(self);
	self.valueFinalizedCallback(self:GetNumber());
end
function AngleurClassic_NumericInputBoxMixin:SetOnValueChangedCallback(valueChangedCallback)
	self.valueChangedCallback = valueChangedCallback;
end
function AngleurClassic_NumericInputBoxMixin:SetOnValueFinalizedCallback(valueFinalizedCallback)
	self.valueFinalizedCallback = valueFinalizedCallback;
end

AngleurClassic_SliderControlFrameMixin = {};
function AngleurClassic_SliderControlFrameMixin:OnEnter()
end
function AngleurClassic_SliderControlFrameMixin:OnLeave()
end
function AngleurClassic_SliderControlFrameMixin:SetupSlider(minValue, maxValue, value, valueStep, label)
	self.minValue = minValue;
	self.maxValue = maxValue;
	self.Slider:SetMinMaxValues(minValue, maxValue);
	self.valueStep = valueStep;
	self.Slider:SetValueStep(valueStep);
	self.value = value;
	self.Slider:SetValue(value);
	self.Label:SetText(label);
end
function AngleurClassic_SliderControlFrameMixin:OnSliderValueChanged(value, userInput)
	-- Override in your mixin.
end
AngleurClassic_SliderWithButtonsAndLabelMixin = CreateFromMixins(AngleurClassic_SliderControlFrameMixin);
function AngleurClassic_SliderWithButtonsAndLabelMixin:OnSliderValueChanged(value, userInput)
	-- Overrides AngleurClassic_SliderControlFrameMixin.
	self.value = value;
	self.IncrementButton:SetEnabled(value < self.maxValue);
	self.DecrementButton:SetEnabled(value > self.minValue);
end
function AngleurClassic_SliderWithButtonsAndLabelMixin:Increment()
	local userInput = true;
	self.Slider:SetValue(self.value + self.valueStep, userInput);
end
function AngleurClassic_SliderWithButtonsAndLabelMixin:Decrement()
	local userInput = true;
	self.Slider:SetValue(self.value - self.valueStep, userInput);
end
AngleurClassic_SliderAndEditControlMixin = CreateFromMixins(AngleurClassic_SliderControlFrameMixin);
function AngleurClassic_SliderAndEditControlMixin:SetupSlider(minValue, maxValue, value, valueStep, label)
	AngleurClassic_SliderControlFrameMixin.SetupSlider(self, minValue, maxValue, value, valueStep, label);
	self.ValueBox:SetNumber(value);
	local function ValueBoxFinalizedCallback(valueBoxValue)
		local isUserInput = true;
		self:SetValue(valueBoxValue, isUserInput);
	end
	self.ValueBox:SetOnValueFinalizedCallback(ValueBoxFinalizedCallback);
end
function AngleurClassic_SliderAndEditControlMixin:OnSliderValueChanged(value, isUserInput)
	-- Overrides AngleurClassic_SliderControlFrameMixin.
	self.ValueBox:SetNumber(value);
	if self.callback ~= nil then
		self.callback(value, isUserInput);
	end
end
function AngleurClassic_SliderAndEditControlMixin:SetValue(value, isUserInput)
	self.Slider:SetValue(Clamp(value, self.minValue, self.maxValue), isUserInput);
end
function AngleurClassic_SliderAndEditControlMixin:SetCallback(callback)
	self.callback = callback;
end

---------------------------------------------------------------------------------------------------------------------------------------------

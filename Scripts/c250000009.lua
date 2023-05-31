--Clear Wing Dragon 5
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff) and aux.TargetBoolFunction(Card.IsLevelBelow,5))
	c:RegisterEffect(e1)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(250000009,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11234703)
	e1:SetTarget(c250000009.lvtg)
	e1:SetOperation(c250000009.lvop)
	c:RegisterEffect(e1)
end
function c250000009.filter(c)
	return c:IsSetCard(0xff) and c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()<5
end
function c250000009.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c250000009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c250000009.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c250000009.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c250000009.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=1
		if tc:IsLevel(1) then
			sel=Duel.SelectOption(tp,aux.Stringid(250000009,1))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(250000009,1),aux.Stringid(250000009,2))
		end
		if sel==1 then
			lvl=2
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

--Clear Wing
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--non tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TUNER)
	e1:SetValue(c250000007.tnval)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,250000007)
	e2:SetTarget(c250000007.lvtg)
	e2:SetOperation(c250000007.lvop)
	c:RegisterEffect(e2)
	--special summon rule  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_SPSUMMON_PROC)  
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,250000007)
	e3:SetCondition(c250000007.sprcon)  
	c:RegisterEffect(e3)
end
function c250000007.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c250000007.filter(c)
	return c:IsSetCard(0xff) and c:IsFaceup() and c:GetLevel()>2
end
function c250000007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c250000007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c250000007.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c250000007.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c250000007.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local t={}
		for i=-2,2 do
			if tc:GetLevel()-i>0 then table.insert(t,i) end
		end
		if #t==0 then return end
		local lv=Duel.AnnounceNumber(tp,table.unpack(t))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-lv)
		tc:RegisterEffect(e1)
	end
end
function c250000007.sprcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
end 
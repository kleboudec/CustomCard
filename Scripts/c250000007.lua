--Clear Wing
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--non tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(250000007,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TUNER)
	e1:SetValue(c250000007.tnval)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(250000007,1))
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
	return c:IsSetCard(0xff) and c:IsFaceup() and c:GetLevel()>0
end
function c250000007.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c250000007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c250000007.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c250000007.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c250000007.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=1
		if tc:IsLevel(1) then
			sel=Duel.SelectOption(tp,aux.Stringid(250000007,1))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(250000007,1),aux.Stringid(250000007,2))
		end
		if sel==1 then
			lvl=-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c250000007.sprcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
end 
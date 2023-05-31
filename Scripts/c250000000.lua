--Dragunity - Malleus
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c250000000.synlimit)
	c:RegisterEffect(e1)
	--special summon rule  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SPSUMMON_PROC)  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c250000000.sprcon)  
	c:RegisterEffect(e2)
	--special summon(self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(250000000,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c250000000.sptg2)
	e3:SetOperation(c250000000.spop2)
	c:RegisterEffect(e3)
end
function c250000000.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_DRAGON)
end
function c250000000.sprcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
end  
function c250000000.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c250000000.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
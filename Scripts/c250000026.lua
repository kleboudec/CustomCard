--Dance of the Sun and Moon
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,250000026+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c250000026.condition)
	e1:SetTarget(c250000026.target)
	e1:SetOperation(c250000026.activate)
	c:RegisterEffect(e1)
end
function c250000026.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c250000026.filter(c,e,tp)
	return ((c:IsType(TYPE_TUNER)and c:IsSetCard(0xe3f))or c:IsCode(78552773) or c:IsCode(78275321)) or (c:IsRace(RACE_SPELLCASTER) and c:IsLevel(5)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c250000026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c250000026.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:CheckSubGroup(aux.gffcheck,2,2,Card.IsType,TYPE_TUNER,Card.IsRace,RACE_SPELLCASTER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c250000026.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c250000026.scfilter(c,mg)
	return c:IsRace(RACE_DRAGON) and c:IsSynchroSummonable(nil,mg)
end
function c250000026.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetTargetRange(1,0)
		e3:SetTarget(c250000026.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(c250000026.filter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.gffcheck,false,2,2,Card.IsType,TYPE_TUNER,Card.IsRace,RACE_SPELLCASTER)
	if not sg then return end
	local ca=sg:GetFirst()
	local cb=sg:GetNext()
	local success=false
	if Duel.SpecialSummonStep(ca,0,tp,tp,false,false,POS_FACEUP) and Duel.SpecialSummonStep(cb,0,tp,tp,false,false,POS_FACEUP) then
		success=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ca:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ca:RegisterEffect(e2)
		local e3=e1:Clone()
		cb:RegisterEffect(e3)
		local e4=e2:Clone()
		cb:RegisterEffect(e4)
	end
	Duel.SpecialSummonComplete()
	local mg=Duel.GetSynchroMaterial(tp):Filter(Card.IsSetCard,nil,0xe3f)
	if success and Duel.IsExistingMatchingCard(c250000026.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c250000026.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
		and Duel.SelectYesNo(tp,aux.Stringid(250000026,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c250000026.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst()
		Duel.SynchroSummon(tp,tc,nil,mg)
	end
end
function c250000026.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
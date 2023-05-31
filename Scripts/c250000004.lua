--
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(250000004,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,250000004)
	e1:SetCondition(c250000004.discon)
	e1:SetCost(c250000004.discost)
	e1:SetTarget(c250000004.distg)
	e1:SetOperation(c250000004.disop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,250000004)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c250000004.eqcon)
	e2:SetTarget(c250000004.eqtg)
	e2:SetOperation(c250000004.eqop)
	c:RegisterEffect(e2)
	--Send equip to shuffle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,250000004)
	e3:SetTarget(c250000004.shtg)
	e3:SetCost(c250000004.shcost)
	e3:SetOperation(c250000004.shop)
	c:RegisterEffect(e3)
end


--negate
function c250000004.nfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x29) and c:IsAbleToRemoveAsCost()
end
function c250000004.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c250000004.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c250000004.nfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c250000004.nfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c250000004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c250000004.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end


--equip
function c250000004.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function c250000004.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c250000004.cfilter,1,nil,tp)
end
function c250000004.chkfilter(c,tp)
	return not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c250000004.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c250000004.chkfilter(c,tp)
end
function c250000004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c250000004.filter,nil,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=#g end
	Duel.SetTargetCard(g)
end
function c250000004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(aux.NecroValleyFilter(c250000004.chkfilter),nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsFaceup() and c:IsRelateToEffect(e) and #g>0 and ft>0 then
		local sg=nil
		if #g>ft then
			sg=g:Select(tp,ft,ft,nil)
		else
			sg=g
		end
		local tc=sg:GetFirst()
		while tc do
			if Duel.Equip(tp,tc,c,true,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c250000004.eqlimit)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c250000004.eqlimit(e,c)
	return e:GetOwner()==c
end

--Send equip to shuffle
function c250000004.sheqfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c250000004.shfilter(c)
	return c:IsSetCard(0x29) and c:IsAbleToDeck()
end
function c250000004.shtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c250000004.shfilter(chkc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c250000004.shfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c250000004.shcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,c250000004.sheqfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	return true
end
function c250000004.shop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
end
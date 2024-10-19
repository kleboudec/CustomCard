--Temple of the Sun and Moon
local s,id,o=GetID()
function s.initial_effect(c)
	--Activation
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Add a monster from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,250000023)
	e1:SetTarget(c250000023.thtg)
	e1:SetOperation(c250000023.thop)
	c:RegisterEffect(e1)
end

function c250000023.thfilter(c)
	return (c:IsSetCard(0xbfa) or c:IsCode(17315396) or c:IsCode(71821687)) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
end
function c250000023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c250000023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c250000023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c250000023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #hg==0 or Duel.SendtoHand(hg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,hg)
	Duel.ShuffleHand(tp)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if #dg>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(dg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
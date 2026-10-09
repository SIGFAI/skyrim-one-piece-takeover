Scriptname SigfMod extends Quest
{One Piece Takeover: the Grand Line arrives in Riverwood. The hero wears the straw hat and can stretch a rubber fist,
the villagers put on straw hats too, and Wanted posters of the Straw Hat Dragonborn go up around the village.}

Armor Property SigfStrawHat Auto
Spell Property SigfGumPistol Auto
Static Property SigfWantedPoster Auto
Weather Property SkyrimClearSN Auto
Quest Property SigfDemoQuest Auto
bool started = false
bool demoDone = false
int tick = 0

Event OnInit()
	if IsRunning()
		RegisterForSingleUpdate(2.0)
	endif
EndEvent

Event OnUpdate()
	Actor p = Game.GetPlayer()
	if started
		; The recording pilot draws the hero's weapon (R) when the clip starts: that starts the demo without console text.
		if p.IsWeaponDrawn() && !SigfDemoQuest.IsRunning() && !demoDone
			demoDone = true
			SigfDemoQuest.Start()
		endif
		tick += 1
		if tick >= 16
			tick = 0
			SkyrimClearSN.ForceActive(true)
		endif
		RegisterForSingleUpdate(0.5)
		return
	endif
	if !p.Is3DLoaded()
		RegisterForSingleUpdate(1.0)
		return
	endif
	started = true
	SkyrimClearSN.ForceActive(true)
	Utility.Wait(3.0)
	p.AddItem(SigfStrawHat, 1, true)
	p.EquipItem(SigfStrawHat, false, true)
	p.AddSpell(SigfGumPistol, false)
	HatVillagers(p)
	PostPosters(p)
	SigfLib.Say("The Grand Line has arrived!")
	RegisterForSingleUpdate(0.5)
EndEvent

; Everybody nearby gets a straw hat.
Function HatVillagers(Actor p)
	int i = 0
	while i < 30
		Actor a = Game.FindRandomActor(p.GetPositionX(), p.GetPositionY(), p.GetPositionZ(), 3500.0)
		if a && a != p && !a.IsDead() && a.GetItemCount(SigfStrawHat) == 0
			a.AddItem(SigfStrawHat, 1, true)
			a.EquipItem(SigfStrawHat, false, true)
		endif
		i += 1
	endwhile
EndFunction

; Wanted posters standing around the player's starting spot.
Function PostPosters(Actor p)
	float pa = p.GetAngleZ()
	int k = 0
	while k < 3
		ObjectReference po = SigfLib.Place(SigfWantedPoster, "poster", 380.0 + 140.0 * k, -300.0 + 300.0 * k)
		if po
			po.SetScale(1.5)
			po.SetAngle(0.0, 0.0, pa + 90.0)
		endif
		k += 1
	endwhile
EndFunction

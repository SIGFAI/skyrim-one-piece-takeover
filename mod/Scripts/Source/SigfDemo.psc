Scriptname SigfDemo extends Quest
{The demo: the Navy attacks the straw-hat hero, Gum-Gum punches, raining meat, Gear Fourth, a giant of Elbaf.}

ActorBase Property SigfMarine Auto
ActorBase Property SigfGiant Auto
Static Property SigfGumFistStatic Auto
Static Property SigfJollyFlag Auto
Explosion Property SigfGumImpact Auto
Potion Property SigfMangaMeat Auto
EffectShader Property EnchArmorFireFXS Auto
Sound Property WPNBowFire Auto
Sound Property NPCGiantAttackStomp Auto
MusicType Property MUSCombatBoss Auto

Event OnInit()
	if IsRunning()
		RegisterForSingleUpdate(0.5)
	endif
EndEvent

Event OnUpdate()
	Debug.Trace("SIGF_DEMO start")
	Actor p = Game.GetPlayer()
	float h0 = p.GetAngleZ()
	p.SetAngle(0.0, 0.0, h0 + 40.0)
	MUSCombatBoss.Add()

	; Jolly Roger flags planted around the fight
	ObjectReference fl = SigfLib.Place(SigfJollyFlag, "flag", 850.0, -420.0)
	fl.SetScale(1.6)
	fl.SetAngle(0.0, 0.0, p.GetAngleZ() + 90.0)
	ObjectReference f2 = SigfLib.Place(SigfJollyFlag, "flag", 1000.0, 520.0)
	f2.SetScale(1.6)
	f2.SetAngle(0.0, 0.0, p.GetAngleZ() + 90.0)

	; 1. the Navy attacks right away
	SigfLib.Say("Marines! The Navy found the Straw Hat!")
	Actor[] m = new Actor[5]
	m[0] = SigfLib.Spawn(SigfMarine, "marine", 520.0, -130.0)
	m[1] = SigfLib.Spawn(SigfMarine, "marine", 600.0, 130.0)
	m[2] = SigfLib.Spawn(SigfMarine, "marine", 700.0, -300.0)
	m[3] = SigfLib.Spawn(SigfMarine, "marine", 760.0, 20.0)
	m[4] = SigfLib.Spawn(SigfMarine, "marine", 840.0, 260.0)
	int i = 0
	while i < 5
		m[i].StartCombat(p)
		i += 1
	endwhile
	SigfLib.Look(m[0])
	Utility.Wait(1.0)

	; 2. Gum-Gum Pistol, one Marine at a time
	SigfLib.Mark("cast")
	i = 0
	while i < 5
		SigfLib.Say("Gum-Gum Pistol!")
		SigfGum.Punch(p, m[i], SigfGumFistStatic, SigfGumImpact, WPNBowFire, NPCGiantAttackStomp, 1.5, 140.0)
		Utility.Wait(0.6)
		i += 1
	endwhile
	Utility.Wait(0.5)

	; 3. it rains giant meat right in front of the hero
	SigfLib.Say("MEAT!")
	i = 0
	while i < 5
		ObjectReference r = SigfLib.Place(SigfMangaMeat, "meat", 220.0 + 40.0 * i, -200.0 + 100.0 * i, 650.0)
		if r
			r.SetScale(7.0)
		endif
		Utility.Wait(0.3)
		i += 1
	endwhile
	Utility.Wait(2.5)
	SigfLib.Say("Gear Fourth!")
	EnchArmorFireFXS.Play(p, 14.0)
	SigfLib.Shake(0.8, 1.0)
	SigfGum.Bounce(p, 1.4, 5)

	; 4. a giant of Elbaf storms in
	SigfLib.Say("A giant of Elbaf storms the docks!")
	SigfLib.Mark("giant")
	Actor d = SigfLib.Spawn(SigfGiant, "giant", 560.0, 60.0)
	d.SetScale(1.3)
	d.SetActorValue("Health", 600.0)
	d.StartCombat(p)
	SigfLib.Look(d)
	Utility.Wait(2.0)
	i = 0
	while i < 5 && !d.IsDead()
		SigfLib.Say("Gum-Gum Bazooka!")
		SigfGum.Punch(p, d, SigfGumFistStatic, SigfGumImpact, WPNBowFire, NPCGiantAttackStomp, 3.0, 130.0)
		Utility.Wait(0.8)
		i += 1
	endwhile
	if !d.IsDead()
		d.Kill(p)
	endif
	Utility.Wait(1.0)
	SigfLib.Say("I'm gonna be King of the Pirates!")
	Utility.Wait(8.0)
	p.SetScale(1.0)
	Debug.Trace("SIGF_DEMO end")
EndEvent

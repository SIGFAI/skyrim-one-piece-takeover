Scriptname SigfGum Hidden
{Gum-Gum punches: a giant rubber fist on a stretching arm flies from the hero and slams the target away.}

; size = scale of the fist model (the arm trailing behind it is about 330 units long at scale 1).
Function Punch(Actor src, Actor tgt, Static fistModel, Explosion hit, Sound whoosh, Sound boom, float size = 2.2, float damage = 70.0, float sideAng = 50.0) global
	float h = src.GetAngleZ() + src.GetHeadingAngle(tgt)
	; the hero turns away from the target so the camera sees the whole stretched arm from the side
	src.SetAngle(0.0, 0.0, h + sideAng)
	ObjectReference f = src.PlaceAtMe(fistModel)
	f.SetScale(size)
	f.MoveTo(src, 50.0 * Math.Sin(h), 50.0 * Math.Cos(h), 105.0)
	f.SetAngle(0.0, 0.0, h)
	int n = 0
	while !f.Is3DLoaded() && n < 20
		Utility.Wait(0.05)
		n += 1
	endwhile
	whoosh.Play(src)
	float dx = tgt.GetPositionX() - f.GetPositionX()
	float dy = tgt.GetPositionY() - f.GetPositionY()
	float dist = Math.sqrt(dx * dx + dy * dy)
	float speed = 1100.0
	f.TranslateTo(tgt.GetPositionX(), tgt.GetPositionY(), tgt.GetPositionZ() + 95.0, 0.0, 0.0, h, speed)
	Utility.Wait(dist / speed)
	boom.Play(tgt)
	tgt.PlaceAtMe(hit)
	if !tgt.IsDead()
		tgt.DamageActorValue("Health", damage)
		tgt.PushActorAway(tgt, 8.0)
	endif
	SigfLib.Shake(0.9, 0.7)
	; the arm snaps back
	f.TranslateTo(src.GetPositionX(), src.GetPositionY(), src.GetPositionZ() + 105.0, 0.0, 0.0, h, speed * 2.0)
	Utility.Wait(0.5)
	f.Delete()
EndFunction

; Gear Fourth: the hero inflates and bounces like rubber.
Function Bounce(Actor who, float big = 1.4, int times = 5) global
	int i = 0
	while i < times
		who.SetScale(big)
		Utility.Wait(0.18)
		who.SetScale(big * 0.78)
		Utility.Wait(0.14)
		i += 1
	endwhile
	who.SetScale(big)
EndFunction

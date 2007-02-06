#include "_gen"


void SingleUse();

// Returns true if used on himself
int SelfOnly();


void NotifyEat();

void NothingHappens();

// Allow only one item effect on oTarget at a time.
// Returns true if the user is allowed to use this herb.
int OneAtATime(object oTarget, float fDuration);

void main() {
	object
	oPC = GetItemActivator(),
	oHerb = OBJECT_SELF,
	oTarget = GetItemActivatedTarget();
	string
	sTag = GetTag(oHerb);

	location
	lTarget = GetItemActivatedTargetLocation();


	float fDuration = 5.0 * 30.0;
	fDuration += ( -60.0 + IntToFloat(Random(120)) );

	int nHerb = StringToInt(GetStringRight(sTag, 3));

	switch ( nHerb ) {
		// Aschekraut
		case 2:
			if ( !SelfOnly() )
				break;

			NotifyEat();

			if ( OneAtATime(oTarget, fDuration) ) {
				ApplyEffectToObject(DTT, EffectSavingThrowIncrease(SAVING_THROW_FORT, 1), oTarget, fDuration);
			}

			SingleUse();
			break;

			// Campina
		case 4:
			if ( !SelfOnly() )
				break;

			NotifyEat();

			ApplyEffectToObject(DTT, EffectDazed(), oTarget, 23.0);

			SingleUse();
			break;

			// Felspilz
		case 6:
			if ( !SelfOnly() )
				break;

			NotifyEat();

			if ( OneAtATime(oTarget, fDuration) ) {
				ApplyEffectToObject(DTT, EffectAbilityDecrease(ABILITY_DEXTERITY, d3()), oTarget, fDuration);
				ApplyEffectToObject(DTT, EffectAbilityDecrease(ABILITY_STRENGTH, d3()), oTarget, fDuration);
			}

			SingleUse();
			break;


			// Maraichpilz
		case 10:
			if ( !SelfOnly() )
				break;

			NotifyEat();
			if ( !FortitudeSave(oTarget, 18, SAVING_THROW_TYPE_POISON) )
				ApplyEffectToObject(DTT, EffectUnconscious(), oTarget, fDuration / 1.8);

			SingleUse();
			break;

			// Nachtmoos
		case 11:
			SingleUse();

			if ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE ) {
				int nHitPoints = GetCurrentHitPoints(oTarget);

				//negative hitPoints will be stabilized
				if ( nHitPoints < 0 ) {
					int nHealSkill = GetSkillRank(SKILL_HEAL, oPC);
					AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
					if ( d20() + nHealSkill >= 16 ) {
						int nHealPoints = 1 - nHitPoints;
						if ( nHealSkill < nHealPoints ) {
							nHealPoints = nHealSkill;
						}
						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealPoints), oTarget);
						AssignCommand(oPC, ActionSpeakString("*Stillt die Blutungen von " +
								GetName(oTarget) + "*", TALKVOLUME_TALK));
						break;
					} else {
						AssignCommand(oPC, ActionSpeakString("*Versucht vergeblich die Blutung von " +
								GetName(oTarget) + " zu stoppen*", TALKVOLUME_TALK));
						break;
					}
				}

			}

			NothingHappens();

			break;


		case 12: // Nrarom
			if ( !SelfOnly() )
				break;

			NotifyEat();

			ActionCastSpellAtObject(SPELL_CURE_MINOR_WOUNDS, oTarget);

			SingleUse();
			break;


			// Venumon
		case 15:
			if ( !SelfOnly() )
				break;

			NotifyEat();

			if ( !FortitudeSave(oTarget, 18, SAVING_THROW_TYPE_POISON) ) {
				ApplyEffectToObject(DTT, EffectDisease(DISEASE_MINDFIRE), oTarget, fDuration);
				Floaty("Das Venumon-Gift greift auf Euch.", oTarget, 1);
			}

			SingleUse();
			break;

			// Waldkraut
		case 16:
			if ( !SelfOnly() )
				break;

			NotifyEat();

			Floaty("Ein wuerziger, leicht bitterer Geschmack bleibt zurueck.", oPC, 0);

			SingleUse();
			break;

			//case 25: // Holy water
			/*if (GetIsObjectValid(oTarget))
			 * 	ActionCastSpellAtObject(
			 * else
			 * 	ActionCastSpellAtLocation(SPELL_HOLY_WATER, lTarget);
			 *
			 * DestroyObject(oItem);*/
			//    break;


			// Hopfen
		case 47:

			break;

		default:
			NothingHappens();
			break;
	}
}



void NotifyEat() {
	object oHerb = OBJECT_SELF;
	object oPC = GetItemActivator();
	Floaty("Ihr knabbert an " + GetName(oHerb) + " ..", oPC, 1);
}


void NothingHappens() {
	object oPC = GetItemActivator();
	Floaty("Nichts passiert.", oPC, 0);
}


int OneAtATime(object oTarget, float fDuration) {
	object
	oHerb = OBJECT_SELF;
	string
	sTag = GetTag(oHerb);

	if ( GetLocalInt(oTarget, "f_" + sTag) )
		return 0;
	else {
		SetLocalInt(oTarget, "f_" + sTag, 1);
		DelayCommand(fDuration, DeleteLocalInt(oTarget, "f_" + sTag));
		return 1;
	}
}


void SingleUse() {
	if ( GetItemStackSize(OBJECT_SELF) > 1 )
		SetItemStackSize(OBJECT_SELF, GetItemStackSize(OBJECT_SELF) - 1);
	else
		DestroyObject(OBJECT_SELF);
}


int SelfOnly() {
	object
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();

	if ( oTarget != oPC ) {
		Floaty("Ihr koennt dieses Kraut nur selbst essen.", oPC);
		return 0;
	}

	return 1;
}

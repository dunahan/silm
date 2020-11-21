//::///////////////////////////////////////////////
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Check to see if the PC has SPELL_RAY_OF_ENFEEBLEMENT
  memorized...
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: June 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    if (GetHasSpell(
       SPELL_RAY_OF_ENFEEBLEMENT
      , GetPCSpeaker()) > 0)
        return TRUE;
    return FALSE;
}

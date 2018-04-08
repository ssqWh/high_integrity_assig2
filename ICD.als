module ICDSystem

sig Tick { nextTick : lone Tick}

sig HeartRate {}
sig RateHistory {r1, r2, r3, r4, r5, r6, r7 : HeartRate -> Tick}

-- system mode on/off
abstract sig SystemMode {}
one sig OnMode extends SystemMode {}
one sig OffMode extends SystemMode {}

-- joule of impulse
abstract sig HeartImpulse {}
one sig VFImpulse extends HeartImpulse {}
one sig TachyImpulse extends HeartImpulse {}
one sig NoImpulse extends HeartImpulse {}

-- operator roles
abstract sig Role {}
sig Patient extends Role {}
sig Cardiologist extends Role {}
sig ClinicalAssistant extends Role {}
sig Unknown extends Role {}

-- upper bound of tachy
one sig UpperBound in HeartRate {}

-- whether is vf
abstract sig IfVF {}
one sig IsVF extends IfVF {}
one sig NotVF extends IfVF {}

-- heart rate monitor
sig HeartRateMonitor {
	rate : lone HeartRate -> one Tick,
	mode : one SystemMode
}

-- impulse generator
sig ImpulseGenerator {
	impulses : some HeartImpulse -> some Tick,
	mode : one SystemMode
}

-- network messages
abstract sig NetworkMessage {}
-- networks request
sig NetworkMessageReq extends NetworkMessage {}
sig ModeOn extends NetworkMessageReq {}
sig ModeOff extends NetworkMessageReq {}
sig ReadRateHistoryRequest extends NetworkMessageReq {}
sig ChangeSettingsRequest extends NetworkMessageReq {}
sig ReadSettingsRequest extends NetworkMessageReq {}
sig NetworkRequest{
	request : lone NetworkMessageReq
}
-- network response
sig NetworkMessageResp extends NetworkMessage {}
sig ReadRateHistoryResponse extends NetworkMessageResp {}
sig ReadSettingsResponse extends NetworkMessageResp {}
sig ChangeSettingsResponse extends NetworkMessageResp {}

sig Authorization {
	msg : Role -> NetworkMessageReq
}
pred checkAuth [role : Role, auth : Authorization]{
	r in auth.msg[role]
}

pred checkTachy [hrm : HeartRateMonitor, ub : UpperBound] {
	hrm.rate >= ub
}




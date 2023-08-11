#precache( "eventstring", "setSaveData" );
#precache( "eventstring", "getSaveData" );

/@
"Name: zmSaveData::setSaveData( <index>, <value> )"
"Summary: Saves a value on a specific index."
"Module: zmSaveData"
"CallOn: self : The player"
"MandatoryArg: <index> : The index that the value will be stored on. (0-719)"
"MandatoryArg: <value> : The value we want to store. (0-255)"
"Example: player zmSaveData::setSaveData(3, 30);"
@/
function setSaveData(index, value) {
	index *= 2;
	index += 50;
	if(!isdefined(self)) {
		IPrintLnBold("SaveData needs player");
		return;
	}
	if(!isdefined(index) || !isdefined(value)) {
		IPrintLnBold("SaveData needs an index and a value");
		return;
	}
	if(index < 0 || index > 330){
		IPrintLnBold("SaveData value only supports indexes 0-330");
		return;
	}
	if(value < 0) {
		IPrintLnBold("SaveData value only supports values bigger than 0");
		return;
	}
	
	remainder = value % 255;
	multiples = Int(Floor(value / 255));
	self LUINotifyEvent( &"setSaveData", 2, index, multiples);
	self LUINotifyEvent( &"setSaveData", 2, index + 1, remainder);
}

/@
"Name: zmSaveData::getSaveData( <index> )"
"Summary: Gets a saved value on a specific index."
"Module: zmSaveData"
"CallOn: self : The player"
"MandatoryArg: <index> : The index that we want the value of. (0-719)"
"Example: player zmSaveData::getSaveData(3);"
@/
function getSaveDataFromLua(index) {
	self LUINotifyEvent( &"getSaveData", 1, index);
	while(1) {
		self waittill("menuresponse", menu, response);
		if(Int(GetSubStr(response, 0, (index + "").size)) == index) {
			return Int(GetSubStr(response, (index + "").size + 1));
		}
	}
}

function getSaveData(index) {
	if(index != 300) {
		index *= 2;
		index += 50;
		if(!isdefined(self)) {
			IPrintLnBold("SaveData needs player");
			return;
		}
		if(!isdefined(index)) {
			IPrintLnBold("SaveData needs an index");
			return;
		}
		if(index < 0 || index > 330){
			IPrintLnBold("SaveData value only supports indexes 0-330");
			return;
		}

		m = getSaveDataFromLua(index);
		
		remainder = getSaveDataFromLua(index + 1);
		result = (255 * m) + remainder;
		
		return result;
	} else {
		index *= 2;
		index += 50;

		m65025 = getSaveDataFromLua(index);
		m255 = getSaveDataFromLua(index + 1);
		r = getSaveDataFromLua(index + 2);
		result = (65025 * m65025) + (255 * m255) + r;
		
		return result;
	}
	
}

function getSaveDataFloat(index) {
	if(index != 300) {
		index *= 2;
		index += 50;
		if(!isdefined(self)) {
			IPrintLnBold("SaveData needs player");
			return;
		}
		if(!isdefined(index)) {
			IPrintLnBold("SaveData needs an index");
			return;
		}
		if(index < 0 || index > 330){
			IPrintLnBold("SaveData value only supports indexes 0-330");
			return;
		}

		m = getSaveDataFromLua(index);
		
		remainder = getSaveDataFromLua(index + 1);
		
		result = (255 * m) + remainder;
		
		return result / 100;
	} 
	
}
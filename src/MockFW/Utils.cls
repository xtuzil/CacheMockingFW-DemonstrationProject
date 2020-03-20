Class MockFW.Utils Extends %RegisteredObject
{

ClassMethod CutExtraQuotes(string As %String)
{
	set n = $Length(string)
	set result = ""
	For i=1:1:n {
		Set piece = $Extract(string,i, i)
		if piece = """" {
			if $Extract(string,i+1, i+1) = """" {
				set result = result_piece
			}
		} else {
			set result = result_piece	
		}
	}
	
	return result
}

ClassMethod Compare(savedObject, params)
{
	//todo: Prvne overit, jestli je pocet atributu stejny
	// potom Pres jeden iterator vzit vzdy atribut z jednoho, zeptat se, jestli ten kez existuje i ve druhzm a pak porovnat value obou.
	// problem se slozitejsima dat. typama, jak to resit?
	
	if savedObject = params {
		return 1
	}
	
	if ($ISOBJECT(savedObject)) {
			set savedObject=savedObject.%ToJSON()
	}
		
	if ($ISOBJECT(params)) {
		set params=params.%ToJSON()
	}
	
	//w !, savedObject , " vs. " , params
	
	if (..CanConvertToJSON(savedObject)) && (..CanConvertToJSON(params)) {
		
		if ('$ISOBJECT(savedObject)) {
			set savedObject={}.%FromJSON(savedObject)
		}
		if ('$ISOBJECT(params)) {
			set params={}.%FromJSON(params)
		}
		
		if ((..CountAtributes(savedObject)) '= (..CountAtributes(params))) {
		return 0
		}

		
		set iterator = params.%GetIterator()
    
    	while iterator.%GetNext(.key, .value) {
    		if (savedObject.%Get(key) '= value) {
    			return 0
    		}
   
		}
    	return 1
		
	
	}
	
	return 0
}

ClassMethod CanConvertToJSON(obj)
{
	set item = ".*\:.*"
	
	//set regex = "\{(" _ item _ "|.*\:\s*" _  regex _ "|.*\:\s*\[" _ regex _ "\])*\}"
	

	
	//set regex = "\{(.*\:.*|.*\:{(.*\:.*)*}|.*\:\[(.*\:.*)*\]|(\,)*)*\}"
	
	set regex = "\{(.*\:.*)*\}"
	
	//w !, obj, "muze: ", $match(obj, regex)
	
	return $match(obj, regex)
}

ClassMethod CountAtributes(obj)
{
	set count = 0
	
	set iterator = obj.%GetIterator()
    
    while iterator.%GetNext(.key, .value) {
    	set count = count + 1
    }
    
    return count
}

}

Class MockFW.Utils Extends %RegisteredObject
{

/// Auxiliary method, which add multiple $$$TAB to line of generated code
ClassMethod Tabs(count)
{
	set res = ""
	for i=1:1:count {
		set res = res_$$$TAB
	}
	return res
}

/// Auxiliary method for retrieving from .csv.
/// Cut extra double quotes to secure saving
ClassMethod CutExtraQuotes(string As %String) As %String
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

/// Compare two strings (potentionally objects)
ClassMethod Compare(savedObject, params) As %Integer
{	
	if savedObject = params {
		return 1
	}
	
	if ($ISOBJECT(savedObject)) {
			set savedObject=savedObject.%ToJSON()
	}
		
	if ($ISOBJECT(params)) {
		set params=params.%ToJSON()
	}
	
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

/// Return '1' if the string can be transformed to the object, else '0'
/// Use regex syntax. Work right only for two layers of json object 
ClassMethod CanConvertToJSON(obj) As %Integer
{
	set objWithoutSpaces = $ZSTRIP(obj,"*W")

	set item = "\""[:alnum:]+\"""
	set element = item_"\:"_item
	set object = "\{("_element_"\,)*"_element_"\}"
	set array = "\[((("_element_"\,)*"_element_")|(("_object _"\,)*"_object_")|(("_item _"\,)*"_item_"))\]"

	set objectInObject = item_"\:"_object
	set arrayInObject = item_"\:"_array

	set regex = "\{((("_element_")|("_objectInObject_")|("_arrayInObject_"))\,)*(("_element_")|("_objectInObject_")|("_arrayInObject_"))\}"
	
	return $match(objWithoutSpaces, regex)
}

/// Auxiliary method. Count the atributes of object
ClassMethod CountAtributes(obj) As %Integer
{
	#dim count As %Integer = 0 
	set iterator = obj.%GetIterator()
    
    while iterator.%GetNext(.key, .value) {
    	set count = count + 1
    }
    
    return count
}

/// Transfrom arguments to the list as %ListOfDataTypes
ClassMethod TransformArgsToList(args...) As %List
{
   // Create a %ListOfDataTypes even though it may contain objects.
   #dim listArgs = ##class(%ListOfDataTypes).%New()
   #dim i AS %Integer
   for i = 1 : 1 : $get(args, 0)
   {
      do listArgs.Insert($get(args(i)))
   }
   
   quit listArgs
}

}

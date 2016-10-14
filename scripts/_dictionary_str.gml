///_dictionary_str(dictionary)
var out = "";
var prefix = "    ";
var dictionary = argument0;

for(var i = 0; i < ds_list_size(dictionary); i++)
    out += concat(prefix, i, ": ", _word_str(dictionary[|i]), "#");
    
return out; 

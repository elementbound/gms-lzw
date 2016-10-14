///rtdbg(str,...)
var __, str;
str="";
for(__=0; __<argument_count; __++)
    str+=string(argument[__]);
    
clipboard_set_text(string_replace_all(str, "#", chr(10))); 
    
//show_error(string_replace_all(str, "#", chr(10)), false);
show_message(str); 

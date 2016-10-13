///rtdbg(str,...)
var __, str;
str="";
for(__=0; __<argument_count; __++)
    str+=string(argument[__]);
    
//show_error(str, false);
show_message(str); 

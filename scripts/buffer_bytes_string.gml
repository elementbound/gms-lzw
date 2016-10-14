///buffer_bytes_string(buffer)
var buffer = argument0;
var out = "";

buffer_seek(buffer, buffer_seek_start, 0);
while(buffer_tell(buffer) < buffer_get_size(buffer)) 
    out += string(buffer_read(buffer, buffer_u8)) + " ";
    
return out; 

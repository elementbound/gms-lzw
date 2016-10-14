///buffer_compare(buff1, buff2)

var buff1, buff2;
buff1 = argument0;
buff2 = argument1;

if(buffer_get_size(buff1) != buffer_get_size(buff2))
    return false;

buffer_seek(buff1, buffer_seek_start, 0);
buffer_seek(buff2, buffer_seek_start, 0);

while(buffer_tell(buff1) < buffer_get_size(buff1))
    if(buffer_read(buff1, buffer_u8) != buffer_read(buff2, buffer_u8))
        return false;
        
return true; 

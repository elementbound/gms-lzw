///buffer_compress_lzw(src, dst)
var shrink_after = true;

var buff_in = argument[0];
if(argument_count > 1)
    var buff_out = argument[1];
else {
    var buff_out = buffer_create(2, buffer_grow, 2);
    shrink_after = true; 
}

buffer_seek(buff_in, buffer_seek_start, 0);

// TODO: store words in a priority queue sorted by length, so we can start with longest words 
// TODO: this is questionable tho 
var dictionary = ds_list_create(); 
var max_dict_size = 65536 - 256;

for(var i = 0; i < buffer_get_size(buff_in); i += 0) {
    // Find longest match 
    var match_id = -1;
    var match_length = -1;
    
    for(var j = 0; j < ds_list_size(dictionary)-1; j++) {
        var matched = true; 
        var word = dictionary[|j];
        
        // Word longer than remaining input
        if(i + ds_list_size(word) >= buffer_get_size(buff_in))
            continue;
            
        // Check for match
        buffer_seek(buff_in, buffer_seek_start, i); 
        
        for(var k = 0; k < ds_list_size(word); k++) {
            if(word[|k] != buffer_read(buff_in, buffer_u8)) {
                matched = false;
                break;
            }
        }
        
        // Store if matched 
        if(matched && ds_list_size(word) > match_length) {
            match_id = j;
            match_length = ds_list_size(word); 
        }
    }
    
    if(match_id >= 0) {
        // Output dict ref if matched
        buffer_write(buff_out, buffer_u16, match_id+256);
        
        // Seek buffer, multiple bytes consumed
        i += match_length; 
        buffer_seek(buff_in, buffer_seek_start, i);
        
        // Add new word 
        // ( if we don't overrun the dictionary AND there's an additional byte to read )
        if(ds_list_size(dictionary) < max_dict_size && i+1 < buffer_get_size(buff_in)) {
            var match_word = dictionary[|match_id];
            var new_word = ds_list_create();
            
            ds_list_copy(new_word, match_word); 
            ds_list_add(new_word, buffer_read(buff_in, buffer_u8));
            
            ds_list_add(dictionary, new_word); 
            ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
        }
    }
    else {
        // Otherwise output character as-is 
        // Seek buffer
        buffer_seek(buff_in, buffer_seek_start, i);
        
        var byte = buffer_read(buff_in, buffer_u8);
        buffer_write(buff_out, buffer_u16, byte);
        
        // Add new word 
        // ( if we don't overrun the dictionary AND there's an additional byte to read )
        if(ds_list_size(dictionary) < max_dict_size && i+1 < buffer_get_size(buff_in)) {
            var new_word = ds_list_create();
            ds_list_add(new_word, byte, buffer_read(buff_in, buffer_u8)); 
            
            ds_list_add(dictionary, new_word);
            ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
        }
        
        // Single byte consumed
        i++;
    }
}

if(shrink_after)
    buffer_shrink(buff_out); 
    
rtdbg("Input size: ", buffer_get_size(buff_in), "#", "Output size: ", buffer_get_size(buff_out), "#", "Dictionary size: ", ds_list_size(dictionary));
    
ds_list_destroy(dictionary); 
    
return buff_out; 

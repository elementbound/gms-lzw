///buffer_decompress_lzw(src, dst)
var shrink_after = true;

var buff_in = argument[0];
if(argument_count > 1)
    var buff_out = argument[1];
else {
    buff_out = buffer_create(1, buffer_grow, 1);
    shrink_after = true; 
}

buffer_seek(buff_in, buffer_seek_start, 0);

var dictionary = ds_list_create(); 
var last_word = 0;
var last_type = 0; // Nothing 

while(buffer_tell(buff_in) < buffer_get_size(buff_in)) {
    var value = buffer_read(buff_in, buffer_u16);
    
    if(value < 256) {
        // It's a simple value
        buffer_write(buff_out, buffer_u8, value);
        
        // Construct new word
        if(last_type == 1) {
            var new_word = ds_list_create(); 
            ds_list_add(new_word, last_word, value);
            
            ds_list_add(dictionary, new_word); 
            ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
        }
        else if(last_type == 2) {
            var new_word = ds_list_create(); 
            ds_list_copy(new_word, last_word);
            ds_list_add(new_word, value); 
            
            ds_list_add(dictionary, new_word); 
            ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
        }
           
        // Save last word
        last_word = value; 
        last_type = 1; // Single value
    }
    else {
        if(value-256 >= ds_list_size(dictionary)) {
            // New value is fetched from past dictionary
            // We gotta guess, because the decoder is always one entry behind 
        
            // Create next word as last_word + last_word[0]
            var new_word = ds_list_create();
            if(last_type == 1) 
                ds_list_add(new_word, last_word, last_word); 
            else if(last_type == 2) {
                ds_list_copy(new_word, last_word);
                ds_list_add(new_word, last_word[|0]); 
            }
            
            ds_list_add(dictionary, new_word); 
            ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
            
            // Output new word
            for(var i = 0; i < ds_list_size(new_word); i++) 
                buffer_write(buff_out, buffer_u8, new_word[|i]);
            
            last_word = new_word;
            last_type = 2; // Whole word
        }
        else {
            // Fetch from dictionary 
            word = dictionary[|value - 256];
            
            // Output whole word
            for(var i = 0; i < ds_list_size(word); i++) 
                buffer_write(buff_out, buffer_u8, word[|i]);
                
            // Construct new word
            if(last_type == 1) {
                var new_word = ds_list_create(); 
                ds_list_add(new_word, last_word);
                ds_list_add(new_word, word[|0]); 
                
                ds_list_add(dictionary, new_word); 
                ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
            }
            else if(last_type == 2) {
                var new_word = ds_list_create(); 
                ds_list_copy(new_word, last_word);
                ds_list_add(new_word, word[|0]); 
                
                ds_list_add(dictionary, new_word); 
                ds_list_mark_as_list(dictionary, ds_list_size(dictionary)-1); 
            }
                
            // Save last word
            last_word = word; 
            last_type = 2; // Whole word 
        }
    }
}

if(shrink_after)
    buffer_shrink(buff_out); 

ds_list_destroy(dictionary); 

return buff_out; 

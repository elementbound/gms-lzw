///buffer_decompress_lzw_async(src[, dst])
with(instance_create(0,0, task_lzw_decompress)) {
    shrink_after = true;
    
    buff_in = argument[0];
    
    if(argument_count > 1)
        buff_out = argument[1];
    else {
        buff_out = buffer_create(2, buffer_grow, 2);
        shrink_after = true; 
    }
    
    return id; 
}

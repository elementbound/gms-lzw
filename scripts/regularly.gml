///regularly(interval)
// Return true if a regular job is due
if(get_timer()/1000 - global.regularly_last > argument0) {
    global.regularly_last = get_timer()/1000;
    return true;
}

return false; 

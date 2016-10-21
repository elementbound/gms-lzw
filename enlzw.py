import sys
import os 
from time import sleep, clock  

import cProfile 

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

class timer:
	def __init__(self):
		self.last = -1
	
	def __call__(self, interval):
		if clock() - self.last > interval: 
			self.last = clock()
			return True 
		else:
			return False 
	

def progressbar(percent, width = 80):
	inner_width = width-2
	str = '[' + (' ' * inner_width) + ']'
	
	fill_length = int(percent*inner_width)
	str = str[0] + '='*fill_length + str[fill_length+1:]
	
	percent_str = '{}%'.format(int(percent*100))
	str_from = (width-len(percent_str)) / 2
	str_from = int(str_from)
	str = str[:str_from] + percent_str + str[str_from+len(percent_str):]
	
	print(str, end='\r')

def lzw_encode_into(buff_in, buff_out):
	dictionary = []
	MAX_DICT_SIZE = 65536 - 256
	byteorder = 'little'
	
	regularly = timer()
	
	i = 0
	while i < len(buff_in):
		# Debug section 
		if regularly(1) and i != 0:
			cls()
			
			progress = i / len(buff_in)
			expected_size = int(len(buff_out) / progress)
			
			print("Compressing", len(buff_in), "bytes")
			print("\t", "Dictionary size:", len(dictionary))
			print("\t", "Output size:", len(buff_out))
			print("\t", "Expected size:", expected_size, "=>", "{}%".format(int(100*expected_size / len(buff_in))))
			progressbar(progress)
			print()
	
		match_id = None
		
		# Look for match 
		for (word_id, word) in enumerate(dictionary): 
			# Word longer than remaining input 
			if len(word)+i >= len(buff_in):
				continue 
				
			# Store if matched 
			if word == buff_in[i:i+len(word)]:
				if match_id is None: 
					match_id = word_id
				elif len(word) > len(dictionary[match_id]):
					match_id = word_id 
					
		# Output 
		if match_id is None: 
			# No match, output value as-is 
			buff_out += buff_in[i].to_bytes(2, byteorder)
			
			# Add new dictionary entry 
			# ( if we don't overrun the dictionary AND there's an additional byte to read )
			if len(dictionary) < MAX_DICT_SIZE and i+1 < len(buff_in):
				new_word = bytes([buff_in[i], buff_in[i+1]])
				dictionary.append(new_word)
				
			# Single byte consumed 
			i += 1
		else: 
			# Output 
			buff_out += (match_id + 256).to_bytes(2, byteorder)
			
			# Add new dictionary entry 
			# ( if we don't overrun the dictionary AND there's an additional byte to read )
			if len(dictionary) < MAX_DICT_SIZE and i+1 < len(buff_in):
				new_word = dictionary[match_id] + bytes([buff_in[i+len(dictionary[match_id])]])
				dictionary.append(new_word)
				
			# Multiple bytes consumed 
			i += len(dictionary[match_id])
	
def lzw_encode(buffer):
	buff_out = bytearray()
	lzw_encode_into(buffer, buff_out)
	return buff_out
	
def main():
	if len(sys.argv) < 2:
		print("Usage: python", sys.argv[0], "<file>")
		return 0
		
	filename = sys.argv[1]
		
	# Read file 
	print('Reading file... ')
	buffer = None 
	with open(filename, 'rb') as f:
		buffer = f.read()
		
	# Compress or something 
	result = lzw_encode(buffer)
	
if __name__ == "__main__":
	main()
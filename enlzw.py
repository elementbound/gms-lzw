from time import sleep 

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

def main():
	for i in range(1, 100):
		progressbar(i/100)
		sleep(0.02)
		
	progressbar(1)
	
if __name__ == "__main__":
	main()
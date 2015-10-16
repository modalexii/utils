class InvalidColorFormat(Exception):
    pass

def rgb888(pixel):

	r = "{:02x}".format(pixel[0])
	b = "{:02x}".format(pixel[1])
	g = "{:02x}".format(pixel[2])

	return "0x{}{}{}".format(r,g,b)

def rgb565(pixel):

	r = "{:05b}".format(31 * pixel[0] / 255)
	b = "{:05b}".format(31 * pixel[2] / 255)
	g = "{:06b}".format(63 * pixel[1] / 255)

	return int("0b{}{}{}".format(r,g,b), 2)

def makeLiteralCArray(pixel_matrix):

	'''
	Given a 2d list representing the pixel matrix, return a string that
	can be pasted in to an Arduino sketch
	'''

	literal_c_array = ""

	for row in pixel_matrix:
		r = ""
		for p in row:
			r += "%s," % p
		r = "\t{%s},\n" % r[:-1]
		literal_c_array += r

	literal_c_array = "{\n%s\n};" % literal_c_array[:-2]

	return literal_c_array

def makePixelMatrix(image_file, color_format = "rgb565"):

	'''
	Given the path to an image, return a list of scan lines with each pixel
	in the specified format 
	'''

	from PIL import Image
	import numpy

	image = Image.open(image_file)
	raw_pixel_array = numpy.array(image)
	width = image.size[0]

	# make each a literal per color_format
	grb24_pixel_array = []
	for scanline in raw_pixel_array:
		for pixel in scanline:
			if color_format == "rgb565":
				grb24_pixel_array.append(rgb565(pixel))
			elif color_format == "rgb888":
				grb24_pixel_array.append(rgb888(pixel))
			else:
				raise InvalidColorFormat(
					"Invalid color_format \"{}\" passed to makePixelMatrix".format(color_format)
				)

	# break up data in to a (LxW) 2d list
	neomatrix_array = [grb24_pixel_array[x:x+width] for x in xrange(0, len(grb24_pixel_array), width)]

	return neomatrix_array


if __name__ == "__main__":

	'''
	Assume arg 0 is the path to an image and output the literal c array
	'''

	import argparse

	parser = argparse.ArgumentParser()
	parser.add_argument("image_file", help="path to the bitmap to convert", type=str)
	args = parser.parse_args()

	a = makePixelMatrix(args.image_file)
	a = makeLiteralCArray(a)
	print a



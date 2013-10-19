# turn anything from base64 back in to "raw" form
# run as b64decode.py <infile.txt> <outfile.whatever>

from base64 import b64decode
import sys

infile = sys.argv[1]
outfile = sys.argv[2]

with open(infile, "rb") as f:
    b64in = f.read()
    
raw = b64decode(b64in)
    
fout = open(outfile,"wb")
fout.write(raw)
fout.close()


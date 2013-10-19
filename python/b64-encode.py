# base-64 encode anything (images, binaries, etc) so it can be stored in a text document
# run as b64encode-py <infile.whatever> <outfile.txt>

import base64
import sys

infile = sys.argv[1]
outfile = sys.argv[2]

with open(infile, "rb") as f:
    orig_bin = f.read()
    orig_b64 = orig_bin.encode("base64")

fout = open(outfile,"wb")
fout.write(orig_b64)
fout.close()

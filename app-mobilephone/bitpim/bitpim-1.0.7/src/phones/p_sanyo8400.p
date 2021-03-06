### BITPIM
###
### Copyright (C) 2007 Stephen Wood <sawecw@users.sf.net>
###
### This program is free software; you can redistribute it and/or modify
### it under the terms of the BitPim license as detailed in the LICENSE file.
###
### $Id:$

%{

"""Various descriptions of data specific to Sanyo Katana (SCP-6600)"""

from prototypes import *

# Make all sanyo stuff available in this module as well
from p_sanyo import *
from p_sanyomedia import *
from p_sanyonewer import *
from p_sanyo4930 import *
from p_sanyo6600 import *
from p_sanyo7050 import *

# We use LSB for all integer like fields
UINT=UINTlsb
BOOL=BOOLlsb
NUMPHONEBOOKENTRIES=500
MAXNUMBERS=700
MAXEMAILS=1000
MAXURLS=500
MAXMEMOS=500
MAXADDRESSES=500
_NUMSPEEDDIALS=8
_NUMLONGNUMBERS=5
_LONGPHONENUMBERLEN=30
_NUMEVENTSLOTS=100
_NUMCALLALARMSLOTS=15
MAXNUMBERLEN=32
MAXEMAILLEN=96
MAXURLLEN=96
MAXMEMOLEN=96
HASRINGPICBUF=0
NUMGROUPS=20
NUMPHONENUMBERS=7
NUMEMAILS=2
FIRSTSPEEDDIAL=2
LASTSPEEDDIAL=9


%}


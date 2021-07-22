#!/usr/bin/env python3


# this custom script is necessary as the simpler:
#     python3 -m json.tool
# ... escapes UTF strings
# see:
#     https://stackoverflow.com/a/1920585/274677

import sys
import json

j = json.load(sys.stdin)
json.dump(j, sys.stdout, ensure_ascii=False, sort_keys=False, indent=4, separators=(',', ': '))

#!/usr/bin/env python

import flexget
import site

if __name__ == '__main__':
    site.addsitedir('/storage/.kodi/addons/service.deluge/lib/python2.7/site-packages')
    flexget.main()

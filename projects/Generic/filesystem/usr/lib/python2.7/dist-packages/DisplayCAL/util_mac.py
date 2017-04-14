# -*- coding: utf-8 -*-

import subprocess as sp
from time import sleep

from meta import name as appname
from options import verbose


def get_osascript_args(applescript):
	""" Return arguments ready to use for osascript """
	if isinstance(applescript, basestring):
		applescript = applescript.splitlines()
	args = []
	for line in applescript:
		args.extend(['-e', line])
	return args


def get_osascript_args_or_run(applescript, run=True):
	""" Return arguments ready to use for osascript or run the AppleScript """
	if run:
		return osascript(applescript)
	else:
		return get_osascript_args(applescript)


def mac_app_activate(delay=0, mac_app_name="Finder"):
	"""
	Activate (show & bring to front) an application if it is running.
	
	"""
	applescript = [
		'if app "%s" is running then' % mac_app_name,
			# Use 'run script' to prevent the app activating upon script
			# compilation even if not running
			r'run script "tell app \"%s\" to activate"' % mac_app_name,
		'end if'
	]
	if delay:
		sleep(delay)
	return osascript(applescript)


def mac_terminal_do_script(script=None, do=True):
	"""
	Run a script in Terminal.
	
	"""
	applescript = [
		'if app "Terminal" is running then',
			'tell app "Terminal"',
				'activate',
				'do script ""',  # Terminal is already running, open a new 
								 # window to make sure it is not blocked by 
								 # another process
			'end tell',
		'else',
			'tell app "Terminal" to activate',  # Terminal is not yet running, 
											    # launch & use first window
		'end if'
	]
	if script:
		applescript.extend([
			'tell app "Terminal"',
				'do script "%s" in first window' % script.replace('"', '\\"'),
			'end tell'
		])
	return get_osascript_args_or_run(applescript, script and do)


def mac_terminal_set_colors(background="black", cursor="gray", text="gray", 
							text_bold="gray", do=True):
	"""
	Set Terminal colors.
	
	"""
	applescript = [
		'tell app "Terminal"',
		'set background color of first window to "%s"' % background,
		'set cursor color of first window to "%s"' % cursor,
		'set normal text color of first window to "%s"' % text,
		'set bold text color of first window to "%s"' % text_bold,
		'end tell'
	]
	return get_osascript_args_or_run(applescript, do)


def osascript(applescript):
	"""
	Run AppleScript with the 'osascript' command
	
	Return osascript's exit code.
	
	"""
	args = get_osascript_args(applescript)
	p = sp.Popen(['osascript'] + args, stdin=sp.PIPE, stdout=sp.PIPE, 
				 stderr=sp.PIPE)
	output, errors = p.communicate()
	retcode = p.wait()
	return retcode, output, errors

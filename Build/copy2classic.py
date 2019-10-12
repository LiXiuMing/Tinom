import os

fileslist = [
	"AccountStat",
	"ChatStat",
	"Filter",
	"Locale",
	"Options",
	"Core.lua",
	"debug.lua",
	"README.md",
	"Tinom.lua",
	"Tinom.xml",
	"Tinom.toc",
]

fileslist2 = []

classic = "..\..\..\..\_classic_\Interface\AddOns\Tinom"

for file in fileslist:
	if os.path.isdir(file):
		for fileB in os.listdir(file):
			fileslist2.append(file+os.sep+fileB)
	else:
		fileslist2.append(file)

print(fileslist2)
for file in fileslist2:
	command = "copy "+file+" "+classic+os.sep+file
	print(command)
	os.system(command)

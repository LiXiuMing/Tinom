import zipfile, os
#TinomPath = r"F:/World of Warcraft/_retail_/Interface/AddOns/Tinom/"
fileslist = {
	"AccountStat/AccountStat.lua",
	"AccountStat/AccountStat.xml",
	"ChatStat/ChatStat.lua",
	"ChatStat/ChatStat.xml",
	"Filter/Filter.lua",
	"Filter/Filter.xml",
	"Locale/Locale.xml",
	"Locale/zhCN.lua",
	"Locale/enUS.lua",
	"Options/Options.lua",
	"Options/Options.xml",
	"Core.lua",
	"debug.lua",
	"README.md",
	"Tinom.lua",
	"Tinom.xml",
	"Tinom.toc",
}

Tinomtoc = open("Tinom.toc",mode='r',encoding='UTF-8')
TinomList = Tinomtoc.readlines()
long = len(TinomList[4])
version = TinomList[4][12:(long-1)]
Tinomtoc.close()
zipname = "Build/Tinom"+version+".zip"
# print(zipname)
with zipfile.ZipFile(zipname,mode='w') as target:
	for file in fileslist:
		target.write(file,"Tinom/"+file)
target.close()

# zfile = zipfile.ZipFile("Tinom.zip")
# print("压缩完成")
# print (zfile.namelist())
import zipfile, os
try:
    import zlib
    ziptype = zipfile.ZIP_DEFLATED
except:
    ziptype = zipfile.ZIP_STORED

fileslist = {
	"AccountStat",
	"ChatStat",
	"Filter",
	"Locale",
	"Options",
	"Media",
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

with zipfile.ZipFile(zipname,'w',ziptype) as target:
	for file in fileslist:
		if os.path.isdir(file):
			for fileB in os.listdir(file):
				target.write(file+os.sep+fileB,"Tinom/"+file+os.sep+fileB)
		else:
			target.write(file,"Tinom/"+file)
target.close()

Tinomzip = zipfile.ZipFile(zipname)
print(zipname+"压缩完成,共压缩文件:"+str(len(Tinomzip.namelist()))+"个.")
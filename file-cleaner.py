import shutil
import glob, os


def copy(src, target):
    path = os.path.dirname(target)  # 路径
    if not os.path.exists(path):
        os.makedirs(path)

    try:
        # https://stackoverflow.com/a/7420040/6800227
        shutil.copy(src, target)
    except shutil.SameFileError:
        print(f"覆盖 同名文件 {target}")


def getFiles(fileGlobs):
    fileNameList = []
    for fileGlob in fileGlobs:
        fileNameList.append(glob.glob(fileGlob, recursive=True))
    return fileNameList


def getIntercalationFiles(includeFileGlobs, ignoreFilesGlobs):
    includeFiles = getFiles(includeFileGlobs)
    ignoreFiles = getFiles(ignoreFilesGlobs)
    finalFiles = []
    for includeFile in includeFiles:
        skip = False
        for ignoreFile in ignoreFiles:
            if includeFile == ignoreFile:
                print(f"忽略：{includeFile}")
                skip = True
                break

        if not skip:
            finalFiles.append(includeFile)
    return finalFiles


def go(includeFileGlobs, ignoreFilesGlobs, DirSearch, DirCopyTo):
    for i in range(len(includeFileGlobs)):
        includeFileGlobs[i] = DirSearch + includeFileGlobs[i]

    for j in range(len(ignoreFilesGlobs)):
        ignoreFilesGlobs[j] = DirSearch + ignoreFilesGlobs[j]

    fileLists = getIntercalationFiles(includeFileGlobs, ignoreFilesGlobs)
    # todo 去重

    for fileList in fileLists:
        for file in fileList:
            fileName = os.path.basename(file)
            copyTo = DirCopyTo + fileName
            if file.replace("\\\\", "\\") == copyTo.replace("\\\\", "\\"):
                continue

            print(
                f"复制 {file} 到 {copyTo}",
            )
            if not debug:
                copy(file, copyTo)

    print("结束")


# --------------------------------------------------------------------------
# 可以通过这个，来先进行测试。
debug = False
# debug = True

# todo 修改为你自己的目录
# 可以包含多种模式。
includeFileGlobs = [
    r"**/南京*.mp4",  # 匹配目录以及子目录，下面，以南京开头，.mp4 结尾的路径。
    r"**/北京*.mp4",
]

ignoreFilesGlobs = [
    # r"**/北京*.mp4",
]

# todo 修改为你自己的目录
# 搜索的基准目录：目录以及其子目录
DirSearch = r"C:\Users\A\Desktop\测试目录\\"

# todo 修改为你自己的目录
# 新建的目录：
DirCopyTo = r"C:\Users\A\Desktop\测试目录\南京\\"

go(includeFileGlobs, ignoreFilesGlobs, DirSearch, DirCopyTo)

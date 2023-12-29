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


def getFiles(fileGlobs, root_dir):
    fileNameList = []
    for fileGlob in fileGlobs:
        fileNameList.append(glob.glob(fileGlob, root_dir=root_dir, recursive=True))
    return fileNameList


def getIntercalationFiles(includeFileGlobs, ignoreFilesGlobs, root_dir):
    includeFiles = getFiles(includeFileGlobs, root_dir)
    ignoreFiles = getFiles(ignoreFilesGlobs, root_dir)
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
    fileLists = getIntercalationFiles(includeFileGlobs, ignoreFilesGlobs, DirSearch)
    # todo 去重

    for fileList in fileLists:
        for file in fileList:
            fileName = os.path.basename(file)
            copyTo = DirCopyTo + fileName
            file = DirSearch + file
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
# debug = False
debug = True

# todo 修改为你自己的目录

# glob 匹配表达式的使用案例：https://pynative.com/python-glob/
# 可以包含多种模式。
includeFileGlobs = [
    r"**/南京*.mp4",  # 匹配目录以及子目录，下面，以南京开头，.mp4 结尾的路径。
    r"**/北京*.mp4",
]

ignoreFilesGlobs = [
    # r"**/北京*.mp4",
]

# todo 修改为你自己的目录
# 搜索的基准目录：会搜索到此目录以及其子目录
DirSearch = r"C:\Users\A\Desktop\测试目录\\"

# todo 修改为你自己的目录
# 新建的目录：
DirCopyTo = r"C:\Users\A\Desktop\测试目录\南京\\"

go(includeFileGlobs, ignoreFilesGlobs, DirSearch, DirCopyTo)

# pip install opencv-python
# py3.11 使用没问题
import cv2
import numpy as np
import glob, os

# 抠图去背景脚本。
# 参考：https://blog.csdn.net/my_name_is_learn/article/details/114364699
# hsv 色彩模式。https://www.cnblogs.com/lfri/p/10426113.html


def x(glob_express, bgRange, outputDir):
    print(glob_express)
    for image in glob.glob(glob_express, recursive=True):
        print("处理" + image)
        removeBackGroud(image, bgRange, outputDir)


def removeBackGroud(img, HsvRange, outputPath):
    imag_name = os.path.basename(img)  # 带后缀的文件名
    # path = os.path.dirname(img)  # 路径

    source = cv2.imread(img)
    hsv = cv2.cvtColor(source, cv2.COLOR_RGB2HSV)

    lower_BackGroudColor = np.array(HsvRange[0])
    upper_BackGroudColor = np.array(HsvRange[1])

    mask = cv2.inRange(hsv, lower_BackGroudColor, upper_BackGroudColor)

    mask_not = cv2.bitwise_not(mask)

    bg = cv2.bitwise_and(source, source, mask=mask)

    bg_not = cv2.bitwise_and(source, source, mask=mask_not)

    b, g, r = cv2.split(bg_not)

    bgra = cv2.merge([b, g, r, mask_not])

    if not os.path.exists(outputPath):
        os.makedirs(outputPath)

    cv2.imwrite(outputPath + imag_name, bgra)

    # 显示图片验证结果，opencv LOGO 图片
    # cv2.imshow("source", source)
    # cv2.imshow("bg", bg)
    # cv2.imshow("bg_not", bg_not)
    # cv2.waitKey()
    # cv2.destroyAllWindows()


inputDir = r"E:\code\open\ahks\imags-source\\"

bgRange = [[0, 0, 100], [0, 255, 255]]  # 白色背景

outputDir = r"E:\code\open\ahks\imags-apply\\"

x(inputDir + r"**/*.png", bgRange, outputDir)
x(inputDir + r"**/*.jpg", bgRange, outputDir)

print("结束")

## 使用

1. [截图适配](#截图适配若脚本功能不正常再来重新配置)
2. 配置自己的键位绑定，在 `user-config.ahk` 文件中。
3. 双击 `boot.ahk` 启动

## 目录结构说明

1. boot.ahk 主启动文件。它会依次加载，如下：

   - #Include %A_ScriptDir%\common.ahk ; **通用底层函数**
   - #Include %A_ScriptDir%\remove-blank-line.ahk ; remove-blank-line 相关代码
   - #Include %A_ScriptDir%\better-workflow.ahk ; better-workflow 相关代码
   - #Include %A_ScriptDir%\xunfei.ahk ; xunfei 相关代码
   - #Include %A_ScriptDir%\wechat-star.ahk ; wechat-star 相关代码
   - #Include %A_ScriptDir%\user-config.ahk ; **用户键位绑定**

2. imags-source 文件夹，为图片资源原始文件。

3. imags-apply 文件夹，为抠图之后的文件，相当于更加精细化。**在代码中的图片引用，使用的就是这个路径。**

4. kou_tu.py 自动抠图 python 脚本
5. file-cleaner.py 自动归类文件脚本

## 截图适配:（若脚本功能不正常，再来重新配置）

**截图技巧**：（为了，更好的点击，以及更好的保持图片唯一性和可识别性）
细长一点比较好。左上边缘。靠近可点击位置一点。右边缘可适当的放长一点。可参考已经截的图片。

**保存路径&自动扣背景[可选]**：
图片，保存到，imags-source 目录下。然后使用 kou_tu.py 脚本，对**白色**背景进行去除。生成最终使用的路径。imags-apply 下面。（如果，没有 python 执行环境，直接压缩包，发给我处理。）

如果，不需要自动扣背景。仅仅直接保存到 imags-apply 下面也行。

**格式与容错调试**
图片的格式，要求，png。
如果在截图之后，发现还是找不到。可看代码。调整，一下，\*n 参数。 比如\*20-\*100 等数值 ，调整图片搜索的容错率。例如下面的：

"*20 *TransBlack " imagePath("wechat_friend_moment.png")

**图片命名和内容**

1. 微信朋友圈点赞：
   - wechat_friend_moment.png
   - wechat_friend_star.png (用于确定处于，未点赞状态)
2. web 翻译部分：
   - translate_wordsLimit.png (用于定位文本框)
   - translate_ok.png ( 用于等待 google 网络响应 )
   - translate_speek.png（ 用于播放翻译结果 ）

还有其他，不一一介绍，参见 imags-source 文件夹。

- translate_ok.png
- translate_speek.png
- translate_wordsLimit.png
- wechat_friend_moment.png
- wechat_friend_star.png
- xunfei_change_blue.png
- xunfei_change_gray.png
- xunfei_putonghua.png
- xunfei_suishengyi.png
- xunfei_suishengyi_cn2en.png
- xunfei_suishengyi_cn2yue.png
- xunfei_suishengyi_more.png

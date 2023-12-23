AutoX = {
  press: (ele) => {
    var b = ele.bounds();
    // log(b);
    var x = random(1, b.right - b.left) + b.left;
    var y = random(1, b.bottom - b.top) + b.top;
    log("点击 (%d,%d)", x, y);
    return press(x, y, 1);
  },
  cleanInit: function (appName) {
    // console.log("清理脚本环境");
    this.stopOtherScript();
  },
  reloadApp: function (appName) {
    console.log("强制重启 %s", appName);
    this.killApp(appName);
    app.launchApp(appName);
  },
  killApp: function (name) {
    var packageName = getPackageName(name) || getAppName(name);
    if (!packageName) {
      log("找不到packageName" + packageName);
      return;
    }

    // 打开系统级应用设置  https://github.com/kkevsekk1/AutoX/issues/706

    log("打开app设置");
    app.openAppSetting(packageName);
    log("等待进入app设置 %s", packageName);
    sleep(random(1000, 2000));
    text(app.getAppName(packageName)).waitFor();
    log("进行盲点");
    // 执行盲点流程 （多点几次不过分。都是非阻塞的。）
    var times = 3; // 多点几次，应对页面上存在一些其他tips文字，干扰流程。
    do {
      stop();
      times--;
    } while (times);

    sleep(random(2000, 2300));
    back();

    // 盲点
    function stop() {
      var is_sure = textMatches(
        /(.{0,3}强.{0,3}|.{0,3}停.{0,3}|.{0,3}结.{0,3}|.{0,3}行.{0,3})/
      ).findOnce();
      if (is_sure) {
        is_sure.click();
        sleep(random(500, 600));
      }

      var b = textMatches(/(.*确.*|.*定.*)/).findOnce();
      if (b) {
        b.click();
        sleep(random(500, 600));
      }
    }
  },
  configConsole: (title) => {
    threads.start(() => {
      let dw = device.width;
      let dh = device.height;
      let cw = (dw * 4) / 10;
      let ch = (dh * 1) / 8;

      console.setTitle(title);
      console.show(true);
      console.setCanInput(false);

      console.setMaxLines(100);
      sleep(100); //等待一会，才能设置尺寸成功
      console.setSize(cw, ch); //需要前面等待一会
      console.setPosition(dw / 2 - cw, 0);
    });
  },
  stopOtherScript: () => {
    console.log("关闭其他脚本");
    engines.all().map((ScriptEngine) => {
      if (engines.myEngine().toString() !== ScriptEngine.toString()) {
        ScriptEngine.forceStop();
      }
    });
  },
  runActionForTextList: (textList) => {
    for (let t of textList) {
      log("执行 %s", t);
      try {
        let textEle = textMatches(t)
          .boundsInside(0, 0, device.width, device.height)
          .findOne(1000);

        if (!textEle) {
          log("没找到 %s", t);
          return;
        }

        if (textEle.clickable()) {
          log("点击 %s", textEle.text());
          if (!textEle.click()) {
            let clickSec = 2;
            log("点击不成功，持续点击 s"); //这种方式貌似不行呀。页面上元素位置是有的，也可以点击。但是就是没有显示出来。
            let startTime = new Date().getTime();
            var clickSuc = false;
            while (
              startTime + clickSec * 1000 < new Date().getTime() ||
              !clickSuc
            ) {
              clickSuc = textEle.click();
              sleep(30);
            }
          }
        } else {
          press(textEle.bounds().centerX(), textEle.bounds().centerY(), 1);
          log("按压 %s", textEle.text());
        }
        log("成功执行 %s", t);
      } catch (error) {
        log("执行失败 %s", t);
        return;
      }
    }
  },
  findInScreen: (eles) => {
    log("设备 w %d,h %d", device.width, device.height);
    var elesInScreen = [];
    for (var ele of eles) {
      var r = ele.bounds();
      log(r);
      if (
        device.width > r.right &&
        r.right >= 0 &&
        device.width > r.left &&
        r.left >= 0 &&
        device.height > r.top &&
        r.top >= 0 &&
        device.height > r.bottom &&
        r.bottom >= 0
      ) {
        elesInScreen.push(ele);
      }
    }
    return elesInScreen;
  },
  clickEle: function (ele) {
    // log(ele)
    if (ele) {
      if (ele.clickable()) {
        // log("点击");
        return ele.click();
      } else {
        // log("按压");
        return this.press(ele);
      }
    }
    return false;
  },
  pageDownBySwipe: () => {
    var h = device.height; //屏幕高
    var w = device.width; //屏幕宽
    // var x = (w / 3) * 2; //横坐标2/3处。
    var x = random((w * 1) / 3, (w * 2) / 3); //横坐标随机。防止检测。
    var h1 = (h / 6) * 5; //纵坐标6分之5处
    var h2 = h / 6; //纵坐标6分之1处
    swipe(x, h1, x, h2, 500); //向下翻页(从纵坐标6分之5处拖到纵坐标6分之1处)
  },
};

let PageViewer = {
  pageDo: () => {
    log("请设置");
  },
  loop: function (countLimit, pageDoFunc) {
    this.pageDo = pageDoFunc || this.pageDo;

    countLimit = countLimit;
    counter = 0;
    while (1) {
      this.pageDo();
      this.next();
      sleep(2000);
      counter++;
      if (counter > countLimit) {
        log("正常结束");
        break;
      }
    }
  },
  page: function (pageDoFunc) {
    this.pageDo = pageDoFunc || this.pageDo;
    this.pageDo();
  },
  next: function () {
    AutoX.pageDownBySwipe();
  },
};

// 配置点赞页数
var config = {
  pageCount: 5,
};

// 启动微信
AutoX.reloadApp("微信");
//进入朋友圈
id("icon_tv").text("发现").waitFor();
AutoX.runActionForTextList(["发现", "朋友圈"]);

// 翻页点赞
PageViewer.loop(config.pageCount, function () {
  r2s = AutoX.findInScreen(id("r2").find());
  for (r2 of r2s) {
    log(r2);
    AutoX.clickEle(r2);
    sleep(300);
    AutoX.runActionForTextList(["赞"]);
  }
});

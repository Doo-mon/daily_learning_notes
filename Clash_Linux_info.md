# Clash_for_Linux 使用教程（clash 已删库）

方便直接在服务器上面使用自己的代理

<!-- [github地址](https://github.com/wanhebin/clash-for-linux) -->

上面有很详细的步骤 可以直接按照上面的来弄

唯一有一点需要注意的是，他提供的脚本中 需要root权限才能使用 
（他会将两个函数写到 /etc/profile.d/clash.sh 方便直接在命令行中间直接使用）

可以改写代码 变为只修改当前用户的环境变量

在原来的 `start.sh` 脚本中的186行 修改成如下
**注：>表示覆盖写  ，  >>表示追加写 ， <<EOF表示识别到EOF时即结束**
```shell
# 添加环境变量(root权限)
# cat>/etc/profile.d/clash.sh<<EOF
cat>>~/.bashrc<<EOF

```

修改完成后，需要刷新一下环境变量才能生效
```shell
source ~/.bashrc
# 原start.sh脚本最下面有个echo提示，也可以顺手改掉
```

然后直接在命令行中输入下面这个就可以用了
```shell
# 开启
proxy_on
# 关闭
proxy_off
```
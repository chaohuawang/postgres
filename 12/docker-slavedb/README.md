```
采用docker 部署postgres从库
Dockfile 是给数据库添加postgresql-12-cron模块
将 docker-compose-linux-x86_64 放到/usr/local/bin/docker-compose
start-replica.sh 首次运行自动同步
docker-compose.yml 主部署文件 （首次启动前修改容器名和端口）
modiflyconfig.sh 启动后修改配置文件后再次重启 docker-compose 即可
```

1. 导出镜像

> docker save -o myimage.tar myimage:tag

2. 导入镜像

> docker load -i myimage.tar

3. build

> docker build -t myimage:tag .

4. tag
> docker tag my_local_image_name wangchaohua/postgres-cron:12

   or

> docker tag aedd3febf483 wangchaohua/postgres-cron:12






#!/bin/bash
set -e

PGDATA="/var/lib/postgresql/data"

echo "--- 检查数据卷状态：$PGDATA ---"

# 检查 PG_VERSION 文件是否存在，这是判断是否已初始化的关键
if [ ! -f "$PGDATA/PG_VERSION" ]; then
    echo "--- 数据卷为空或未初始化，开始执行 pg_basebackup ---"

    # 1. 确保复制所需的环境变量已设置
    if [ -z "$PRIMARY_HOST" ] || [ -z "$REPLICATION_PASSWORD" ]; then
        echo "错误：PRIMARY_HOST 或 REPLICATION_PASSWORD 环境变量未设置！"
        exit 1
    fi
    
    # 2. 导出 PGPASSWORD 供 pg_basebackup 使用
    export PGPASSWORD=$REPLICATION_PASSWORD
    
    # 3. 清空数据目录，以防任何 initdb 留下的痕迹干扰备份
    rm -rf "$PGDATA"/*

    # 4. 执行基础备份。
    # -R 选项会自动创建 standby.signal 和 primary_conninfo
    pg_basebackup \
        -h "$PRIMARY_HOST" \
        -p "$PRIMARY_PORT" \
        -U "$REPLICATION_USER" \
        -D "$PGDATA" \
        -Fp \
        -Xs \
        -v \
        -R \
        #--slot="$REPLICATION_SLOT"

    if [ $? -ne 0 ]; then
        echo "--- 致命错误：pg_basebackup 失败！请检查主库状态、网络、防火墙、用户权限和密码。 ---"
        # 备份失败，退出容器
        exit 1
    fi
    
    echo "--- 基础备份成功！从库已配置。 ---"

else
    echo "--- 数据卷已存在并包含数据，跳过基础备份。直接启动 PostgreSQL。 ---"
fi

# 最后的命令是调用 Docker 官方镜像的原始 Entrypoint 脚本，
# 启动 PostgreSQL 服务。因为数据目录下有 standby.signal，它会以从库模式启动。
echo "--- 启动 PostgreSQL 服务 ---"
# 注意：使用 exec 以确保进程 ID 1 是 PostgreSQL，利于 Docker 管理
exec docker-entrypoint.sh postgres

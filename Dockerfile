# 基于Debian 12 (bookworm) slim版本构建，amd64架构
FROM debian:bookworm-slim

# 完整的环境变量配置（覆盖SteamCMD所有运行需求）
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    # SteamCMD 核心路径
    STEAMCMD_DIR=/opt/steamcmd \
    PATH="$STEAMCMD_DIR:$PATH" \
    # 32位库路径（SteamCMD是32位程序，必须指定）
    LD_LIBRARY_PATH="/lib32:/usr/lib32:$STEAMCMD_DIR:$LD_LIBRARY_PATH" \
    # 字符编码（SteamCMD日志/交互必需）
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    # SteamCMD 非交互运行标识
    STEAMCMD_FORCE_BITNESS=32 \
    TERM=xterm

# 安装依赖 + 配置环境 + 安装SteamCMD
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    # 你指定的核心库
    byobu \
    golang \
    libcurl4-gnutls-dev \
    libgl1-mesa-glx \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-mixer-2.0-0 \
    nodejs \
    vim \
    wget \
    unzip\
    # SteamCMD 必需依赖（含32位库）
    ca-certificates \
    curl \
    lib32gcc-s1 \
    ib32stdc++6 \
    lib32z1 \
    locales \
    tzdata \
    wget \
    # 清理缓存减小体积
    && rm -rf /var/lib/apt/lists/* \
    # 生成UTF-8 locale（匹配环境变量）
    && locale-gen en_US.UTF-8 \
    # 创建SteamCMD目录并下载安装
    && mkdir -p $STEAMCMD_DIR \
    && curl -sSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar xzf - -C $STEAMCMD_DIR \
    # 初始化SteamCMD并清理临时文件
    && $STEAMCMD_DIR/steamcmd.sh +quit \
    && rm -rf $STEAMCMD_DIR/steamapps /tmp/*

# 设置工作目录
WORKDIR /data

# 容器启动默认执行SteamCMD


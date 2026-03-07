# 基于Debian 12 (bookworm) slim版本构建，amd64架构
FROM ubuntu AS runner

# 完整的环境变量配置（覆盖SteamCMD所有运行需求）
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai 

# Install PAT dependencies
RUN apt-get update && \
    apt-get install -y libsdl2-2.0-0 libgl1 libstdc++6 libcurl3-gnutls libuuid1 \
    && apt-get remove -y aptitude \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# ========== 仅新增以下SteamCMD安装步骤（修复add-apt-repository缺失问题） ==========
# ========== 整合新脚本的SteamCMD规范安装逻辑 ==========
# 插入Steam交互提示自动应答
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# 安装SteamCMD（适配Debian 12 slim，启用i386架构+non-free源）
RUN dpkg --add-architecture i386 \
 && echo "deb http://deb.debian.org/debian bookworm non-free" >> /etc/apt/sources.list \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
 && rm -rf /var/lib/apt/lists/*

# 添加Unicode支持
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen en_US.UTF-8

# 创建SteamCMD全局软链接
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# 更新SteamCMD并验证版本
RUN steamcmd +quit

# 修复缺失的目录和库链接（确保SteamCMD运行正常）
RUN mkdir -p $HOME/.steam \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
 && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
 && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so
# ========== SteamCMD安装步骤结束 ==========


# 设置工作目录
WORKDIR /data
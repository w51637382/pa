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
     sudo add-apt-repository multiverse \
    sudo dpkg --add-architecture i386 \
    sudo apt update \
    sudo apt install lib32gcc1 steamcmd \ 
    && rm -rf /var/lib/apt/lists/*
# 设置工作目录
WORKDIR /data
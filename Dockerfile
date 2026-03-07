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
# ========== 仅新增以下SteamCMD安装步骤（原有内容完全保留） ==========
RUN set -eux; \
    # 1. 安装SteamCMD运行必需的32位依赖（不影响原有PAT依赖）
    apt-get update && apt-get install -y --no-install-recommends \
        lib32gcc-s1 lib32stdc++6 ca-certificates; \
    # 2. 启用multiverse源（Ubuntu安装steamcmd需要）
    add-apt-repository -y multiverse; \
    dpkg --add-architecture i386; \
    apt-get update; \
    # 3. 安装steamcmd（APT默认安装）
    apt-get install -y --no-install-recommends steamcmd; \
    # 4. 软链接到易调用路径（可选，不影响原有逻辑）
    ln -s /usr/games/steamcmd /usr/local/bin/steamcmd; \
    # 5. 清理缓存（保持和原有逻辑一致的清理方式）
    apt-get clean && rm -rf /var/lib/apt/lists/*;
# ========== SteamCMD安装步骤结束 ==========

# 设置工作目录
WORKDIR /data
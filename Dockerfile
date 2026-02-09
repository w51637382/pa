# 基于Debian 12 (bookworm) slim版本构建，amd64架构
FROM debian:bookworm-slim

# 完整的环境变量配置（覆盖SteamCMD所有运行需求）
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai 

RUN apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.21-1+deb11u1 \
		ca-certificates=20210119 \
		lib32z1=1:1.2.11.dfsg-2+deb11u2 \
  		ffmpeg \
		libsm6 \
		libxext6 \
  		libcurl3-gnutls \
    # 清理缓存减小体积
    && rm -rf /var/lib/apt/lists/* \
    # 生成UTF-8 locale（匹配环境变量）
    && locale-gen en_US.UTF-8 \
# 设置工作目录
WORKDIR /data

# 容器启动默认执行SteamCMD


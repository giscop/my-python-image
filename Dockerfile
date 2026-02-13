# 1. 选择基础镜像
FROM python:3.12-slim

# 2. 设置元数据
LABEL maintainer="yourname@example.com"
LABEL description="My Custom Python Environment"

# 3. 设置环境变量
# 防止 Python 生成 .pyc 文件
ENV PYTHONDONTWRITEBYTECODE=1
# 确保控制台输出不被缓存
ENV PYTHONUNBUFFERED=1
# 设置时区（可选，例如 Asia/Shanghai）
ENV TZ=Asia/Shanghai

# 4. 系统级依赖安装 (一次性安装常用工具)
# 这里的 git, curl, vim, gcc 是开发常备的，rm -rf 是为了减小体积
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    vim \
    build-essential \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 5. 工作目录
WORKDIR /workspace

# 6. 安装 Python 依赖
# 先升级 pip
RUN pip install --upgrade pip
# 复制依赖文件
COPY requirements.txt /tmp/requirements.txt
# 安装依赖 (使用清华源加速，如果网络好可去掉 -i 部分)
RUN pip install --no-cache-dir -r /tmp/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 7. 个性化配置 (可选)
# 比如配置 vimrc 或者 bashrc 别名
# RUN echo "alias ll='ls -alF'" >> ~/.bashrc

# 8. 默认命令
CMD ["python"]
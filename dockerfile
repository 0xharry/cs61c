ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE}
LABEL maintainer="harry0789@qq.com"

# build iEDA
ARG IEDA_REPO="https://gitee.com/oscc-project/iEDA.git#master"
ARG IEDA_WORKSPACE=/opt/iEDA

ENV IEDA_WORKSPACE=${IEDA_WORKSPACE}
ENV PATH=${iEDA_BINARY_DIR}:${PATH}
ENV TZ=Asia/Shanghai

# (docker build) --ssh default=$HOME/.ssh/id_rsa
ADD ${IEDA_REPO} ${IEDA_WORKSPACE}

RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install -y curl git openjdk-17-jre openssh-client python3 python3-pip && \
    apt-get autoremove -y && apt-get clean -y

RUN bash ${IEDA_WORKSPACE}/build.sh -b ${iEDA_BINARY_DIR} && \
    rm -rf ${iEDA_BUILD_DIR}

WORKDIR ${IEDA_WORKSPACE}

CMD ["/usr/bin/env", "bash", "-c", "iEDA -script scripts/docker/build_succeeded.tcl"]

FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates

# Скачиваем стабильный Xray-core
RUN curl -L -s https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
    && unzip xray.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/xray \
    && rm xray.zip

# Создаем конфиг с твоим UUID. В Render порт 10000 открыт по умолчанию
RUN mkdir -p /etc/xray && echo '{\
  "log": {"loglevel": "none"},\
  "inbounds": [{\
    "port": 10000,\
    "protocol": "vless",\
    "settings": {\
      "clients": [{"id": "7c9e3b1a-8f4d-4e2a-92b5-6d1a8e9c0f3d"}],\
      "decryption": "none"\
    },\
    "streamSettings": {\
      "network": "ws",\
      "wsSettings": {"path": "/private-vless-stream"}\
    }\
  }],\
  "outbounds": [{"protocol": "freedom"}]\
}' > /etc/xray/config.json

EXPOSE 10000
CMD ["/usr/local/bin/xray", "-config", "/etc/xray/config.json"]

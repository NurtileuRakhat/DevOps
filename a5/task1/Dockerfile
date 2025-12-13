FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    wget \
    xvfb \
    bzip2 \
    libgtk-3-0 \
    libdbus-glib-1-2 \
    libxt6 \
    libx11-xcb1 \
    libasound2 \
    libpci3 \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://ftp.mozilla.org/pub/firefox/releases/78.15.0esr/linux-x86_64/en-US/firefox-78.15.0esr.tar.bz2 \
    && tar -xjf firefox-78.15.0esr.tar.bz2 \
    && mv firefox /opt/firefox \
    && ln -s /opt/firefox/firefox /usr/bin/firefox \
    && rm firefox-78.15.0esr.tar.bz2

COPY start-firefox.sh /start-firefox.sh
RUN chmod +x /start-firefox.sh

CMD ["/start-firefox.sh"]

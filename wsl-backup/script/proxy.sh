#!/usr/bin/env sh
export win_ip=$(cat /etc/resolv.conf | grep -oP '(?<=nameserver\ ).*')
export proxy_port=10808

proxy() {
    export ALL_PROXY="http://${win_ip}:${proxy_port}"
    export all_proxy="http://${win_ip}:${proxy_port}"
    export HTTP_PROXY="http://${win_ip}:${proxy_port}"
    export http_proxy="http://${win_ip}:${proxy_port}"
    export HTTPS_PROXY="http://${win_ip}:${proxy_port}"
    export https_proxy="http://${win_ip}:${proxy_port}"
    echo "systemProp.http.proxyHost=${win_ip}
systemProp.http.proxyPort=${proxy_port}
systemProp.https.proxyHost=${win_ip}
systemProp.https.proxyPort=${proxy_port}" > ~/.gradle/gradle.properties
    #git config --global http.proxy "http://${win_ip}:${proxy_port}"
    #git config --global https.proxy "http://${win_ip}:${proxy_port}"
    #npm config set proxy "http://${win_ip}:${proxy_port}"
    #npm config set https-proxy "http://${win_ip}:${proxy_port}"
    #yarn config set proxy "http://${win_ip}:${proxy_port}"
    #yarn config set https-proxy "http://${win_ip}:${proxy_port}"
    #echo -e "Acquire::http::Proxy \"http://${win_ip}:${proxy_port}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf > /dev/null
    #echo -e "Acquire::https::Proxy \"http://${win_ip}:${proxy_port}\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf > /dev/null
    echo "Set Proxy!"
}

unproxy() {
    unset ALL_PROXY
    unset all_proxy
    unset HTTP_PROXY
    unset http_proxy
    unset HTTPS_PROXY
    unset https_proxy
    echo "" > ~/.gradle/gradle.properties
    #git config --global --unset http.proxy
    #git config --global --unset https.proxy
    #sudo sed -i -e '/Acquire::http::Proxy/d' /etc/apt/apt.conf.d/proxy.conf
    #sudo sed -i -e '/Acquire::https::Proxy/d' /etc/apt/apt.conf.d/proxy.conf
    echo "Unset Proxy!"
}

winip() {
    echo $win_ip
}

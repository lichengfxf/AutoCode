#!/bin/bash

# 企业微信通知插件
#
# 在每个阶段开始时发送通知到企业微信群
#

# 输出提示到企业微信群
function log_to_wechat() {
        local msg="$*"

        curl -sS 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=ba6572aa-dec6-40bf-ad55-xxxxxxxx' \
            -H 'Content-Type: application/json' \
                -d " { \"msgtype\": \"text\", \"text\": { \"content\": \"$msg\"} }"
}

log_to_wechat "$1 $2 $3"

exit 0
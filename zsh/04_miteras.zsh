function hello() {
  open -a MiTERASWVAgent

  curl --request POST \
           --url https://api.chatwork.com/v2/rooms/329656715/messages \
           --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
           --header 'accept: application/json' \
           --header 'content-type: application/x-www-form-urlencoded' \
           --data self_unread=0 \
           --data 'body=おはようございます。業務開始します'
}


function killMiteras() {
    pkill MiTERASWVAgent

    curl --request POST \
         --url https://api.chatwork.com/v2/rooms/329656715/messages \
         --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
         --header 'accept: application/json' \
         --header 'content-type: application/x-www-form-urlencoded' \
         --data self_unread=0 \
         --data 'body=業務終了します。お疲れ様でした'
}
function hello() {
  read "answer?出勤しますか？ (y/n): "
  if [[ $answer = "y" ]]; then
        curl --request POST \
                 --url https://api.chatwork.com/v2/rooms/${CHAT_WORK_ATTENDANCE_ROOM}/messages \
                 --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
                 --header 'accept: application/json' \
                 --header 'content-type: application/x-www-form-urlencoded' \
                 --data self_unread=0 \
                 --data 'body=おはようございます。業務開始します'
      else
        echo "出勤しませんでした"
      fi
}


function bye() {
  read "answer?退勤しますか？ (y/n): "
      if [[ $answer = "y" ]]; then
        curl --request POST \
             --url https://api.chatwork.com/v2/rooms/${CHAT_WORK_ATTENDANCE_ROOM}/messages \
             --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
             --header 'accept: application/json' \
             --header 'content-type: application/x-www-form-urlencoded' \
             --data self_unread=0 \
             --data 'body=業務終了します。お疲れ様でした'
      else
        echo "退勤しませんでした"
      fi
}
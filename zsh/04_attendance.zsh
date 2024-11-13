function hello() {
  read "answer?出勤しますか？ (y/n): "
  if [[ $answer = "y" ]]; then
#        open -a MiTERASWVAgent
        curl --request POST \
                 --url https://api.chatwork.com/v2/rooms/${CHAT_WORK_ATTENDANCE_ROOM}/messages \
                 --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
                 --header 'accept: application/json' \
                 --header 'content-type: application/x-www-form-urlencoded' \
                 --data self_unread=0 \
                 --data 'body=おはようございます。業務開始します'

#         RESPONSE=`curl -X POST -H "X-ChatWorkToken: $CHAT_WORK_TOKEN" "https://api.chatwork.com/v2/rooms/$CHAT_WORK_MY_ROOM/messages" -d "body=出勤"`
#         MESSAGE_ID=`echo $RESPONSE | jq .message_id | tr -d '"'`
#         sleep 1
#         curl -X DELETE -H "X-ChatWorkToken: $CHAT_WORK_TOKEN" "https://api.chatwork.com/v2/rooms/$CHAT_WORK_MY_ROOM/messages/$MESSAGE_ID"
      else
        echo "出勤しませんでした"
      fi
}


function bye() {
  read "answer?退勤しますか？ (y/n): "
      if [[ $answer = "y" ]]; then
#        pkill MiTERASWVAgent
        curl --request POST \
             --url https://api.chatwork.com/v2/rooms/${CHAT_WORK_ATTENDANCE_ROOM}/messages \
             --header "X-ChatWorkToken:  ${CHAT_WORK_TOKEN}" \
             --header 'accept: application/json' \
             --header 'content-type: application/x-www-form-urlencoded' \
             --data self_unread=0 \
             --data 'body=業務終了します。お疲れ様でした'

#        RESPONSE=`curl -X POST -H "X-ChatWorkToken: $CHAT_WORK_TOKEN" "https://api.chatwork.com/v2/rooms/$CHAT_WORK_MY_ROOM/messages" -d "body=退勤"`
#        MESSAGE_ID=`echo $RESPONSE | jq .message_id | tr -d '"'`
#        sleep 1
#        curl -X DELETE -H "X-ChatWorkToken: $CHAT_WORK_TOKEN" "https://api.chatwork.com/v2/rooms/$CHAT_WORK_MY_ROOM/messages/$MESSAGE_ID"
      else
        echo "退勤しませんでした"
      fi
}
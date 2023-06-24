#!/bin/bash

# 遍历目录下的所有 ivacydms.txt 文件
find . -name "ivacydms.txt" | while read file; do
  # 如果 ivacyping.log 文件存在则删除
  [ -e ivacyping.log ] && rm ivacyping.log
  # 读取 ivacydms.txt 文件中的每一个域名
  while read domain || [ -n "$domain" ]; do
    # 测试延迟
    delay="$(timeout --signal=SIGINT 1s ping -c 1 "$domain" | awk -F'/' 'END{print $5}')"
    # 判断是否 ping 通
    if [ -n "$delay" ]; then
      # 输出测试成功的结果
      echo "域名: $domain, 延迟: $delay ms"
      echo "域名: $domain, 延迟: $delay ms" >> ivacyping.log
    else
      # 记录无法 ping 通的域名
      echo "$domain 无法Ping通" 
    fi
  done < "$file"
done

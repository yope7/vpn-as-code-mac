#!/bin/bash

echo "=== L2TP over IPSec VPN 設定生成スクリプト ==="

# ユーザ入力
read -p "表示名（任意のVPN名）: " vpn_name
read -p "サーバアドレス（例：133.1.134.10）: " server_address
read -p "アカウント名（VPNユーザ名）: " account_name
read -s -p "パスワード（省略可、必要なら記述）: " vpn_password
echo
read -s -p "共有シークレット: " shared_secret
echo

# UUID 生成（macOSなら uuidgen コマンドあり）
uuid1=$(uuidgen)
uuid2=$(uuidgen)

# base64 エンコード（改行なし）
shared_secret_b64=$(echo -n "$shared_secret" | base64)

# ファイル出力
filename="${vpn_name// /_}.mobileconfig"

cat > "$filename" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>PayloadContent</key>
  <array>
    <dict>
      <key>PayloadType</key>
      <string>com.apple.vpn.managed</string>
      <key>PayloadVersion</key>
      <integer>1</integer>
      <key>PayloadIdentifier</key>
      <string>com.example.vpn.${vpn_name}</string>
      <key>PayloadUUID</key>
      <string>${uuid1}</string>
      <key>PayloadDisplayName</key>
      <string>${vpn_name}</string>
      <key>UserDefinedName</key>
      <string>${vpn_name}</string>
      <key>VPNType</key>
      <string>L2TP</string>
      <key>RemoteAddress</key>
      <string>${server_address}</string>
      <key>AuthenticationMethod</key>
      <string>SharedSecret</string>
      <key>SharedSecret</key>
      <data>${shared_secret_b64}</data>
      <key>AuthName</key>
      <string>${account_name}</string>
EOF

# パスワードがあれば追記
if [ -n "$vpn_password" ]; then
  echo "      <key>AuthPassword</key>" >> "$filename"
  echo "      <string>${vpn_password}</string>" >> "$filename"
fi

cat >> "$filename" <<EOF
    </dict>
  </array>
  <key>PayloadType</key>
  <string>Configuration</string>
  <key>PayloadVersion</key>
  <integer>1</integer>
  <key>PayloadIdentifier</key>
  <string>com.example.vpnconfig.${vpn_name}</string>
  <key>PayloadUUID</key>
  <string>${uuid2}</string>
  <key>PayloadDisplayName</key>
  <string>VPN Configuration - ${vpn_name}</string>
</dict>
</plist>
EOF

# ファイル確認
echo "✅ プロファイル '${filename}' を生成しました．"

# インストール確認
read -p "このVPN設定をmacOSにインストールしますか？(y/n): " answer
if [[ "$answer" == "y" ]]; then
  sudo profiles install -type configuration -path "$filename"
  echo "✅ インストール完了"
else
  echo "ℹ️ インストールはスキップされました"
fi

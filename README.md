# vpn-as-code-mac

VPN を as code で構築したい！（できてない）

## VPN-as-code-mac とは

macOS で L2TP over IPSec VPN 設定を自動生成し、プロファイルとして適用するツールです。

## やりたいこと

- macOS 用の VPN 設定を簡単にコード化
- L2TP over IPSec VPN の設定ファイル（.mobileconfig）を自動生成
- 生成したプロファイルをワンクリックで macOS にインストール

## 実行方法

1. リポジトリをクローン：

```bash
git clone https://github.com/yourusername/vpn-as-code-mac.git
```

2. スクリプトに実行権限を付与：

```bash
chmod +x vpn-as-code-mac.sh
```

3. スクリプトを実行：

```bash
./vpn-as-code-mac.sh
```

4. プロンプトに従って以下の情報を入力：

- VPN 接続の表示名
- VPN サーバーアドレス
- VPN アカウント名
- パスワード（オプション）
- 共有シークレット

1. 生成された mobileconfig ファイルを自動でインストールするか選択

- できたら自動でインストールしたかった...しかしセキュリティの都合でできないそうなので，手動でインストールする必要があります．
- name.mobileconfig をダブルクリックしてインストールしてください．( これもできなくて困っています．)

## 要件

- macOS 環境
